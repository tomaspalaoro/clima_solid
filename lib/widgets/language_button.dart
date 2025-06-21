import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/cubits/language_cubit.dart';

/// Widget que muestra un dropdown para cambiar el idioma de la app
/// Utiliza LanguageCubit para gestionar el estado
class LanguageButton extends StatefulWidget {
  const LanguageButton({super.key});

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LanguageCubit>();
    final currentCode = cubit.state.languageCode;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentCode,
        icon: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Icon(
            Icons.language,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onChanged: (value) {
          if (value != null) {
            cubit.changeLanguage(value);
          }
        },
        items: [
          DropdownMenuItem(
            value: 'en',
            child: Text('EN', style: Theme.of(context).textTheme.titleSmall),
          ),
          DropdownMenuItem(
            value: 'es',
            child: Text('ES', style: Theme.of(context).textTheme.titleSmall),
          ),
        ],
      ),
    );
  }
}
