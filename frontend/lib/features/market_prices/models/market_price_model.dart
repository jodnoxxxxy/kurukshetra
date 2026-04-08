class MarketCrop {
  final String id;
  final String name;
  final String category;
  final String iconStr;

  MarketCrop({
    required this.id,
    required this.name,
    required this.category,
    required this.iconStr,
  });
}

class MarketPriceData {
  final String id;
  final String marketName;
  final String address;
  final double distanceKm;
  final int minPrice;
  final int maxPrice;
  final int modalPrice;
  final DateTime lastUpdated;

  MarketPriceData({
    required this.id,
    required this.marketName,
    required this.address,
    required this.distanceKm,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    required this.lastUpdated,
  });
}

class PriceTrendData {
  final DateTime date;
  final int price;

  PriceTrendData({
    required this.date,
    required this.price,
  });
}
