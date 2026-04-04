class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String messageText;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.timestamp,
    required this.isRead,
  });
}
