import 'package:clima_solid/models/hour_weather_model.dart';
import 'package:clima_solid/services/weather_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/cubits/language_cubit.dart';

/// Widget para mostrar el clima por horas de una ciudad
class CityWeatherTab extends StatelessWidget {
  final String city;

  const CityWeatherTab({required this.city, super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = WeatherApiService();
    final language = context.read<LanguageCubit>().state.languageCode;
    final futureForecast = apiService.fetchForecast(city: city, lang: language);

    return FutureBuilder<List<HourWeather>>(
      future: futureForecast,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar datos: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay datos disponibles'));
        }

        final hours = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: hours.length,
            itemBuilder: (context, index) {
              final h = hours[index];
              return Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${h.iconId}@2x.png',
                    height: 100,
                    width: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 60);
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${h.dateTime.hour.toString().padLeft(2, '0')}:00 — ${h.temp.toStringAsFixed(1)}°',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          h.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
