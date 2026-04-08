import 'package:dio/dio.dart';

import '../models/climate_model.dart';

abstract class ClimateRepository {
  Future<DetailedWeather> getWeatherData(String location);
  Future<List<ClimateRisk>> getClimateRisks(DetailedWeather weather);
  Future<List<ClimateAdvisory>> getAdvisories(DetailedWeather weather);
}

class ClimateRepositoryImpl implements ClimateRepository {
  ClimateRepositoryImpl({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.openweathermap.org/data/2.5',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio _dio;
  static const String _apiKey =
      String.fromEnvironment('OPENWEATHER_API_KEY', defaultValue: '04b0d2a5768718611ebeefbc35b37278');

  @override
  Future<DetailedWeather> getWeatherData(String location) async {
    final safeLocation = location.trim().isEmpty ? 'Pune' : location.trim();
    if (_apiKey.isEmpty) {
      return _fallbackWeather(safeLocation);
    }

    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'q': safeLocation,
          'units': 'metric',
          'appid': _apiKey,
          'cnt': 1,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final city = data['city'] as Map<String, dynamic>?;
      final list = (data['list'] as List<dynamic>? ?? []);
      if (list.isEmpty) {
        return _fallbackWeather(safeLocation);
      }

      final first = list.first as Map<String, dynamic>;
      final main = first['main'] as Map<String, dynamic>? ?? {};
      final wind = first['wind'] as Map<String, dynamic>? ?? {};
      final weatherList = first['weather'] as List<dynamic>? ?? const [];
      final weatherMain = weatherList.isNotEmpty
          ? ((weatherList.first as Map<String, dynamic>)['main'] as String? ??
              'Unknown')
          : 'Unknown';

      final popValue = (first['pop'] as num?)?.toDouble() ?? 0;

      return DetailedWeather(
        location: city?['name'] as String? ?? safeLocation,
        temperature: (main['temp'] as num?)?.toDouble() ?? 0,
        minTemperature: (main['temp_min'] as num?)?.toDouble() ?? 0,
        maxTemperature: (main['temp_max'] as num?)?.toDouble() ?? 0,
        condition: weatherMain,
        humidity: (main['humidity'] as num?)?.toInt() ?? 0,
        windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0,
        rainfallProbability: (popValue * 100).round(),
        updatedAt: DateTime.now(),
      );
    } on DioException {
      return _fallbackWeather(safeLocation);
    }
  }

  DetailedWeather _fallbackWeather(String location) {
    return DetailedWeather(
      location: location,
      temperature: 32.0,
      minTemperature: 27.0,
      maxTemperature: 35.0,
      condition: 'Partly Cloudy',
      humidity: 72,
      windSpeed: 10.0,
      rainfallProbability: 45,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<ClimateRisk>> getClimateRisks(DetailedWeather weather) async {
    await Future.delayed(const Duration(milliseconds: 400));
    List<ClimateRisk> risks = [];

    if (weather.temperature > 35.0) {
      risks.add(ClimateRisk(
        title: 'Heat Stress Risk',
        description: 'High temperatures expected tomorrow exceeding 35°C.',
        severity: 'High',
        recommendation: 'Increase irrigation and apply shade nets.',
      ));
    }
    if (weather.humidity > 70 && weather.temperature > 30.0) {
      risks.add(ClimateRisk(
        title: 'Pest Outbreak Risk',
        description: 'High humidity and warm weather favor fungal diseases.',
        severity: 'Medium',
        recommendation: 'Monitor fungal diseases and consider neem oil spray.',
      ));
    }
    if (weather.rainfallProbability > 60) {
      risks.add(ClimateRisk(
        title: 'Heavy Rain Warning',
        description: '65% probability of heavy rainfall in the next 48 hours.',
        severity: 'Medium',
        recommendation: 'Delay irrigation and ensure proper field drainage.',
      ));
    }

    // Default if no risks
    if (risks.isEmpty) {
      risks.add(ClimateRisk(
        title: 'Favorable Conditions',
        description: 'Weather conditions are currently optimal for standard operations.',
        severity: 'Low',
        recommendation: 'Continue with standard SOPs.',
      ));
    }

    return risks;
  }

  @override
  Future<List<ClimateAdvisory>> getAdvisories(DetailedWeather weather) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Based on weather conditions, we recommend active farming techniques
    List<ClimateAdvisory> advisories = [
      ClimateAdvisory(
        id: '1',
        title: 'Mulching Techniques',
        shortDescription: 'Maintain soil moisture and reduce evaporation.',
        detailedExplanation: 'Mulching is the process of applying a layer of material to the surface of the soil. Apply straw mulch or crop residues around crops to conserve soil moisture significantly and reduce evaporation during high heat index days.',
        organicTips: 'Use locally sourced completely organic crop residue (like wheat or paddy straw) as mulch to also slowly build organic carbon in the soil as it decomposes.',
        iconName: 'layers',
      ),
      ClimateAdvisory(
        id: '2',
        title: 'Irrigation Planning',
        shortDescription: 'Optimize water usage based on rainfall probability.',
        detailedExplanation: 'With a ${weather.rainfallProbability}% chance of rain, it is advised to delay heavy irrigation. Focus on precise root-zone irrigation like drip systems to avoid waterlogging if sudden showers occur.',
        organicTips: 'Capture upcoming rainwater using farm ponds. Rainwater contains natural atmospheric nitrogen which serves as a micro-boost for organic crop health.',
        iconName: 'water_drop',
      ),
      ClimateAdvisory(
        id: '3',
        title: 'Shade Management',
        shortDescription: 'Protect crops from excessive UV radiation.',
        detailedExplanation: 'Since peak temperatures are reaching ${weather.maxTemperature}°C, younger crops and vegetables are highly susceptible to sunburn and wilting. Deploy 50% green shade nets.',
        organicTips: 'Plant natural shade providers like Sesbania or Pigeon Pea on field borders to create a biological microclimate.',
        iconName: 'wb_sunny',
      ),
      ClimateAdvisory(
        id: '4',
        title: 'Drought Resistant Varieties',
        shortDescription: 'Long term climate resilient seed planning.',
        detailedExplanation: 'For upcoming seasons with predicted erratic rainfall, consider shifting a portion of acreage towards drought-resistant millets or specific heat-tolerant wheat varieties.',
        organicTips: 'Save seeds from the healthiest, most heat-tolerant plants in your current harvest to organically build localized genetic resilience.',
        iconName: 'grass',
      ),
    ];
    
    return advisories;
  }
}
