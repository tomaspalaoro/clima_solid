import 'package:clima_solid/repositories/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clima_solid/blocs/weather_cubit.dart';
import 'package:clima_solid/blocs/weather_state.dart';
import 'package:clima_solid/models/hour_weather_model.dart';

void main() {
  group('WeatherCubit', () {
    late WeatherCubit cubit;

    final mockForecast = [
      HourWeather(
        dateTime: DateTime.parse("2025-06-22T12:00:00Z"),
        temp: 25.0,
        minTemp: 20.0,
        maxTemp: 28.0,
        description: 'cielo claro',
        iconId: '01d',
      ),
    ];

    setUp(() {
      cubit = WeatherCubit(FakeWeatherRepository(mockForecast));
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<WeatherCubit, WeatherState>(
      'emite [WeatherLoading, WeatherLoaded] cuando fetchForecast es exitoso',
      build: () => cubit,
      act: (cubit) => cubit.fetchForecast(city: 'Madrid', lang: 'es'),
      expect:
          () => [
            isA<WeatherLoading>(),
            isA<WeatherLoaded>().having(
              (state) => state.hoursList.length,
              'hoursList length',
              mockForecast.length,
            ),
          ],
    );
  });

  group('HourWeather.fromJson', () {
    test('parsea correctamente un JSON completo como el de la API real', () {
      final json = {
        "dt": 1750593600,
        "main": {
          "temp": 24.75,
          "feels_like": 24.59,
          "temp_min": 23.63,
          "temp_max": 24.75,
          "pressure": 1013,
          "sea_level": 1013,
          "grnd_level": 1009,
          "humidity": 50,
          "temp_kf": 1.12,
        },
        "weather": [
          {
            "id": 801,
            "main": "Clouds",
            "description": "algo de nubes",
            "icon": "02d",
          },
        ],
        "clouds": {"all": 20},
        "wind": {"speed": 6.79, "deg": 239, "gust": 10.62},
        "visibility": 10000,
        "pop": 0,
        "sys": {"pod": "d"},
        "dt_txt": "2025-06-22 12:00:00",
      };

      final weather = HourWeather.fromJson(json);

      expect(weather.dateTime, DateTime.parse("2025-06-22 12:00:00"));
      expect(weather.temp, 24.75);
      expect(weather.minTemp, 23.63);
      expect(weather.maxTemp, 24.75);
      expect(weather.description, "algo de nubes");
      expect(weather.iconId, "02d");
      expect(weather.iconUrl, "https://openweathermap.org/img/wn/02d@2x.png");
    });

    test('devuelve un objeto por defecto si el JSON está mal formado', () {
      final json = {"mal": "formado"};

      final weather = HourWeather.fromJson(json);

      expect(weather.temp, 0);
      expect(weather.description, '');
      expect(weather.iconId, '');
      expect(weather.dateTime, isA<DateTime>());
    });
  });
}
