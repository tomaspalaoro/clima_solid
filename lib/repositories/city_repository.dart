import 'package:clima_solid/models/city_model.dart';

abstract class CityRepository {
  /// Devuelve el listado de ciudades
  Future<List<City>> getSupportedCities();
}

class LocalCityRepository implements CityRepository {
  static const _defaults = [City('london'), City('toronto'), City('singapore')];

  @override
  Future<List<City>> getSupportedCities() async {
    return _defaults;
  }
}
