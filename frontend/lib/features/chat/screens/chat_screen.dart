import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/chat/providers/chat_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/features/chat/models/chat_message.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentUserRole;

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
  }

  Future<void> _initializeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserRole = prefs.getString('user_role');
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text;
    _messageController.clear();

    ref.read(chatProvider.notifier).sendMessage(message);

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final l10n = AppLocalizations.of(context)!;

    // Show chat rooms list if no room is selected
    if (chatState.currentChatRoom == null) {
      return _buildChatRoomsList(chatState, l10n);
    }

    final isAI = chatState.currentChatRoom?.id == 'krishi_ai';
    final otherName = isAI ? l10n.krishiAiName : (_currentUserRole == 'farmer' ? chatState.currentChatRoom!.consumerName : chatState.currentChatRoom!.farmerName);
    final otherSubtitle = isAI ? l10n.krishiAiSubtitle : (_currentUserRole == 'farmer' ? 'Consumer' : 'Farmer');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: isAI ? Colors.orange.shade700 : AppColors.primaryGreen,
              child: Icon(
                isAI ? Icons.auto_awesome : (_currentUserRole == 'farmer' ? Icons.shopping_bag : Icons.agriculture),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(otherName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(otherSubtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
        actions: [
          if (!isAI) IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(chatProvider.notifier).selectChatRoom(null);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message = chatState.messages[index];
                final isMe = (_currentUserRole == 'farmer' && message.isFromFarmer) ||
                           (_currentUserRole == 'consumer' && message.isFromConsumer);
                
                return _buildMessageBubble(
                  message.text,
                  isMe,
                  message.isFromAI ? l10n.krishiAiName : message.senderName,
                  _formatTime(message.timestamp),
                  message.isFromAI,
                );
              },
            ),
          ),
          
          if (chatState.isOtherTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: isAI ? Colors.orange.shade700 : Colors.grey.shade400,
                    child: Icon(
                      isAI ? Icons.auto_awesome : (_currentUserRole == 'farmer' ? Icons.shopping_bag : Icons.agriculture),
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isAI ? l10n.krishiAiTyping : 'Typing...', 
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)
                    ),
                  ),
                ],
              ),
            ),

          // Chat Input Area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, -2))
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: isAI ? l10n.krishiAiPrompt : 'Type a message...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        minLines: 1,
                        maxLines: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatRoomsList(ChatState chatState, AppLocalizations l10n) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentUserRole == 'farmer' ? l10n.consumersLabel : l10n.farmersLabel),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: chatState.chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = chatState.chatRooms[index];
          return _buildChatRoomCard(chatRoom, l10n);
        },
      ),
    );
  }

  Widget _buildChatRoomCard(ChatRoom chatRoom, AppLocalizations l10n) {
    final isAI = chatRoom.id == 'krishi_ai';
    final otherUserName = isAI ? l10n.krishiAiName : (_currentUserRole == 'farmer' 
        ? chatRoom.consumerName 
        : chatRoom.farmerName);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAI ? Colors.orange.shade700 : AppColors.primaryGreen,
          child: Icon(
            isAI ? Icons.auto_awesome : (_currentUserRole == 'farmer' ? Icons.shopping_bag : Icons.agriculture),
            color: Colors.white,
          ),
        ),
        title: Text(otherUserName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          isAI ? l10n.krishiAiSubtitle : chatRoom.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isAI ? null : Text(
          _formatTime(chatRoom.lastMessageTime),
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        onTap: () {
          ref.read(chatProvider.notifier).selectChatRoom(chatRoom);
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}';
  }

  Widget _buildMessageBubble(String text, bool isMe, String senderName, String time, bool isAI) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAI) Icon(Icons.auto_awesome, size: 12, color: Colors.orange.shade700),
                if (isAI) const SizedBox(width: 4),
                Text(
                  senderName,
                  style: TextStyle(fontSize: 11, color: isAI ? Colors.orange.shade900 : Colors.grey.shade600, fontWeight: isAI ? FontWeight.bold : FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primaryGreen : (isAI ? Colors.orange.shade50 : Colors.white),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))
              ],
              border: isMe ? null : Border.all(color: isAI ? Colors.orange.shade200 : Colors.grey.shade200),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
