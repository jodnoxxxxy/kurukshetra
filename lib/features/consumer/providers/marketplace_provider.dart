import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/consumer_product.dart';
import '../repositories/marketplace_repository.dart';

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepositoryImpl();
});

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setCategory(String category) {
    state = category;
  }
}

final marketplaceCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String>(SelectedCategoryNotifier.new);

final marketplaceFeedProvider = FutureProvider<List<ConsumerProduct>>((ref) async {
  final category = ref.watch(marketplaceCategoryProvider);
  final repo = ref.watch(marketplaceRepositoryProvider);
  return repo.getMarketplaceFeed(category);
});
