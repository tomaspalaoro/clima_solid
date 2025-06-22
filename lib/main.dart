import 'package:clima_solid/repositories/weather_repository.dart';
import 'package:clima_solid/views/login_screen.dart';
import 'package:clima_solid/repositories/city_repository.dart';
import 'package:clima_solid/services/openweather_api_service.dart';
import 'package:clima_solid/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          // Inicializa el repositorio compartido por toda la apps
          final WeatherRepository weatherRepository = OpenWeatherRepository(
            OpenWeatherApiService(),
          );
          final CityRepository cityRepository = LocalCityRepository();
          //
          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(value: weatherRepository),
              RepositoryProvider.value(value: cityRepository),
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
    return MaterialApp(
      home: LoginScreen(),
      theme: AppTheme.light,
      // Parámetros para inicializar EasyLocalization //
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      //////////////////////////////////////////////
    );
  }
}
