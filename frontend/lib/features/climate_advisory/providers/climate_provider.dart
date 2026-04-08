import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/climate_service.dart';
import '../models/climate_model.dart';

final climateServiceProvider = Provider((ref) => ClimateService());

// Real-time weather and risk analysis cache with auto-refresh
final climateAdvisoryProvider = FutureProvider.autoDispose<ClimateAdvisoryResponse>((ref) async {
  final service = ref.watch(climateServiceProvider);
  
  try {
    return await service.fetchClimateAdvisory();
  } catch (e, stackTrace) {
    // Log error for debugging
    print('Climate Advisory Error: $e');
    print(stackTrace);
    
    // Rethrow to let the UI layer handle the error
    rethrow;
  }
});

// Provider for retry attempts
final climateAdvisoryRetryProvider = StateNotifierProvider.autoDispose<
    RetryNotifier,
    AsyncValue<ClimateAdvisoryResponse>>((ref) {
  return RetryNotifier(ref);
});

class RetryNotifier extends StateNotifier<AsyncValue<ClimateAdvisoryResponse>> {
  final Ref _ref;
  int _retryCount = 0;
  final int maxRetries = 3;

  RetryNotifier(this._ref) : super(const AsyncValue.loading()) {
    _fetchWithRetry();
  }

  Future<void> _fetchWithRetry() async {
    _retryCount = 0;
    
    while (_retryCount < maxRetries) {
      try {
        state = const AsyncValue.loading();
        final service = _ref.watch(climateServiceProvider);
        final result = await service.fetchClimateAdvisory();
        state = AsyncValue.data(result);
        return;
      } catch (e, stackTrace) {
        _retryCount++;
        
        if (_retryCount >= maxRetries) {
          state = AsyncValue.error(e, stackTrace);
          return;
        }
        
        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(seconds: _retryCount * 2));
      }
    }
  }

  void retry() {
    _fetchWithRetry();
  }
}
