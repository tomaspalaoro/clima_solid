import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clima_solid/models/hour_weather_model.dart';

class WeatherInfo extends StatelessWidget {
  const WeatherInfo({super.key, required this.hourWeather});

  final HourWeather hourWeather;

  Color getTemperatureColor(double temp) {
    if (temp <= 0) return Colors.indigo.shade800;
    if (temp <= 10) return Colors.blue.shade700;
    if (temp <= 20) return Colors.teal.shade600;
    if (temp <= 27) return Colors.green.shade600;
    if (temp <= 35) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // dividers
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.network(
              hourWeather.iconUrl,
              height: 90,
              width: 90,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported_outlined, size: 90);
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${hourWeather.dateTime.hour.toString().padLeft(2, '0')}:00',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hourWeather.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.thermostat,
                        size: 20,
                        color: getTemperatureColor(hourWeather.temp),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: getTemperatureColor(
                            hourWeather.temp,
                          ).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${hourWeather.temp.round()}°',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tr('min'),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  '${hourWeather.minTemp.round()}°',
                  style: TextStyle(
                    fontSize: 16,
                    color: getTemperatureColor(hourWeather.minTemp),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tr('max'),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  '${hourWeather.maxTemp.round()}°',
                  style: TextStyle(
                    fontSize: 16,
                    color: getTemperatureColor(hourWeather.maxTemp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
