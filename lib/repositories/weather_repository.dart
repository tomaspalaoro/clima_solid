import 'package:clima_solid/models/hour_weather_model.dart';
import 'package:clima_solid/services/openweather_api_service.dart';

abstract class WeatherRepository {
  /// Método utilizado por WeatherCubit
  Future<List<HourWeather>> getHourlyForecast({
    required String city,
    required String lang,
  });
}

class OpenWeatherRepository implements WeatherRepository {
  // Pedirlo como parámetro permite usar un FakeOpenWeatherApiService en tests
  final OpenWeatherApiService apiService;

  OpenWeatherRepository(this.apiService);

  @override
  Future<List<HourWeather>> getHourlyForecast({
    required String city,
    required String lang,
  }) {
    // Implementación del método utilizando OpenWeatherMap
    return apiService.fetchOpenWeatherForecast(city: city, lang: lang);
  }
}
