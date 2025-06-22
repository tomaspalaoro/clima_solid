/// Modelo de objeto que devuelve la API de OpenWeatherMap.
/// Representa el clima en una hora concreta
class HourWeather {
  /// Fecha y hora de la medición
  final DateTime dateTime;

  /// Temperatura actual
  final double temp;

  /// Temperatura mínima
  final double minTemp;

  /// Temperatura máxima
  final double maxTemp;

  /// Descripción del clima actual
  final String description;

  /// Identificador de la url del icono del clima actual
  final String iconId;

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconId@2x.png';

  HourWeather({
    required this.dateTime,
    required this.temp,
    this.minTemp = 0,
    this.maxTemp = 0,
    this.description = '',
    this.iconId = '',
  });

  factory HourWeather.fromJson(Map<String, dynamic> json) {
    try {
      final main = json['main'];
      final weather = (json['weather'] as List).first;

      return HourWeather(
        dateTime: DateTime.parse(json['dt_txt']),
        temp: ((main['temp'] ?? 0) as num).toDouble(),
        minTemp: ((main['temp_min'] ?? 0) as num).toDouble(),
        maxTemp: ((main['temp_max'] ?? 0) as num).toDouble(),
        description: weather['description'] ?? '',
        iconId: weather['icon'] ?? '',
      );
    } catch (e) {
      print("Error HourWeather.fromJson: $e");
      return HourWeather(
        dateTime: DateTime.now(),
        temp: 0,
        minTemp: 0,
        maxTemp: 0,
        description: '',
        iconId: '',
      );
    }
  }
}
