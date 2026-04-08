import 'package:flutter/material.dart';
import 'package:kurukshetra/features/home/models/weather.dart';

class WeatherCard extends StatelessWidget {
  final WeatherInfo weather;
  final VoidCallback? onTap;

  const WeatherCard({
    super.key,
    required this.weather,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and Update Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          weather.location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatDateTime(weather.lastUpdated),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Main Temperature Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.temperatureDisplay,
                          style: const TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            weather.condition,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Hero(
                      tag: 'weather_icon',
                      child: Text(
                        weather.conditionIcon,
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Weather Metadata Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetaItem(Icons.water_drop, weather.humidityDisplay, 'Humidity'),
                    _buildMetaItem(Icons.air, weather.windSpeedDisplay, 'Wind'),
                    _buildMetaItem(Icons.umbrella, weather.rainfallDisplay, 'Rain'),
                  ],
                ),
                
                if (weather.forecast.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Next 5 Days',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white.withValues(alpha: 0.6), size: 16),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weather.forecast.length.clamp(0, 5),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildForecastTile(weather.forecast[index]);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildForecastTile(WeatherForecast forecast) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            forecast.dayName,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            _getForecastIcon(forecast.condition),
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            '${forecast.maxTemp.toInt()}°',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _getForecastIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return '☀️';
      case 'cloudy':
      case 'overcast':
        return '☁️';
      case 'rainy':
      case 'showers':
      case 'drizzle':
        return '🌧️';
      case 'partly cloudy':
        return '⛅';
      case 'stormy':
        return '⛈️';
      default:
        return '🌤️';
    }
  }
}
