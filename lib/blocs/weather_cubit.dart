import 'package:clima_solid/repositories/weather_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;

  WeatherCubit(this.repository) : super(WeatherInitial());

  Future<void> fetchForecast({
    required String city,
    required String lang,
  }) async {
    emit(WeatherLoading());
    try {
      final forecast = await repository.getHourlyForecast(
        city: city,
        lang: lang,
      );
      emit(WeatherLoaded(forecast));
    } catch (e) {
      emit(WeatherError('Error: $e'));
    }
  }
}
