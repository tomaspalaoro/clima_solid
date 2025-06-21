import 'package:clima_solid/cubits/weather_cubit.dart';
import 'package:clima_solid/cubits/weather_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/cubits/language_cubit.dart';
import 'package:clima_solid/services/weather_api_service.dart';

/// Widget para mostrar el clima por horas de una ciudad
class CityWeatherTab extends StatefulWidget {
  final String city;

  const CityWeatherTab({required this.city, super.key});

  @override
  State<CityWeatherTab> createState() => _CityWeatherTabState();
}

class _CityWeatherTabState extends State<CityWeatherTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final langCode = context.read<LanguageCubit>().state.languageCode;
    final WeatherApiService weatherApiService = WeatherApiService();
    final OpenWeatherRepository weatherRepository = OpenWeatherRepository(
      weatherApiService,
    );

    return BlocProvider(
      create:
          (_) =>
              WeatherCubit(weatherRepository)
                ..fetchForecast(city: widget.city, lang: langCode),
      child: _WeatherView(),
    );
  }
}

class _WeatherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is WeatherError) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          );
        }

        if (state is WeatherLoaded) {
          final loadedHours = state.hoursList;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: loadedHours.length,
              itemBuilder: (context, index) {
                final h = loadedHours[index];
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
        }
        return const SizedBox.shrink();
      },
    );
  }
}
