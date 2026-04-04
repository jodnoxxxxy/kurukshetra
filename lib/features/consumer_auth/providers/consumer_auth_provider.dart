import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/consumer_model.dart';
import '../repositories/consumer_auth_repository.dart';

final consumerAuthRepoProvider = Provider<ConsumerAuthRepository>((ref) {
  return ConsumerAuthRepositoryImpl();
});

class ConsumerAuthNotifier extends Notifier<ConsumerModel?> {
  @override
  ConsumerModel? build() => null;

  Future<void> register(ConsumerModel consumer, String password) async {
    final repo = ref.read(consumerAuthRepoProvider);
    final user = await repo.registerConsumer(consumer, password);
    state = user;
  }

  Future<void> login(String phone, String otp) async {
    final repo = ref.read(consumerAuthRepoProvider);
    final user = await repo.loginWithPhone(phone, otp);
    state = user;
  }

  void logout() {
    state = null;
  }
}

final consumerAuthProvider = NotifierProvider<ConsumerAuthNotifier, ConsumerModel?>(ConsumerAuthNotifier.new);
