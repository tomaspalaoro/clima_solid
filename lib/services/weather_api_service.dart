import 'dart:convert';

import 'package:clima_solid/models/hour_weather_model.dart';
import 'package:http/http.dart' as http;

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

class OpenWeatherApiService {
  static const _baseUrl = 'api.openweathermap.org';
  static const _apiKey = 'ccd807103f6e8764a5c28ab2bbc9fd45';
  final http.Client httpClient;

  OpenWeatherApiService({http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  /// Obtiene la previsión de 5 días en intervalos de 3h y devuelve solo el día actual
  Future<List<HourWeather>> fetchOpenWeatherForecast({
    required String city,
    required String lang,
    bool currentDayOnly = true,
  }) async {
    const int maxRetries = 2;
    const Duration retryDelay = Duration(seconds: 2);
    int attempt = 0;

    while (true) {
      try {
        final uri = Uri.https(_baseUrl, '/data/2.5/forecast', {
          'q': city,
          'appid': _apiKey,
          'units': 'metric',
          'lang': lang,
        });

        final response = await httpClient.get(uri);
        if (response.statusCode != 200) {
          throw (response.body);
        }

        final Map<String, dynamic> json = jsonDecode(response.body);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        List<HourWeather> hours = [];
        for (var hour in json['list']) {
          final HourWeather hourWeather = HourWeather.fromJson(hour);
          if (!currentDayOnly) {
            hours.add(hourWeather);
          } else {
            // Filtra solo el día actual
            final forecastDate = DateTime(
              hourWeather.dateTime.year,
              hourWeather.dateTime.month,
              hourWeather.dateTime.day,
            );
            if (forecastDate == today) {
              hours.add(hourWeather);
            }
          }
        }

        return hours;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          return Future.error("Couldn't load weather data: $e");
        }
        await Future.delayed(retryDelay);
      }
    }
  }
}
