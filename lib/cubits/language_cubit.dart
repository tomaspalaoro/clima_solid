import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

/// Cubit de Bloc para gestionar el idioma de la app (locale)
class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(super.initialLocale);

  void changeLanguage(String languageCode) {
    emit(Locale(languageCode));
  }
}
