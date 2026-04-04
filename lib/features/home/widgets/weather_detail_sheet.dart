import 'package:flutter/material.dart';
import 'package:kurukshetra/features/home/models/weather.dart';

class WeatherDetailSheet extends StatelessWidget {
  final WeatherInfo weather;

  const WeatherDetailSheet({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 20, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(weather.location.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5)),
                    const Text('Forecast Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100, shape: const CircleBorder()),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
              itemCount: weather.forecast.length,
              itemBuilder: (ctx, i) {
                final f = weather.forecast[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(f.dayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(_getIcon(f.condition), style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 8),
                            Text(f.condition, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${f.maxTemp.toInt()}°', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                            const SizedBox(width: 10),
                            Text('${f.minTemp.toInt()}°', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getIcon(String cond) {
    switch (cond.toLowerCase()) {
      case 'sunny': case 'clear': return '☀️';
      case 'cloudy': return '☁️';
      case 'rainy': return '🌧️';
      case 'partly cloudy': return '⛅';
      case 'stormy': return '⛈️';
      default: return '🌤️';
    }
  }
}
