import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../repositories/messaging_repository.dart';

final messagingRepoProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl();
});

final conversationsProvider = FutureProvider<List<ConversationModel>>((ref) async {
  final repo = ref.watch(messagingRepoProvider);
  return repo.getConversations();
});

// Simple state based on a plain Notifier.family for Riverpod 3.x
class ChatMessagesNotifier extends Notifier<List<MessageModel>> {
  @override
  List<MessageModel> build() => [];
}

// Load messages for a conversation via a separate FutureProvider.family
final conversationMessagesProvider =
    FutureProvider.family<List<MessageModel>, String>((ref, conversationId) async {
  final repo = ref.watch(messagingRepoProvider);
  return repo.getMessages(conversationId);
});

// Mutable sent-messages overlay per conversation
class SentMessagesNotifier extends Notifier<List<MessageModel>> {
  @override
  List<MessageModel> build() => [];

  void add(MessageModel msg) {
    state = [...state, msg];
  }
}

final sentMessagesProvider =
    NotifierProvider<SentMessagesNotifier, List<MessageModel>>(
  SentMessagesNotifier.new,
);

// Combined provider: loaded messages + sent messages for a conversation
final chatMessagesProvider =
    Provider.family<AsyncValue<List<MessageModel>>, String>((ref, conversationId) {
  final loaded = ref.watch(conversationMessagesProvider(conversationId));
  final sent = ref.watch(sentMessagesProvider);

  return loaded.when(
    data: (msgs) {
      final combined = [...msgs, ...sent];
      return AsyncData(combined);
    },
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
});

// Helper to send a message
final messageSenderProvider = Provider<_MessageSender>((ref) {
  return _MessageSender(ref);
});

class _MessageSender {
  final Ref _ref;
  _MessageSender(this._ref);

  Future<void> sendMessage(
      String conversationId, String receiverId, String text) async {
    final repo = _ref.read(messagingRepoProvider);

    // Optimistic insert
    final optimistic = MessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'me',
      receiverId: receiverId,
      messageText: text,
      timestamp: DateTime.now(),
      isRead: true,
    );
    _ref.read(sentMessagesProvider.notifier).add(optimistic);

    // Persist
    await repo.sendMessage(conversationId, receiverId, text);

    // Refresh loaded messages
    _ref.invalidate(conversationMessagesProvider(conversationId));
  }
}
