import '../models/pest_model.dart';
import 'package:kurukshetra/core/network/api_client.dart';

abstract class PestDiseaseRepository {
  Future<List<PestCrop>> getCrops();
  Future<List<PestDisease>> getPestsForCrop(String cropId);
}

class PestDiseaseRepositoryImpl implements PestDiseaseRepository {
  // ignore: unused_field
  final _apiClient = ApiClient();

  final List<PestCrop> _mockCrops = [
    PestCrop(id: 'c1', name: 'Wheat', category: 'Cereals', imageUrl: 'https://images.unsplash.com/photo-1574323347407-293e17ce4f52?auto=format&fit=crop&q=80&w=600'),
    PestCrop(id: 'c2', name: 'Rice', category: 'Cereals', imageUrl: 'https://images.unsplash.com/photo-1586208538763-7eb9273c524e?auto=format&fit=crop&q=80&w=600'),
    PestCrop(id: 'c3', name: 'Maize', category: 'Cereals', imageUrl: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&q=80&w=600'),
    PestCrop(id: 'c4', name: 'Gram', category: 'Pulses', imageUrl: 'https://images.unsplash.com/photo-1585233636531-1f9c8da427ab?auto=format&fit=crop&q=80&w=600'),
    PestCrop(id: 'c5', name: 'Soybean', category: 'Oilseeds', imageUrl: 'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?auto=format&fit=crop&q=80&w=600'),
  ];

  final Map<String, List<PestDisease>> _mockPests = {
    'c2': [ // Rice
      PestDisease(
        id: 'p1',
        name: 'Leaf Blast',
        imageUrl: 'https://images.unsplash.com/photo-1628183185388-c70094eeb9ce?auto=format&fit=crop&q=80&w=600',
        shortDescription: 'Fungal disease causing spindle-shaped leaf spots.',
        symptoms: 'Initial symptoms consist of white to gray-green lesions or spots with dark green margins. Older lesions are spindle-shaped.',
        cause: 'Magnaporthe oryzae fungus. Spreads rapidly in humid and warm weather.',
        affectedStage: 'All stages, highly damaging at tillering and panicle emergence.',
        solutions: [
          OrganicUpay(
            title: 'Pseudomonas fluorescens Spray',
            description: 'Apply 10g/L of Pseudomonas bio-fungicide during the vegetative stage.',
          ),
          OrganicUpay(
            title: 'Sour Buttermilk',
            description: 'Dilute fermented buttermilk and spray over affected leaves to stop fungal growth.',
          ),
        ],
        preventionTips: [
          'Use resistant or tolerant rice varieties.',
          'Avoid excessive nitrogen fertilizer application.',
          'Ensure fields are properly flooded (if applicable) rather than just moist.',
        ],
      ),
      PestDisease(
        id: 'p2',
        name: 'Stem Borer',
        imageUrl: 'https://images.unsplash.com/photo-1596756829774-6ea2783af7ae?auto=format&fit=crop&q=80&w=600',
        shortDescription: 'Caterpillars boring into rice stems causing "dead heart".',
        symptoms: 'Drying of the central tiller (dead heart) during the vegetative stage, and whiteheads during the reproductive stage.',
        cause: 'Moth larvae bore into the stem and feed on internal plant tissues.',
        affectedStage: 'Vegetative to Reproductive stage.',
        solutions: [
          OrganicUpay(
            title: 'Release Trichogramma',
            description: 'Release Trichogramma japonicum egg parasitoids weekly.',
          ),
          OrganicUpay(
            title: 'Neem Seed Kernel Extract (NSKE)',
            description: 'Spray 5% NSKE solution evenly across the field to deter moths from laying eggs.',
          ),
        ],
        preventionTips: [
          'Clip seedling tips before transplanting to remove egg masses.',
          'Install pheromone traps early in the season.',
          'Plow and flood the field after harvest to destroy dormant larvae.',
        ],
      ),
    ],
    'c5': [ // Soybean
      PestDisease(
        id: 'p3',
        name: 'Aphids',
        imageUrl: 'https://images.unsplash.com/photo-1590492476563-8cfb05eff1fa?auto=format&fit=crop&q=80&w=600',
        shortDescription: 'Sap-sucking insects causing yellowing and stunted growth.',
        symptoms: 'Yellow leaves, curled leaf edges, and sticky honeydew secreted by aphids leading to sooty mold.',
        cause: 'Aphis glycines (Soybean aphid) multiplying rapidly on leaf undersides.',
        affectedStage: 'Early vegetative and flowering stages.',
        solutions: [
          OrganicUpay(
            title: 'Neem Oil Spray',
            description: 'Mix neem oil with water and spray every 7 days on the undersides of leaves.',
          ),
          OrganicUpay(
            title: 'Garlic & Chili Spray',
            description: 'Blend garlic and chili with water, strain, and spray on infected plants to repel bugs.',
          ),
          OrganicUpay(
            title: 'Soap Water Spray',
            description: 'Use mild soap solution mixed with water to break down the protective coating of aphids.',
          ),
        ],
        preventionTips: [
          'Avoid excess nitrogen fertilizers which produce tender, aphid-attracting growth.',
          'Encourage natural predators like ladybugs.',
          'Maintain proper crop spacing for airflow.',
        ],
      ),
    ]
  };

  @override
  Future<List<PestCrop>> getCrops() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockCrops;
  }

  @override
  Future<List<PestDisease>> getPestsForCrop(String cropId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPests[cropId] ?? [];
  }
}
