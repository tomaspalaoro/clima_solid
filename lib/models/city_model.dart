import 'package:easy_localization/easy_localization.dart';

class City {
  final String name;

  String get displayName => tr(name);

  const City(this.name);
}
