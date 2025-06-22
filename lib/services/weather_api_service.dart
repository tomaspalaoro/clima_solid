import 'dart:convert';

import 'package:clima_solid/models/hour_weather_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatherApiService {
  Future<List<HourWeather>> fetchForecast({
    required String city,
    required String lang,
  });
}

class OpenWeatherApiService implements WeatherApiService {
  static const _baseUrl = 'api.openweathermap.org';
  static const _apiKey = 'ccd807103f6e8764a5c28ab2bbc9fd45';
  final http.Client httpClient;

  OpenWeatherApiService({http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  @override
  Future<List<HourWeather>> fetchForecast({
    required String city,
    required String lang,
  }) async {
    const int maxRetries = 2;
    const retryDelay = Duration(seconds: 2);
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
        if (response.statusCode != 200) throw Exception(response.body);

        final Map<String, dynamic> json = jsonDecode(response.body);
        return (json['list'] as List)
            .map((e) => HourWeather.fromJson(e))
            .toList();
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
