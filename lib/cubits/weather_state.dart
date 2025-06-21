import 'package:clima_solid/models/hour_weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final List<HourWeather> hoursList;
  WeatherLoaded(this.hoursList);
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
