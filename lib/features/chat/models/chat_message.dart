enum MessageType { text, image, location, product }

enum ChatType { farmerConsumer, aiSupport }

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String senderRole; // 'farmer' or 'consumer'
  final MessageType messageType;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata; // For product info, location data, etc.

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    this.messageType = MessageType.text,
    required this.timestamp,
    this.metadata,
  });

  bool get isFromFarmer => senderRole == 'farmer';
  bool get isFromConsumer => senderRole == 'consumer';
  bool get isFromAI => senderRole == 'ai';
}

class ChatRoom {
  final String id;
  final String farmerId;
  final String farmerName;
  final String consumerId;
  final String consumerName;
  final ChatType chatType;
  final DateTime lastMessageTime;
  final String lastMessage;
  final bool isActive;
  final List<ChatMessage> messages;

  ChatRoom({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.consumerId,
    required this.consumerName,
    required this.chatType,
    required this.lastMessageTime,
    required this.lastMessage,
    this.isActive = true,
    this.messages = const [],
  });
}
