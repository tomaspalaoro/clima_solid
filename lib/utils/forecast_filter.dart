import 'package:clima_solid/models/hour_weather_model.dart';

/// Filtro para los resultados de la API.
class ForecastFilter {
  final bool applyDayFilter;

  ForecastFilter({this.applyDayFilter = true});

  /// Devuelve sólo las horas cuya fecha coincide con hoy.
  List<HourWeather> filterForCurrentDay(List<HourWeather> all) {
    if (!applyDayFilter) return all;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return all.where((hw) {
      final d = hw.dateTime;
      return DateTime(d.year, d.month, d.day) == today;
    }).toList();
  }
}
