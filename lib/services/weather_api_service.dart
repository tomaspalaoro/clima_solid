import 'dart:convert';

import 'package:clima_solid/models/hour_weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherApiService {
  static const _baseUrl = 'api.openweathermap.org';
  static const _apiKey = 'ccd807103f6e8764a5c28ab2bbc9fd45';
  final http.Client httpClient;

  WeatherApiService({http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  /// Obtiene la previsión de 5 días en intervalos de 3h y devuelve solo el día actual
  Future<List<HourWeather>> fetchForecast({
    required String city,
    String lang = 'en',
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

abstract class WeatherRepository {
  Future<List<HourWeather>> getHourlyForecast({
    required String city,
    String lang,
  });
}

class OpenWeatherRepository implements WeatherRepository {
  final WeatherApiService apiService;

  OpenWeatherRepository(this.apiService);

  @override
  Future<List<HourWeather>> getHourlyForecast({
    required String city,
    String lang = 'en',
  }) {
    return apiService.fetchForecast(city: city, lang: lang);
  }
}
