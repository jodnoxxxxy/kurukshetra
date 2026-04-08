import 'package:kurukshetra/features/chat/models/chat_message.dart';

abstract class ChatRepository {
  Stream<ChatMessage> get messageStream;
  Future<void> send(String message);
  Future<List<ChatMessage>> getHistory(String userId);
  Future<List<ChatMessage>> getMessages(String chatRoomId);
  Future<void> sendMessage(String chatRoomId, ChatMessage message);
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Stream<ChatMessage> get messageStream async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  @override
  Future<void> send(String message) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<ChatMessage>> getHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [];
  }

  @override
  Future<List<ChatMessage>> getMessages(String chatRoomId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock messages for demonstration
    return [
      ChatMessage(
        id: '1',
        text: 'Hello! I\'m interested in your organic wheat.',
        senderId: 'consumer_1',
        senderName: 'Priya Consumer',
        senderRole: 'consumer',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: '2',
        text: 'Hello! Yes, we have high-quality organic wheat available. What quantity are you looking for?',
        senderId: 'farmer_1',
        senderName: 'Ramesh Farmer',
        senderRole: 'farmer',
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
      ChatMessage(
        id: '3',
        text: 'I need about 50kg. Is it certified organic?',
        senderId: 'consumer_1',
        senderName: 'Priya Consumer',
        senderRole: 'consumer',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  @override
  Future<void> sendMessage(String chatRoomId, ChatMessage message) async {
    // Simulate network delay for sending message
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In a real implementation, this would send the message to a backend service
    // and potentially update a real-time database like Firebase Firestore
    // Message successfully queued for backend delivery.
  }
}
