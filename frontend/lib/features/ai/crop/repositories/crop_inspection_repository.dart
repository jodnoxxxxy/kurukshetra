import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/services/api_service.dart';
import '../models/crop_inspection.dart';

class CropInspectionRepository {
  final Dio _dio;
  final String _baseUrl = '/api/v1/inspections';

  CropInspectionRepository(this._dio);

  // Create new inspection
  Future<CropInspection> createInspection({
    required String fieldId,
    required String cropId,
    required String? healthStatus,
    String? pests,
    String? diseases,
    String? leafCondition,
    String? soilCondition,
    double? cropHeight,
    String? leafColor,
    String? moistureLevel,
    bool wateringNeeded = false,
    String? issues,
    String? recommendation,
    bool actionRequired = false,
    String? riskLevel,
    String? imageUrl,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: {
          'fieldId': fieldId,
          'cropId': cropId,
          'healthStatus': healthStatus,
          'pests': pests,
          'diseases': diseases,
          'leafCondition': leafCondition,
          'soilCondition': soilCondition,
          'cropHeight': cropHeight,
          'leafColor': leafColor,
          'moistureLevel': moistureLevel,
          'wateringNeeded': wateringNeeded,
          'issues': issues,
          'recommendation': recommendation,
          'actionRequired': actionRequired,
          'riskLevel': riskLevel,
          'imageUrl': imageUrl,
          'notes': notes,
        },
      );

      if (response.statusCode == 201) {
        return CropInspection.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create inspection: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error creating inspection: $e');
    }
  }

  // Get inspections for a field
  Future<List<CropInspection>> getInspectionsByField(String fieldId) async {
    try {
      final response = await _dio.get('$_baseUrl/field/$fieldId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((item) => CropInspection.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to fetch inspections: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching inspections: $e');
    }
  }

  // Get latest inspection for a field
  Future<CropInspection?> getLatestInspection(String fieldId) async {
    try {
      final response = await _dio.get('$_baseUrl/field/$fieldId/latest');

      if (response.statusCode == 200) {
        return CropInspection.fromJson(response.data['data']);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch inspection: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching inspection: $e');
    }
  }

  // Get inspection by ID
  Future<CropInspection> getInspectionById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');

      if (response.statusCode == 200) {
        return CropInspection.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to fetch inspection: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching inspection: $e');
    }
  }

  // Update inspection
  Future<CropInspection> updateInspection(
    String id, {
    String? healthStatus,
    String? pests,
    String? diseases,
    String? leafCondition,
    String? soilCondition,
    double? cropHeight,
    String? leafColor,
    String? moistureLevel,
    bool? wateringNeeded,
    String? issues,
    String? recommendation,
    bool? actionRequired,
    String? riskLevel,
    String? imageUrl,
    String? notes,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (healthStatus != null) data['healthStatus'] = healthStatus;
      if (pests != null) data['pests'] = pests;
      if (diseases != null) data['diseases'] = diseases;
      if (leafCondition != null) data['leafCondition'] = leafCondition;
      if (soilCondition != null) data['soilCondition'] = soilCondition;
      if (cropHeight != null) data['cropHeight'] = cropHeight;
      if (leafColor != null) data['leafColor'] = leafColor;
      if (moistureLevel != null) data['moistureLevel'] = moistureLevel;
      if (wateringNeeded != null) data['wateringNeeded'] = wateringNeeded;
      if (issues != null) data['issues'] = issues;
      if (recommendation != null) data['recommendation'] = recommendation;
      if (actionRequired != null) data['actionRequired'] = actionRequired;
      if (riskLevel != null) data['riskLevel'] = riskLevel;
      if (imageUrl != null) data['imageUrl'] = imageUrl;
      if (notes != null) data['notes'] = notes;

      final response = await _dio.put('$_baseUrl/$id', data: data);

      if (response.statusCode == 200) {
        return CropInspection.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update inspection: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error updating inspection: $e');
    }
  }

  // Delete inspection
  Future<void> deleteInspection(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/$id');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete inspection: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error deleting inspection: $e');
    }
  }

  // Get farm inspection summary
  Future<Map<String, dynamic>> getFarmInspectionSummary(String farmId) async {
    try {
      final response = await _dio.get('$_baseUrl/summary/farm/$farmId');

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to fetch summary: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error fetching summary: $e');
    }
  }
}

// Provider for the repository
final cropInspectionRepositoryProvider = Provider<CropInspectionRepository>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiService.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: const {
        'Content-Type': 'application/json',
      },
    ),
  );
  return CropInspectionRepository(dio);
});
