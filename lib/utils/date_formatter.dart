import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class DateFormatter {
  String format(DateTime date, Locale locale);
}

class EasyDateFormatter implements DateFormatter {
  /// Formatea una fecha según el locale actual
  @override
  String format(DateTime date, Locale locale) {
    return DateFormat.yMMMd(locale.toString()).format(date);
  }
}
