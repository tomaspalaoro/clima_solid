import 'package:clima_solid/repositories/weather_repository.dart';
import 'package:clima_solid/services/contact_service.dart';
import 'package:clima_solid/utils/forecast_filter.dart';
import 'package:clima_solid/views/login_screen.dart';
import 'package:clima_solid/repositories/city_repository.dart';
import 'package:clima_solid/services/weather_api_service.dart';
import 'package:clima_solid/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Inicializar los repositorios compartidos por toda la app
  final WeatherRepository weatherRepository = OpenWeatherRepository(
    apiService: OpenWeatherApiService(),
    filter: ForecastFilter(),
  );
  final CityRepository cityRepository = LocalCityRepository();
  final ContactService contactService = FakeContactService();
  //
  runApp(
    // Es importante que toda la app tenga acceso a la localización antes de que se construyan los providers
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: weatherRepository),
          RepositoryProvider.value(value: cityRepository),
          RepositoryProvider.value(value: contactService),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
