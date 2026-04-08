import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kurukshetra/features/chat/models/chat_message.dart';
import 'package:kurukshetra/features/chat/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

class ChatState {
  final List<ChatMessage> messages;
  final List<ChatRoom> chatRooms;
  final ChatRoom? currentChatRoom;
  final bool isLoading;
  final String? errorMessage;
  final bool isOtherTyping;

  ChatState({
    this.messages = const [],
    this.chatRooms = const [],
    this.currentChatRoom,
    this.isLoading = false,
    this.errorMessage,
    this.isOtherTyping = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    List<ChatRoom>? chatRooms,
    ChatRoom? currentChatRoom,
    bool? isLoading,
    String? errorMessage,
    bool? isOtherTyping,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      chatRooms: chatRooms ?? this.chatRooms,
      currentChatRoom: currentChatRoom ?? this.currentChatRoom,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isOtherTyping: isOtherTyping ?? this.isOtherTyping,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  late final ChatRepository _repository;
  
  String? _currentUserId;
  String? _currentUserRole;
  String? _currentUserName;
  static const String _openRouterEndpoint = 'https://openrouter.ai/api/v1/chat/completions';

  @override
  ChatState build() {
    _repository = ref.read(chatRepositoryProvider);
    _initializeCurrentUser();
    return _loadInitialData();
  }

  Future<void> _initializeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString('user_id') ?? 'mock_user_id';
    _currentUserRole = prefs.getString('user_role') ?? 'farmer';
    _currentUserName = _currentUserRole == 'farmer' ? 'Ramesh Farmer' : 'Priya Consumer';
  }

  Future<void> _ensureCurrentUserLoaded() async {
    if (_currentUserId != null && _currentUserRole != null && _currentUserName != null) {
      return;
    }
    await _initializeCurrentUser();
  }

  ChatState _loadInitialData() {
    // Mock chat rooms for demonstration
    final mockChatRooms = [
      ChatRoom(
        id: 'krishi_ai',
        farmerId: 'ai_bot',
        farmerName: 'Krishi AI',
        consumerId: 'any',
        consumerName: 'User',
        chatType: ChatType.aiSupport,
        lastMessageTime: DateTime.now(),
        lastMessage: 'How can I help you today?',
        isActive: true,
      ),
      ChatRoom(
        id: '1',
        farmerId: 'farmer_1',
        farmerName: 'Ramesh Farmer',
        consumerId: 'consumer_1',
        consumerName: 'Priya Consumer',
        chatType: ChatType.farmerConsumer,
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        lastMessage: 'Is the wheat organic?',
        isActive: true,
      ),
    ];

    return ChatState(chatRooms: mockChatRooms);
  }

  Future<void> selectChatRoom(ChatRoom? chatRoom) async {
    await _ensureCurrentUserLoaded();

    if (chatRoom == null) {
      state = ChatState(
        messages: [],
        chatRooms: state.chatRooms,
        currentChatRoom: null,
        isLoading: false,
        isOtherTyping: false,
      );
      return;
    }
    
    state = state.copyWith(currentChatRoom: chatRoom, isLoading: true);
    
    // Load messages for the selected chat room
    List<ChatMessage> messages = [];
    if (chatRoom.id == 'krishi_ai') {
       // Start with a welcome message if empty
       messages = [
         ChatMessage(
           id: 'welcome',
           text: 'Hello! I am Krishi AI, your agricultural assistant. I can help you with crop advice, pest detection, and market prices. How can I assist you today?',
           senderId: 'ai',
           senderName: 'Krishi AI',
           senderRole: 'ai',
           timestamp: DateTime.now().subtract(const Duration(seconds: 1)),
         )
       ];
    } else {
       messages = await _repository.getMessages(chatRoom.id);
    }
    
    state = state.copyWith(
      currentChatRoom: chatRoom,
      messages: messages,
      isLoading: false,
    );
  }

  Future<void> sendMessage(String text) async {
    await _ensureCurrentUserLoaded();
    if (text.trim().isEmpty || state.currentChatRoom == null || _currentUserId == null) return;

    final newMessage = ChatMessage(
      id: DateTime.now().toString(),
      text: text,
      senderId: _currentUserId!,
      senderName: _currentUserName!,
      senderRole: _currentUserRole!,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, newMessage],
      isOtherTyping: true,
    );

    try {
      if (state.currentChatRoom!.id == 'krishi_ai') {
        final history = state.messages
            .where((m) => m.id != newMessage.id && m.id != 'welcome')
            .map((m) => {
                  'role': m.isFromAI ? 'assistant' : 'user',
                  'content': m.text,
                })
            .toList();

        final responseText = await _getKrishiAiResponse(text, history);

        final responseMessage = ChatMessage(
          id: DateTime.now().toString(),
          text: responseText,
          senderId: 'ai',
          senderName: 'Krishi AI',
          senderRole: 'ai',
          timestamp: DateTime.now(),
        );

        state = state.copyWith(
          messages: [...state.messages, responseMessage],
          isOtherTyping: false,
        );
      } else {
        await _repository.sendMessage(state.currentChatRoom!.id, newMessage);

        await Future.delayed(const Duration(seconds: 2));

        final responseMessage = ChatMessage(
          id: DateTime.now().toString(),
          text: _generateMockResponse(text),
          senderId: _getOtherUserId(),
          senderName: _getOtherUserName(),
          senderRole: _currentUserRole == 'farmer' ? 'consumer' : 'farmer',
          timestamp: DateTime.now(),
        );

        state = state.copyWith(
          messages: [...state.messages, responseMessage],
          isOtherTyping: false,
        );
      }
    } catch (e) {
      final fallbackMessage = state.currentChatRoom!.id == 'krishi_ai'
          ? _generateKrishiAiFallback(text)
          : 'Failed to send message';

      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
            id: DateTime.now().toString(),
            text: fallbackMessage,
            senderId: 'ai',
            senderName: 'Krishi AI',
            senderRole: 'ai',
            timestamp: DateTime.now(),
          ),
        ],
        errorMessage: state.currentChatRoom!.id == 'krishi_ai' ? null : 'Failed to send message',
        isOtherTyping: false,
      );
    }
  }

  Future<String> _getKrishiAiResponse(
    String userText,
    List<Map<String, String>> history,
  ) async {
    final apiKey = const String.fromEnvironment('OPENROUTER_API_KEY');
    if (apiKey.isEmpty) {
      return _generateKrishiAiFallback(userText);
    }

    try {
      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content':
              'You are Krishi AI, an expert agricultural assistant for Indian farmers. '
                  'Keep answers practical, short, and action-oriented. Include safety and local context.',
        },
        ...history,
        {
          'role': 'user',
          'content': userText,
        },
      ];

      final response = await http
          .post(
            Uri.parse(_openRouterEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
              'HTTP-Referer': 'https://kurukshetra.app',
            },
            body: jsonEncode({
              'model': 'openai/gpt-4o-mini',
              'messages': messages,
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'] as List<dynamic>?;
        final content = choices != null && choices.isNotEmpty
            ? (choices.first['message']?['content'] as String?)
            : null;
        if (content != null && content.trim().isNotEmpty) {
          return content.trim();
        }
      }
    } catch (_) {
      // Fall back to local guidance when network/API is unavailable.
    }

    return _generateKrishiAiFallback(userText);
  }

  String _generateKrishiAiFallback(String userText) {
    final q = userText.toLowerCase();

    if (q.contains('pest') || q.contains('disease') || q.contains('कीड') || q.contains('रोग')) {
      return 'For pest issues: 1) Share a clear leaf photo, 2) Isolate affected plants, 3) Use neem-based spray first, 4) Recheck in 48 hours. If spread is fast, contact local agri officer.';
    }

    if (q.contains('price') || q.contains('market') || q.contains('भाव') || q.contains('मंडी')) {
      return 'For better selling price: compare 2-3 nearby mandis, check 7-day trend, and avoid distress sale on sudden dips. I can help with a crop-specific timing strategy.';
    }

    if (q.contains('soil') || q.contains('npk') || q.contains('ph') || q.contains('माती')) {
      return 'For soil improvement: maintain pH near crop range, add organic matter, and apply NPK based on test values. Share your N, P, K, pH and rainfall for a precise suggestion.';
    }

    if (q.contains('water') || q.contains('irrigation') || q.contains('पाणी') || q.contains('सिंचन')) {
      return 'For irrigation: prefer morning watering, use mulching to reduce evaporation, and avoid overwatering at flowering stage. Drip irrigation gives best efficiency.';
    }

    return 'I am available and working. Please ask crop-wise: soil test values, pest symptoms, irrigation issue, or market timing, and I will give step-by-step guidance.';
  }

  String _generateMockResponse(String userMessage) {
    final responses = [
      'That sounds great! When can we arrange delivery?',
      'Is the product certified organic?',
      'What\'s the best price you can offer for bulk orders?',
      'Can you share more details about the farming practices?',
      'I\'m interested in placing an order. How do we proceed?',
    ];
    return responses[userMessage.hashCode % responses.length];
  }

  String _getOtherUserId() {
    if (state.currentChatRoom == null) return 'other_user';
    return _currentUserRole == 'farmer' 
        ? state.currentChatRoom!.consumerId 
        : state.currentChatRoom!.farmerId;
  }

  String _getOtherUserName() {
    if (state.currentChatRoom == null) return 'Other User';
    return _currentUserRole == 'farmer' 
        ? state.currentChatRoom!.consumerName 
        : state.currentChatRoom!.farmerName;
  }

  Future<void> createNewChatRoom(String farmerId, String farmerName) async {
    if (_currentUserId == null || _currentUserRole != 'consumer') return;

    final newChatRoom = ChatRoom(
      id: DateTime.now().toString(),
      farmerId: farmerId,
      farmerName: farmerName,
      consumerId: _currentUserId!,
      consumerName: _currentUserName!,
      chatType: ChatType.farmerConsumer,
      lastMessageTime: DateTime.now(),
      lastMessage: 'Chat started',
    );

    state = state.copyWith(
      chatRooms: [...state.chatRooms, newChatRoom],
      currentChatRoom: newChatRoom,
      messages: [],
    );
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(() {
  return ChatNotifier();
});
