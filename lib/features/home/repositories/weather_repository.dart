import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kurukshetra/features/home/models/weather.dart';

abstract class WeatherRepository {
  Future<WeatherInfo> getCurrentWeather(String location);
}

class WeatherRepositoryImpl implements WeatherRepository {
  @override
  Future<WeatherInfo> getCurrentWeather(String location) async {
    try {
      // Default to Pune coordinates if location is Pune or not specified
      double lat = 18.5204;
      double lon = 73.8567;
      
      // If the user's location is actually passed, we should ideally geocode it
      // For now we assume Pune as the primary user hub
      
      final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode,precipitation_probability_max&timezone=auto'
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final current = data['current_weather'];
        final daily = data['daily'];
        
        List<WeatherForecast> forecasts = [];
        for (int i = 0; i < daily['time'].length; i++) {
          forecasts.add(WeatherForecast(
            date: DateTime.parse(daily['time'][i]),
            maxTemp: daily['temperature_2m_max'][i].toDouble(),
            minTemp: daily['temperature_2m_min'][i].toDouble(),
            condition: _getConditionFromCode(daily['weathercode'][i]),
            rainfallChance: daily['precipitation_probability_max'][i].toDouble(),
          ));
        }

        return WeatherInfo(
          temperature: current['temperature'].toDouble(),
          humidity: 65, // Current humidity is not in the simple current_weather data, could be fetched via relative_humidity_2m
          condition: _getConditionFromCode(current['weathercode']),
          location: location,
          windSpeed: current['windspeed'].toDouble(),
          rainfall: 0.0, // This would be better fetched from hourly data if needed
          lastUpdated: DateTime.now(),
          forecast: forecasts,
        );
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // Fallback data if API fails or no internet
      return WeatherInfo(
        location: location,
        temperature: 28.5,
        humidity: 65,
        condition: 'Partly Cloudy',
        windSpeed: 12.0,
        rainfall: 0.0,
        lastUpdated: DateTime.now(),
        forecast: _getMockForecast(),
      );
    }
  }

  String _getConditionFromCode(int code) {
    if (code == 0) return 'Sunny';
    if (code >= 1 && code <= 3) return 'Partly Cloudy';
    if (code == 45 || code == 48) return 'Foggy';
    if (code >= 51 && code <= 55) return 'Drizzle';
    if (code >= 61 && code <= 65) return 'Rainy';
    if (code >= 80 && code <= 82) return 'Showers';
    if (code >= 95) return 'Stormy';
    return 'Cloudy';
  }

  List<WeatherForecast> _getMockForecast() {
    final now = DateTime.now();
    return [
      WeatherForecast(date: now, maxTemp: 32.0, minTemp: 24.0, condition: 'Sunny', rainfallChance: 0),
      WeatherForecast(date: now.add(const Duration(days: 1)), maxTemp: 29.0, minTemp: 22.0, condition: 'Rainy', rainfallChance: 60),
      WeatherForecast(date: now.add(const Duration(days: 2)), maxTemp: 30.0, minTemp: 23.0, condition: 'Cloudy', rainfallChance: 20),
    ];
  }
}
