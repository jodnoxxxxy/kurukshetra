import '../models/consumer_product.dart';

abstract class MarketplaceRepository {
  Future<List<ConsumerProduct>> getMarketplaceFeed(String? category);
}

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  @override
  Future<List<ConsumerProduct>> getMarketplaceFeed(String? category) async {
    await Future.delayed(const Duration(seconds: 1));

    final List<ConsumerProduct> allProducts = [
      ConsumerProduct(
        id: '1',
        name: 'Organic Tomatoes',
        pricePerUnit: 45.0,
        unit: 'kg',
        farmerId: 'frm_101',
        farmerName: 'Ramesh Kumar',
        farmLocation: 'Pune, Maharashtra',
        organicScore: 95,
        category: 'Vegetables',
        imageUrl: '🍅',
        harvestDate: 'Harvested Today',
        description: 'Freshly harvested organic tomatoes grown without any synthetic pesticides. Perfect for salads and cooking.',
        cultivationMethod: 'Natural Farming (Zero Budget)',
        certification: 'NPOP Certified Organic',
        distance: 12.5,
        freshnessScore: 98,
        soilHealth: 'Excellent (High NPK)',
        organicFertilizer: 'Used 100% Vermicompost',
        chemicalPesticides: 'None (Used Neem Oil Spray)',
        marketPrice: 35.0,
        pricingReason: 'Chemical-free farming, 100% hand-picked.',
        nutritionalBenefits: ['High in Vitamin C', 'Rich in antioxidants (Lycopene)'],
        recipeSuggestions: ['Organic Tomato Soup', 'Fresh Farm Salad'],
      ),
      ConsumerProduct(
        id: '100', // Mock weekly basket
        name: 'Weekly Organic Basket',
        pricePerUnit: 500.0,
        unit: 'basket',
        farmerId: 'frm_101',
        farmerName: 'Ramesh Kumar',
        farmLocation: 'Pune, Maharashtra',
        organicScore: 95,
        category: 'Vegetables',
        imageUrl: '🧺',
        harvestDate: 'Sourced Today',
        description: 'A complete family basket containing 2kg tomatoes, 1kg spinach, 1kg carrots, and fresh herbs.',
        cultivationMethod: 'Community Supported Agriculture',
        certification: 'NPOP Certified',
        distance: 12.5,
        freshnessScore: 100,
        soilHealth: 'Excellent',
        organicFertilizer: 'Used Farmyard Manure',
        chemicalPesticides: 'None',
        marketPrice: 650.0,
        pricingReason: 'Direct to consumer subscription discount.',
        nutritionalBenefits: ['Balanced diet', 'Locally sourced'],
        recipeSuggestions: ['Mixed Veg Subzi', 'Healthy Green Smoothie'],
        isWeeklyBasket: true,
      ),
      ConsumerProduct(
        id: '2',
        name: 'Fresh Spinach',
        pricePerUnit: 30.0,
        unit: 'bunch',
        farmerId: 'frm_102',
        farmerName: 'Sunil Jadhav',
        farmLocation: 'Nashik, Maharashtra',
        organicScore: 100,
        category: 'Vegetables',
        imageUrl: '🥬',
        harvestDate: 'Harvested Yesterday',
        description: 'Leafy green spinach, high in iron.',
        cultivationMethod: 'Organic',
        certification: 'Verified Organic',
        distance: 45.0,
        freshnessScore: 90,
        soilHealth: 'Good',
        organicFertilizer: 'Used Jeevamrutha',
        chemicalPesticides: 'None',
        marketPrice: 20.0,
        pricingReason: 'Zero chemical pesticides guarantee safe raw consumption.',
        nutritionalBenefits: ['High in Iron', 'Good for eyesight'],
        recipeSuggestions: ['Palak Paneer', 'Spinach Dal'],
      ),
      ConsumerProduct(
        id: '3',
        name: 'Indrayani Rice',
        pricePerUnit: 80.0,
        unit: 'kg',
        farmerId: 'frm_103',
        farmerName: 'Anand Patil',
        farmLocation: 'Kolhapur, Maharashtra',
        organicScore: 85,
        category: 'Grains',
        imageUrl: '🌾',
        harvestDate: '2026-02-15',
        description: 'Aromatic short-grain rice, a regional specialty.',
        cultivationMethod: 'AWD (Alternate Wetting and Drying)',
        certification: 'PGS-India',
        distance: 120.0,
        freshnessScore: 100, // Grains last longer
        soilHealth: 'Moderate',
        organicFertilizer: 'Used Cow Dung compost',
        chemicalPesticides: 'Minimal',
        marketPrice: 65.0,
        pricingReason: 'Aromatic variety cultivated with reduced water.',
        nutritionalBenefits: ['High Energy', 'Easily Digestible'],
        recipeSuggestions: ['Jeera Rice', 'Sweet Kheer'],
      ),
    ];

    if (category == null || category == 'All') {
      return allProducts;
    }

    return allProducts.where((p) => p.category == category).toList();
  }
}
