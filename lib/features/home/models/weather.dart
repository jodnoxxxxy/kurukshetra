

class WeatherInfo {
  final double temperature;
  final double humidity;
  final String condition;
  final String location;
  final double windSpeed;
  final double rainfall;
  final DateTime lastUpdated;
  final List<WeatherForecast> forecast;

  WeatherInfo({
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.location,
    required this.windSpeed,
    required this.rainfall,
    required this.lastUpdated,
    required this.forecast,
  });

  String get temperatureDisplay => '${temperature.toInt()}°C';
  String get humidityDisplay => '${humidity.toInt()}%';
  String get windSpeedDisplay => '${windSpeed.toInt()} km/h';
  String get rainfallDisplay => '${rainfall.toInt()} mm';
  
  String get conditionIcon {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return '☀️';
      case 'cloudy':
      case 'overcast':
        return '☁️';
      case 'rainy':
      case 'showers':
        return '🌧️';
      case 'partly cloudy':
        return '⛅';
      case 'stormy':
      case 'thunderstorm':
        return '⛈️';
      case 'snowy':
        return '❄️';
      case 'foggy':
      case 'mist':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  factory WeatherInfo.fromJson(Map<String, dynamic> json, String location) {
    return WeatherInfo(
      location: location,
      temperature: (json['temperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      condition: json['condition'] ?? 'Unknown',
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      rainfall: (json['rainfall'] ?? 0).toDouble(),
      lastUpdated: DateTime.now(),
      forecast: [],
    );
  }
}

class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final double rainfallChance;

  WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.rainfallChance,
  });

  String get dayName {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference <= 7) return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
    return '${date.day}/${date.month}';
  }
}
