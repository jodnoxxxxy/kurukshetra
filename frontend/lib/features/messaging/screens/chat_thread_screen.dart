import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:intl/intl.dart';
import '../providers/messaging_provider.dart';

class ChatThreadScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String participantName;
  final String participantRole;
  final String participantId;

  const ChatThreadScreen({
    super.key,
    required this.conversationId,
    required this.participantName,
    required this.participantRole,
    required this.participantId,
  });

  @override
  ConsumerState<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends ConsumerState<ChatThreadScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final text = _messageController.text;
    _messageController.clear();

    ref.read(messageSenderProvider).sendMessage(
          widget.conversationId,
          widget.participantId,
          text,
        );

    Future.delayed(const Duration(milliseconds: 200), () {
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
    final messagesAsync = ref.watch(chatMessagesProvider(widget.conversationId));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: widget.participantRole == 'farmer'
                  ? Colors.green.shade100
                  : Colors.blue.shade100,
              child: Icon(
                widget.participantRole == 'farmer'
                    ? Icons.agriculture
                    : Icons.person,
                color: widget.participantRole == 'farmer'
                    ? AppColors.primaryGreen
                    : Colors.blue.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.participantName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  widget.participantRole.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.participantRole == 'farmer'
                        ? AppColors.primaryGreen
                        : Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                      child: Text('Start a conversation.',
                          style: TextStyle(color: Colors.grey)));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == 'me' ||
                        msg.senderId == 'farmer_me' ||
                        msg.senderId == 'consumer_me';
                    return _buildMessageBubble(
                        msg.messageText, isMe, _formatTime(msg.timestamp));
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Error: $err')),
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2))
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: AppColors.textSecondary),
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
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
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

  String _formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.primaryGreen : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 16),
              ),
              boxShadow: [
                if (!isMe)
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.textPrimary,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
