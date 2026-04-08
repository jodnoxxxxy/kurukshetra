class ClimateData {
  final double temperature;
  final double rainfall;
  final double humidity;
  final double windSpeed;
  final String? source;

  ClimateData({
    required this.temperature,
    required this.rainfall,
    required this.humidity,
    required this.windSpeed,
    this.source = 'unknown',
  });

  factory ClimateData.fromJson(Map<String, dynamic> json) {
    // VALIDATION: Ensure values are within realistic ranges
    double temp = (json['temperature'] ?? 0).toDouble();
    double rain = (json['rainfall'] ?? 0).toDouble();
    double humid = (json['humidity'] ?? 0).toDouble();
    double wind = (json['windSpeed'] ?? 0).toDouble();

    // Clamp values to realistic ranges
    temp = temp.clamp(-50, 60);
    rain = rain.clamp(0, 500);
    humid = humid.clamp(0, 100);
    wind = wind.clamp(0, 200);

    return ClimateData(
      temperature: temp,
      rainfall: rain,
      humidity: humid,
      windSpeed: wind,
      source: json['source'] as String? ?? 'mock',
    );
  }

  Map<String, dynamic> toJson() => {
    'temperature': temperature,
    'rainfall': rainfall,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'source': source,
  };
}

class RiskAnalysis {
  final String level; // Low, Medium, High, Unknown
  final int score;
  final List<String>? identifiedRisks;

  RiskAnalysis({
    required this.level,
    required this.score,
    this.identifiedRisks,
  });

  factory RiskAnalysis.fromJson(Map<String, dynamic> json) {
    final level = json['level'] ?? 'Unknown';
    
    // VALIDATION: Ensure level is valid
    final validLevels = ['Low', 'Medium', 'High', 'Unknown'];
    final validLevel = validLevels.contains(level) ? level : 'Unknown';

    return RiskAnalysis(
      level: validLevel,
      score: (json['score'] ?? 0) as int,
      identifiedRisks: json['identifiedRisks'] != null
          ? List<String>.from(json['identifiedRisks'] as List)
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'level': level,
    'score': score,
    'identifiedRisks': identifiedRisks ?? [],
  };
}

class SmartAlert {
  final String type;
  final String message;
  final String severity;

  SmartAlert({
    required this.type,
    required this.message,
    required this.severity,
  });

  factory SmartAlert.fromJson(Map<String, dynamic> json) {
    final severity = json['severity'] ?? 'Medium';
    
    // VALIDATION: Ensure severity is valid
    final validSeverities = ['Low', 'Medium', 'High', 'Critical'];
    final validSeverity = validSeverities.contains(severity) ? severity : 'Medium';

    return SmartAlert(
      type: json['type'] ?? 'Unknown Alert',
      message: json['message'] ?? 'No description available',
      severity: validSeverity,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'message': message,
    'severity': severity,
  };
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
    // EDGE CASE HANDLING: Protect against null/malformed data
    try {
      final List alertsList = json['smartAlerts'] ?? [];
      final List advisoriesList = json['advisorySuggestions'] ?? [];

      return ClimateAdvisoryResponse(
        currentWeather: ClimateData.fromJson(json['currentWeather'] ?? {}),
        riskAnalysis: RiskAnalysis.fromJson(json['riskAnalysis'] ?? {}),
        smartAlerts: alertsList
            .map((e) {
              try {
                return SmartAlert.fromJson(e);
              } catch (ex) {
                print('Error parsing alert: $ex');
                return SmartAlert(
                  type: 'Parse Error',
                  message: 'Unable to parse alert data',
                  severity: 'High',
                );
              }
            })
            .toList(),
        advisorySuggestions: List<String>.from(
          advisoriesList.where((e) => e is String),
        ),
      );
    } catch (e) {
      print('Critical error parsing ClimateAdvisoryResponse: $e');
      // Return default/fallback response
      return ClimateAdvisoryResponse(
        currentWeather: ClimateData(
          temperature: 25.0,
          rainfall: 0.0,
          humidity: 50.0,
          windSpeed: 10.0,
          source: 'error-fallback',
        ),
        riskAnalysis: RiskAnalysis(level: 'Unknown', score: 0),
        smartAlerts: [],
        advisorySuggestions: ['Unable to load climate data. Please try again later.'],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'currentWeather': currentWeather.toJson(),
    'riskAnalysis': riskAnalysis.toJson(),
    'smartAlerts': smartAlerts.map((e) => e.toJson()).toList(),
    'advisorySuggestions': advisorySuggestions,
  };
}