class ClimateData {
  final double temperature;
  final double rainfall;
  final double humidity;
  final double windSpeed;

  ClimateData({
    required this.temperature,
    required this.rainfall,
    required this.humidity,
    required this.windSpeed,
  });

  factory ClimateData.fromJson(Map<String, dynamic> json) {
    return ClimateData(
      temperature: (json['temperature'] ?? 0).toDouble(),
      rainfall: (json['rainfall'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
    );
  }
}

class RiskAnalysis {
  final String level; // Low, Medium, High
  final int score;

  RiskAnalysis({required this.level, required this.score});

  factory RiskAnalysis.fromJson(Map<String, dynamic> json) {
    return RiskAnalysis(
      level: json['level'] ?? 'Unknown',
      score: json['score'] ?? 0,
    );
  }
}

class SmartAlert {
  final String type;
  final String message;
  final String severity;

  SmartAlert({required this.type, required this.message, required this.severity});

  factory SmartAlert.fromJson(Map<String, dynamic> json) {
    return SmartAlert(
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      severity: json['severity'] ?? 'Moderate',
    );
  }
}

class ClimateAdvisoryResponse {
  final ClimateData currentWeather;
  final RiskAnalysis riskAnalysis;
  final List<SmartAlert> smartAlerts;
  final List<String> advisorySuggestions;

  ClimateAdvisoryResponse({
    required this.currentWeather,
    required this.riskAnalysis,
    required this.smartAlerts,
    required this.advisorySuggestions,
  });

  factory ClimateAdvisoryResponse.fromJson(Map<String, dynamic> json) {
    final List alertsList = json['smartAlerts'] ?? [];
    final List advisoriesList = json['advisorySuggestions'] ?? [];

    return ClimateAdvisoryResponse(
      currentWeather: ClimateData.fromJson(json['currentWeather']),
      riskAnalysis: RiskAnalysis.fromJson(json['riskAnalysis']),
      smartAlerts: alertsList.map((e) => SmartAlert.fromJson(e)).toList(),
      advisorySuggestions: List<String>.from(advisoriesList),
    );
  }
}