/// Representa el clima en una hora concreta
class HourWeather {
  /// Fecha y hora de la medición
  final DateTime dateTime;

  /// Temperatura actual
  final double temp;

  /// Temperatura mínima
  final double tempMin;

  /// Temperatura máxima
  final double tempMax;

  /// Descripción del clima actual
  final String description;

  /// Identificador de la url del icono del clima actual
  final String iconId;

  HourWeather({
    required this.dateTime,
    required this.temp,
    this.tempMin = 0,
    this.tempMax = 0,
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
        tempMin: ((main['temp_min'] ?? 0) as num).toDouble(),
        tempMax: ((main['temp_max'] ?? 0) as num).toDouble(),
        description: weather['description'] ?? '',
        iconId: weather['icon'] ?? '',
      );
    } catch (e) {
      print("Error HourWeather.fromJson: $e");
      return HourWeather(
        dateTime: DateTime.now(),
        temp: 0,
        tempMin: 0,
        tempMax: 0,
        description: '',
        iconId: '',
      );
    }
  }
}
