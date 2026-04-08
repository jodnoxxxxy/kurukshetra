import numpy as np
import pandas as pd
from datetime import datetime, timedelta

class WeatherSmartAnalyzer:
    def __init__(self):
        self.crop_weather_requirements = {
            'Rice': {'min_temp': 20, 'max_temp': 35, 'min_rain': 150, 'max_rain': 300},
            'Wheat': {'min_temp': 10, 'max_temp': 25, 'min_rain': 50, 'max_rain': 100},
            'Maize': {'min_temp': 18, 'max_temp': 30, 'min_rain': 50, 'max_rain': 120},
            'Cotton': {'min_temp': 18, 'max_temp': 35, 'min_rain': 50, 'max_rain': 110},
        }

    def analyze_conditions(self, forecast, crop_name):
        """
        Analyzes weather forecast and provides smart farming suggestions.
        forecast: list of dictionaries [{temp, rain, humidity, date}, ...]
        """
        suggestions = []
        requirement = self.crop_weather_requirements.get(crop_name, {'min_temp': 15, 'max_temp': 35, 'min_rain': 50, 'max_rain': 150})

        avg_temp = np.mean([f['temp'] for f in forecast])
        total_rain = sum([f['rain'] for f in forecast])
        avg_hum = np.mean([f['humidity'] for f in forecast])

        # Temperature analysis
        if avg_temp < requirement['min_temp']:
            suggestions.append(f"Temperature is below ideal for {crop_name}. Consider protective measures or delaying planting.")
        elif avg_temp > requirement['max_temp']:
            suggestions.append(f"High temperatures can stress {crop_name}. Increase irrigation frequency during peak heat.")

        # Rainfall analysis
        if total_rain < requirement['min_rain']:
            suggestions.append(f"Low rainfall forecast. Supplement with artificial irrigation.")
        elif total_rain > requirement['max_rain']:
            suggestions.append(f"Excessive rainfall forecast. Ensure proper drainage to avoid waterlogging.")

        # Special weather event alerts
        for f in forecast:
            if f.get('wind_speed', 0) > 40:
                suggestions.append(f"High wind warning for {f['date']}. Consider staking tall crops.")
            if f.get('humidity', 0) > 85:
                suggestions.append(f"High humidity on {f['date']} increases fungal disease risk. Monitor closely.")

        return {
            "summary": f"Average conditions: {round(avg_temp, 1)}°C, {round(total_rain, 1)}mm rain.",
            "suggestions": suggestions,
            "risk_level": "High" if len(suggestions) >= 3 else "Moderate" if len(suggestions) >= 1 else "Low"
        }

if __name__ == "__main__":
    analyzer = WeatherSmartAnalyzer()
    # Mock forecast data for 7 days
    mock_forecast = [
        {'temp': 32, 'rain': 10, 'humidity': 60, 'date': '2026-04-06'},
        {'temp': 34, 'rain': 0, 'humidity': 55, 'date': '2026-04-07'},
        {'temp': 33, 'rain': 5, 'humidity': 58, 'date': '2026-04-08'},
        {'temp': 38, 'rain': 0, 'humidity': 40, 'date': '2026-04-09'},
        {'temp': 36, 'rain': 0, 'humidity': 45, 'date': '2026-04-10'},
        {'temp': 35, 'rain': 0, 'humidity': 50, 'date': '2026-04-11'},
        {'temp': 32, 'rain': 2, 'humidity': 65, 'date': '2026-04-12'},
    ]
    result = analyzer.analyze_conditions(mock_forecast, 'Maize')
    print(f"Weather Analysis for Maize: {result['summary']}")
    print(f"Risk Level: {result['risk_level']}")
    for s in result['suggestions']:
        print(f"- {s}")
