import 'package:clima_solid/models/hour_weather_model.dart';
import 'package:clima_solid/services/weather_api_service.dart';
import 'package:clima_solid/utils/forecast_filter.dart';

abstract class WeatherRepository {
  /// Método utilizado por WeatherCubit
  Future<List<HourWeather>> getHourlyForecast({
    required String city,
    required String lang,
  });
}

class OpenWeatherRepository implements WeatherRepository {
  // Pedirlo como parámetro permite usar un FakeOpenWeatherApiService en tests
  final WeatherApiService apiService;

  final ForecastFilter filter;

  OpenWeatherRepository({required this.apiService, required this.filter});

  @override
  Future<List<HourWeather>> getHourlyForecast({
    required String city,
    required String lang,
  }) async {
    // Implementación del método utilizando OpenWeatherMap
    final hours = await apiService.fetchForecast(city: city, lang: lang);
    return filter.filterForCurrentDay(hours);
  }
}
