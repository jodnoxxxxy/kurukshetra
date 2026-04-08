class ConsumerProduct {
  final String id;
  final String name;
  final double pricePerUnit;
  final String unit;
  final String farmerId;
  final String farmerName;
  final String farmLocation;
  final int organicScore;
  final String category;
  final String imageUrl;
  final String harvestDate;
  final String description;
  final String cultivationMethod;
  final String certification;

  // New deeply integrated transparency features
  final double distance; // Distance in km
  final int freshnessScore; // 1-100 based on harvest date
  final String soilHealth; // e.g. "Good"
  final String organicFertilizer; // e.g. "Used 100% Vermicompost"
  final String chemicalPesticides; // e.g. "None"
  final double marketPrice; // standard non-organic market price
  final String pricingReason; // Why it's priced higher
  final List<String> nutritionalBenefits;
  final List<String> recipeSuggestions;
  final bool isWeeklyBasket;

  ConsumerProduct({
    required this.id,
    required this.name,
    required this.pricePerUnit,
    required this.unit,
    required this.farmerId,
    required this.farmerName,
    required this.farmLocation,
    required this.organicScore,
    required this.category,
    required this.imageUrl,
    required this.harvestDate,
    required this.description,
    required this.cultivationMethod,
    required this.certification,
    this.distance = 0.0,
    this.freshnessScore = 100,
    this.soilHealth = 'Unknown',
    this.organicFertilizer = 'Unknown',
    this.chemicalPesticides = 'Unknown',
    this.marketPrice = 0.0,
    this.pricingReason = '',
    this.nutritionalBenefits = const [],
    this.recipeSuggestions = const [],
    this.isWeeklyBasket = false,
  });
}
