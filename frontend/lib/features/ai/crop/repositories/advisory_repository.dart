import '../models/crop_advisory.dart';

abstract class AdvisoryRepository {
  Future<List<CropCategory>> getCropCategories();
  Future<List<CropStage>> getCropStages(String cropId);
}

class AdvisoryRepositoryImpl implements AdvisoryRepository {
  @override
  Future<List<CropCategory>> getCropCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      CropCategory(
        name: 'Cereals',
        crops: [
          CropInfo(id: 'c1', name: 'Ragi', imageUrl: 'https://images.unsplash.com/photo-1574323347407-293e17ce4f52'),
          CropInfo(id: 'c2', name: 'Bajra', imageUrl: 'https://images.unsplash.com/photo-1627920769212-04fb736636ce'),
          CropInfo(id: 'c3', name: 'Maize', imageUrl: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076'),
          CropInfo(id: 'c4', name: 'Wheat', imageUrl: 'https://images.unsplash.com/photo-1574323347407-293e17ce4f52'),
          CropInfo(id: 'c5', name: 'Paddy', imageUrl: 'https://images.unsplash.com/photo-1586208559288-518aebcf023f'),
        ],
      ),
      CropCategory(
        name: 'Pulses',
        crops: [
          CropInfo(id: 'p1', name: 'Black Gram', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614'),
          CropInfo(id: 'p2', name: 'Green Gram', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614'),
          CropInfo(id: 'p3', name: 'Pigeon Pea', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614'),
          CropInfo(id: 'p4', name: 'Gram', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614'),
        ],
      ),
      CropCategory(
        name: 'Oilseeds',
        crops: [
          CropInfo(id: 'o1', name: 'Sunflower', imageUrl: 'https://images.unsplash.com/photo-1597848212624-a19eb35e2651'),
          CropInfo(id: 'o2', name: 'Soybean', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614'),
          CropInfo(id: 'o3', name: 'Groundnut', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614'),
        ],
      ),
    ];
  }

  @override
  Future<List<CropStage>> getCropStages(String cropId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock Data based on Ragi example
    return [
      CropStage(
        title: 'Land Preparation',
        startDay: 0,
        endDay: 4,
        advisories: [
          AdvisoryDetail(
            type: 'Fertilizer',
            title: 'Basal Dose Application',
            shortDescription: 'Apply FYM @ 5 t/ha before ploughing.',
            detailedContent: 'Mix well-rotted Farm Yard Manure uniformly across the field. For chemical fertilizer, apply 50% N, 100% P, and 100% K as a basal dose.',
          ),
        ],
      ),
      CropStage(
        title: 'Germination',
        startDay: 5,
        endDay: 19,
        advisories: [
          AdvisoryDetail(
            type: 'Irrigation',
            title: '1st Irrigation (Life Saving)',
            shortDescription: 'Provide light irrigation exactly after emergence.',
            detailedContent: 'Ensure field is moist but avoid waterlogging. Usually done 3-5 days after sowing depending on soil moisture levels.',
          ),
        ],
      ),
      CropStage(
        title: 'Vegetative Stage',
        startDay: 20,
        endDay: 49,
        advisories: [
          AdvisoryDetail(
            type: 'Pest',
            title: 'Stem Borer Warning',
            shortDescription: 'High humidity increases stem borer risk.',
            detailedContent: 'Monitor fields for dead hearts. If threshold crossed, spray appropriate recommended chemical such as Chlorpyriphos.',
          ),
          AdvisoryDetail(
            type: 'Fertilizer',
            title: 'Top Dressing of Nitrogen',
            shortDescription: 'Apply 25% of recommended nitrogen.',
            detailedContent: 'Apply 30 kg N/acre exactly at 30 days after sowing. Precede this with weeding to avoid weeds competing for nutrients.',
          ),
        ],
      ),
      CropStage(
        title: 'Flowering & Grain Filling',
        startDay: 50,
        endDay: 109,
        advisories: [
          AdvisoryDetail(
            type: 'Disease',
            title: 'Blast Disease Alert',
            shortDescription: 'Potential Neck / Finger Blast outbreak.',
            detailedContent: 'Look for grey or brown spots on leaves or neck. Spray Tricyclazole if symptoms appear.',
          ),
          AdvisoryDetail(
            type: 'Irrigation',
            title: 'Critical Moisture Period',
            shortDescription: 'Do not stress crop during flowering.',
            detailedContent: 'Provide irrigation at 10-12 day intervals if dry spell persists. Moisture stress at this stage severely reduces yield.',
          ),
        ],
      ),
      CropStage(
        title: 'Harvesting',
        startDay: 110,
        endDay: 125,
        advisories: [
          AdvisoryDetail(
            type: 'General',
            title: 'Harvest Readiness',
            shortDescription: 'Harvest when ears turn brown.',
            detailedContent: 'Stop irrigation 15 days prior to harvest. Cut earheads when they are completely brown and dried.',
          ),
        ],
      ),
    ];
  }
}
