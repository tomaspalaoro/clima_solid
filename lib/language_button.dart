import 'package:flutter/material.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton({super.key});

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedLanguage,
        dropdownColor: Colors.blue[100],
        icon: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Icon(
            Icons.language,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedLanguage = value;
            });
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
