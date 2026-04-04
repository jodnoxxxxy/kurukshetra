import '../models/pest_model.dart';
import 'package:kurukshetra/core/network/api_client.dart';
import 'package:kurukshetra/core/network/api_response.dart';
import 'package:dio/dio.dart';

abstract class PestRepository {
  Future<ApiResponse<List<PestInfo>>> getPestLibrary();
  Future<ApiResponse<DetectionResult>> detectPest(String imagePath);
}

class PestRepositoryImpl implements PestRepository {
  // disregard _apiClient until actual AI node integration
  // ignore: unused_field
  final _apiClient = ApiClient();

  final List<PestInfo> _mockLibrary = [
    PestInfo(
      id: 'p1',
      name: 'Aphids',
      category: 'Leaf pests',
      imageUrl: 'https://images.unsplash.com/photo-1590492476563-8cfb05eff1fa?auto=format&fit=crop&q=80&w=600', // Mock Image
      symptoms: 'Yellowing of leaves, curled leaves, sticky honeydew residue leading to sooty mold.',
      cause: 'Sap-sucking insects that rapidly multiply on the undersides of young leaves.',
      prevention: 'Encourage natural predators. Do not over-fertilize with nitrogen as it attracts aphids.',
      affectedCrops: ['Wheat', 'Mustard', 'Cotton', 'Vegetables'],
      solutions: [
        PestSolution(
          methodName: 'Neem Oil Spray',
          description: 'Spray 5ml of cold-pressed neem oil mixed with 1L of water every 7 days.',
          isOrganic: true,
        ),
        PestSolution(
          methodName: 'Release Ladybugs',
          description: 'Introduce natural predators like lady beetles or lacewings into the field.',
          isOrganic: true,
        ),
        PestSolution(
          methodName: 'Soap Water Spray',
          description: 'Mix 1 tablespoon of pure mild soap with 1 liter of water and spray on undersides of leaves.',
          isOrganic: true,
        ),
      ],
    ),
    PestInfo(
      id: 'p2',
      name: 'Stem Borer',
      category: 'Stem pests',
      imageUrl: 'https://images.unsplash.com/photo-1596756829774-6ea2783af7ae?auto=format&fit=crop&q=80&w=600',
      symptoms: 'Dead heart in young crops, whiteheads in older crops. Holes in stems.',
      cause: 'Moth larvae bore into the stem and feed on the internal tissues, cutting off nutrient flow.',
      prevention: 'Clipping seedling tips before transplanting. Use pheromone traps to capture adult moths.',
      affectedCrops: ['Paddy', 'Maize', 'Sugarcane'],
      solutions: [
        PestSolution(
          methodName: 'Pheromone Traps',
          description: 'Install 5-8 pheromone traps per acre to disrupt the mating cycle.',
          isOrganic: true,
        ),
        PestSolution(
          methodName: 'Trichogramma Cards',
          description: 'Release Trichogramma japonicum egg parasitoids weekly during the vegetative stage.',
          isOrganic: true,
        ),
      ],
    ),
    PestInfo(
      id: 'p3',
      name: 'Leaf Blight',
      category: 'Fungal diseases',
      imageUrl: 'https://images.unsplash.com/photo-1605623086701-443b711e74de?auto=format&fit=crop&q=80&w=600',
      symptoms: 'Large, irregularly shaped oval spots on leaves with gray centers and dark brown borders.',
      cause: 'Pathogenic fungus thrives in high humidity and warm temperatures.',
      prevention: 'Maintain wider plant spacing to improve air circulation. Avoid overhead irrigation.',
      affectedCrops: ['Maize', 'Wheat', 'Potato'],
      solutions: [
        PestSolution(
          methodName: 'Pseudomonas fluorescens',
          description: 'Foliar spray of 10g/L bio-fungicide during early stages of infection.',
          isOrganic: true,
        ),
        PestSolution(
          methodName: 'Sour Buttermilk Spray',
          description: 'Spray fermented sour buttermilk (1L diluted in 10L water) as a natural anti-fungal.',
          isOrganic: true,
        ),
      ],
    ),
  ];

  @override
  Future<ApiResponse<List<PestInfo>>> getPestLibrary() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return ApiResponse.success(_mockLibrary);
    } catch (e) {
      return ApiResponse.error("Failed to fetch pest library. Please try again.");
    }
  }

  @override
  Future<ApiResponse<DetectionResult>> detectPest(String imagePath) async {
    try {
      // Simulating network AI processing with a delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulate a random failure to demo error states if needed (Optional)
      // if (DateTime.now().second % 4 == 0) throw Exception("Network Timeout");

      final result = DetectionResult(
        pest: _mockLibrary.first,
        confidenceScore: 0.92,
        affectedCrop: 'Unknown Crop (Auto-detected)',
        imagePath: imagePath,
      );

      return ApiResponse.success(result);
    } on DioException catch (dioError) {
      return ApiResponse.error("Network error analyzing image: ${dioError.message}");
    } catch (e) {
      return ApiResponse.error("An unexpected error occurred during AI analysis. Please try again.");
    }
  }
}
