import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class MessagingRepository {
  Future<List<ConversationModel>> getConversations();
  Future<List<MessageModel>> getMessages(String conversationId);
  Future<MessageModel> sendMessage(String conversationId, String receiverId, String text);
}

class MessagingRepositoryImpl implements MessagingRepository {
  // Simulated initial mock data logic
  
  final List<ConversationModel> _conversations = [
    ConversationModel(
      id: 'conv_1',
      participantId: 'farmer_1',
      participantName: 'Shreyash Dalvi',
      participantRole: 'farmer',
      lastMessage: 'Yes, the tomatoes are completely organic.',
      lastUpdatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 1,
    ),
    ConversationModel(
      id: 'conv_2',
      participantId: 'consumer_2',
      participantName: 'Ramesh Patil',
      participantRole: 'consumer',
      lastMessage: 'I will pick up the order tomorrow.',
      lastUpdatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
  ];

  final Map<String, List<MessageModel>> _messages = {
    'conv_1': [
      MessageModel(
        id: 'msg_1',
        conversationId: 'conv_1',
        senderId: 'consumer_me',
        receiverId: 'farmer_1',
        messageText: 'Hi, are your tomatoes 100% organic?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isRead: true,
      ),
      MessageModel(
        id: 'msg_2',
        conversationId: 'conv_1',
        senderId: 'farmer_1',
        receiverId: 'consumer_me',
        messageText: 'Yes, the tomatoes are completely organic.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
    ],
    'conv_2': [
      MessageModel(
        id: 'msg_3',
        conversationId: 'conv_2',
        senderId: 'consumer_2',
        receiverId: 'farmer_me',
        messageText: 'I will pick up the order tomorrow.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
    ],
  };

  @override
  Future<List<ConversationModel>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _conversations;
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _messages[conversationId] ?? [];
  }

  @override
  Future<MessageModel> sendMessage(String conversationId, String receiverId, String text) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final newMsg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: 'me', // Generic local user
      receiverId: receiverId,
      messageText: text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    if (_messages.containsKey(conversationId)) {
      _messages[conversationId]!.add(newMsg);
    } else {
      _messages[conversationId] = [newMsg];
    }
    
    return newMsg;
  }
}
