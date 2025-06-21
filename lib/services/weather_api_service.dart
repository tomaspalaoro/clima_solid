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
  }) async {
    final uri = Uri.https(_baseUrl, '/data/2.5/forecast', {
      'q': city,
      'appid': _apiKey,
      'units': 'metric',
      'lang': lang,
    });

    final response = await httpClient.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar datos del clima: ${response.statusCode} ${response.body}',
      );
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    List<HourWeather> hours = [];
    for (var hour in json['list']) {
      hours.add(HourWeather.fromJson(hour));
    }
    return hours;
  }
}
