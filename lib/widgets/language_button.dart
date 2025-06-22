import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Widget que muestra un dropdown para cambiar el idioma de la app
/// Utiliza LanguageCubit para gestionar el estado
class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});
  @override
  Widget build(BuildContext context) {
    final code = context.locale.languageCode;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: code,
        icon: const Icon(Icons.language),
        onChanged: (newCode) {
          if (newCode != null) {
            context.setLocale(Locale(newCode));
          }
        },
        items: const [
          DropdownMenuItem(value: 'en', child: Text('EN')),
          DropdownMenuItem(value: 'es', child: Text('ES')),
        ],
      ),
    );
  }
}
