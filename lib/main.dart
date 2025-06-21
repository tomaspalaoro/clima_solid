import 'package:clima_solid/screens/login_screen.dart';
import 'package:clima_solid/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/cubits/language_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar EasyLocalization
  await EasyLocalization.ensureInitialized();
  runApp(
    // Es importante que toda la app tenga acceso a la localización antes de que se construyan los providers
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: Builder(
        builder: (context) {
          //
          // Inicializa el idioma actual a partir del context del Builder (que ya tiene el context de EasyLocalization)
          final Locale initialLocale = context.locale;
          //
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => LanguageCubit(initialLocale)),
            ],
            child: const MainApp(),
          );
        },
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageCubit, Locale>(
      listener: (context, locale) {
        // Cuando el cubit emita un nuevo locale, actualizamos EasyLocalization
        context.setLocale(locale);
      },
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, localeState) {
          return MaterialApp(
            home: LoginScreen(),
            theme: AppTheme.light,
            // Parámetros para inicializar EasyLocalization //
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: localeState, // El locale actual se obtiene del cubit
            //////////////////////////////////////////////
          );
        },
      ),
    );
  }
}
