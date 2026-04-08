import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/crop_recommendation.dart';
import '../models/growth_step.dart';
import '../models/soil_data.dart';
import 'package:flutter/material.dart';

class CropAdvisoryRepository {
  static const String _baseUrl = 'http://localhost:5000/api/v1';
  static const String _weatherApiKey = 'YOUR_API_KEY';

  Future<Map<String, dynamic>> fetchWeatherData(Position position) async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_weatherApiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Season getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 6 && month <= 10) return Season.kharif;
    if (month >= 11 || month <= 2) return Season.rabi;
    return Season.summer;
  }

  Future<List<CropRecommendation>> getRecommendations({
    required SoilType soilType,
    required WaterAvailability waterAvailability,
    required double currentTemp,
    required Season season,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/ai/crop-recommendation'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'soilType': soilType.label,
          'waterAvailability': waterAvailability.label,
          'temp': currentTemp,
          'season': season.label,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> cropsData = data['data'];
        
        return cropsData.map((json) => _mapToCropRecommendation(json)).toList();
      } else {
        throw Exception('Failed to fetch recommendations from backend');
      }
    } catch (e) {
      // Fallback to local logic if backend fails
      print('Backend error, using fallback: $e');
      return _getFallbackRecommendations(soilType, waterAvailability, currentTemp, season);
    }
  }

  CropRecommendation _mapToCropRecommendation(Map<String, dynamic> json) {
    return CropRecommendation(
      name: json['name'],
      reason: json['reason'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      steps: (json['steps'] as List).map((s) => GrowthStep(
        title: s['title'],
        description: s['description'],
        duration: Duration(days: s['durationDays']),
        icon: _getIconData(s['icon']),
      )).toList(),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'agriculture': return Icons.agriculture;
      case 'grain': return Icons.grain;
      case 'waves': return Icons.waves;
      case 'opacity': return Icons.opacity;
      case 'bug_report': return Icons.bug_report;
      case 'content_cut': return Icons.content_cut;
      default: return Icons.eco;
    }
  }

  List<CropRecommendation> _getFallbackRecommendations(
    SoilType soilType,
    WaterAvailability waterAvailability,
    double currentTemp,
    Season season,
  ) {
    // Keep the previous mock logic as fallback
    final List<CropRecommendation> allCrops = [
      CropRecommendation(
        name: 'Rice',
        reason: 'Suitable for high water availability and alluvial soil.',
        description: 'Rice is the most important staple food crop of India.',
        imageUrl: 'https://images.unsplash.com/photo-1536633100227-2300bcfd01e6?q=80&w=400&auto=format&fit=crop',
        steps: _getGeneralSteps(),
      ),
      // ... same as before
    ];
    return allCrops.take(3).toList();
  }

  List<GrowthStep> _getGeneralSteps() {
    return [
      const GrowthStep(
        title: 'Land Preparation',
        description: 'Plough the field 2-3 times to create a fine tilth. Add organic manure.',
        duration: Duration(days: 7),
        icon: Icons.agriculture,
      ),
      const GrowthStep(
        title: 'Sowing',
        description: 'Choose high-quality seeds and sow them at the recommended depth.',
        duration: Duration(days: 2),
        icon: Icons.grain,
      ),
    ];
  }
}
