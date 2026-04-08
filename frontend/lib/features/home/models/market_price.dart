class MarketPrice {
  final String cropId;
  final String cropName;
  final double currentPrice;
  final double percentChange;
  final String mandiName;
  final DateTime updatedAt;

  MarketPrice({
    required this.cropId,
    required this.cropName,
    required this.currentPrice,
    required this.percentChange,
    required this.mandiName,
    required this.updatedAt,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      cropId: json['cropId'] ?? '',
      cropName: json['cropName'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      percentChange: (json['percentChange'] ?? 0).toDouble(),
      mandiName: json['mandiName'] ?? '',
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class Mandi {
  final String id;
  final String name;
  final double distance;
  final bool isOpen;

  Mandi({
    required this.id,
    required this.name,
    required this.distance,
    required this.isOpen,
  });

  factory Mandi.fromJson(Map<String, dynamic> json) {
    return Mandi(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      isOpen: json['isOpen'] ?? false,
    );
  }
}
