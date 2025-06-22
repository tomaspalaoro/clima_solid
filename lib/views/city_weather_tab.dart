import 'package:clima_solid/blocs/weather_cubit.dart';
import 'package:clima_solid/blocs/weather_state.dart';
import 'package:clima_solid/repositories/weather_repository.dart';
import 'package:clima_solid/widgets/weather_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  /// Protege de re-inicializaciones indeseadas
  bool _isInitialized = false;

  late WeatherCubit weatherCubit;
  late String _lastLangCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inicialización única
    if (!_isInitialized) {
      final repo = context.read<WeatherRepository>();
      weatherCubit = WeatherCubit(repo);

      // Primer fetch usando el locale actual
      _lastLangCode = context.locale.languageCode;
      weatherCubit.fetchForecast(city: widget.city, lang: _lastLangCode);

      _isInitialized = true;
    } else {
      // Si ya inicializamos, miramos si cambió el idioma y re-fetch
      final newCode = context.locale.languageCode;
      if (newCode != _lastLangCode) {
        _lastLangCode = newCode;
        weatherCubit.fetchForecast(city: widget.city, lang: newCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: weatherCubit,
      child: _WeatherView(city: widget.city),
    );
  }

  @override
  void dispose() {
    weatherCubit.close();
    super.dispose();
  }
}

class _WeatherView extends StatelessWidget {
  final String city;

  const _WeatherView({required this.city});

  /// Vuelve a cargar los datos
  Future<void> _refresh(WeatherCubit weatherCubit, String lang) async {
    await weatherCubit.fetchForecast(city: city, lang: lang);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading || state is WeatherInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is WeatherError) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    _refresh(
                      context.read<WeatherCubit>(),
                      context.locale.languageCode,
                    );
                  },
                  child: Text(tr('retry')),
                ),
              ],
            ),
          );
        }

        if (state is WeatherLoaded) {
          final loadedHours = state.hoursList;
          final weatherCubit = context.read<WeatherCubit>();
          final lang = context.locale.languageCode;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RefreshIndicator(
              // Refresca los datos al arrastrar
              onRefresh: () => _refresh(weatherCubit, lang),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: loadedHours.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  final h = loadedHours[index];
                  return WeatherInfo(hourWeather: h);
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
