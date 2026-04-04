class ConversationModel {
  final String id;
  final String participantId;
  final String participantName;
  final String participantRole; // 'farmer' or 'consumer'
  final String lastMessage;
  final DateTime lastUpdatedAt;
  final int unreadCount;
  final String? productRefId; // Optional product discussion

  ConversationModel({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.participantRole,
    required this.lastMessage,
    required this.lastUpdatedAt,
    required this.unreadCount,
    this.productRefId,
  });
}
