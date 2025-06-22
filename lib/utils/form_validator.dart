import 'package:easy_localization/easy_localization.dart';

class FormValidator {
  static String? validateName(String? v) =>
      (v == null || v.isEmpty) ? tr('required_field') : null;

  static String? validateBirthDate(DateTime? d) =>
      (d == null) ? tr('required_field') : null;

  static String? validateCity(String? v) =>
      (v == null || v.isEmpty) ? tr('required_field') : null;

  static String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return tr('required_field');
    return v.contains('@') ? null : tr('invalid_email');
  }

  static String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return tr('required_field');
    return v.length < 9 ? tr('invalid_phone') : null;
  }

  static String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return tr('required_field');
    return null;
  }
}
