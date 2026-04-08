class DetailedWeather {
  final String location;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int rainfallProbability; // %
  final DateTime updatedAt;

  DetailedWeather({
    required this.location,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.rainfallProbability,
    required this.updatedAt,
  });
}

class ClimateRisk {
  final String title;
  final String description;
  final String severity; // High, Medium, Low
  final String recommendation;

  ClimateRisk({
    required this.title,
    required this.description,
    required this.severity,
    required this.recommendation,
  });
}

class ClimateAdvisory {
  final String id;
  final String title;
  final String shortDescription;
  final String detailedExplanation;
  final String organicTips;
  final String iconName; // e.g., 'water_drop', 'wb_sunny'

  ClimateAdvisory({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.detailedExplanation,
    required this.organicTips,
    required this.iconName,
  });
}
