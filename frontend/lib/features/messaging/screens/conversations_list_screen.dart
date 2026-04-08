import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../providers/messaging_provider.dart';
import '../models/conversation_model.dart';

class ConversationsListScreen extends ConsumerWidget {
  const ConversationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return const Center(child: Text('No messages yet.'));
          }

          return ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
            itemBuilder: (context, index) {
              final conv = conversations[index];
              return _buildConversationTile(context, conv);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/chat'), // Navigate to Krushi AI Chat
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, ConversationModel conv) {
    final bool hasUnread = conv.unreadCount > 0;
    
    // Formatting Last updated Time
    String timeString;
    final now = DateTime.now();
    final difference = now.difference(conv.lastUpdatedAt);
    if (difference.inDays == 0) {
      timeString = DateFormat.jm().format(conv.lastUpdatedAt);
    } else if (difference.inDays < 7) {
      timeString = DateFormat('EEEE').format(conv.lastUpdatedAt);
    } else {
      timeString = DateFormat('dd MMM').format(conv.lastUpdatedAt);
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        context.push('/messaging/thread', extra: {
          'conversationId': conv.id,
          'participantName': conv.participantName,
          'participantRole': conv.participantRole,
          'participantId': conv.participantId,
        });
      },
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: conv.participantRole == 'farmer' ? Colors.green.shade100 : Colors.blue.shade100,
        child: Icon(
          conv.participantRole == 'farmer' ? Icons.agriculture : Icons.person,
          color: conv.participantRole == 'farmer' ? AppColors.primaryGreen : Colors.blue.shade700,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              conv.participantName,
              style: TextStyle(
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            timeString,
            style: TextStyle(
              fontSize: 12,
              color: hasUnread ? AppColors.primaryGreen : Colors.grey.shade500,
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                conv.lastMessage,
                style: TextStyle(
                  color: hasUnread ? Colors.black87 : Colors.grey.shade600,
                  fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasUnread)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '\${conv.unreadCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
