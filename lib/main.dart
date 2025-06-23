import 'package:clima_solid/repositories/weather_repository.dart';
import 'package:clima_solid/services/contact_service.dart';
import 'package:clima_solid/utils/forecast_filter.dart';
import 'package:clima_solid/repositories/city_repository.dart';
import 'package:clima_solid/services/weather_api_service.dart';
import 'package:clima_solid/theme.dart';
import 'package:clima_solid/navigation/auth_routes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/services/auth_service.dart';
import 'package:clima_solid/blocs/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Inicializar los repositorios
  final WeatherRepository weatherRepository = OpenWeatherRepository(
    apiService: OpenWeatherApiService(),
    filter: ForecastFilter(),
  );
  final CityRepository cityRepository = LocalCityRepository();
  final ContactService contactService = FakeContactService();
  final AuthService authService = StorageAuthService();
  runApp(
    // Es importante que toda la app tenga acceso a la localización antes de que se construyan los providers
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiRepositoryProvider(
        providers: [
          // Repositorios compartidos por toda la app
          RepositoryProvider.value(value: weatherRepository),
          RepositoryProvider.value(value: cityRepository),
          RepositoryProvider.value(value: contactService),
          RepositoryProvider.value(value: authService),
        ],
        child: BlocProvider(
          create:
              (context) =>
                  AuthCubit(authService: authService)
                    ..checkSession(), // comprueba sesión al iniciar la app
          child: const MainApp(),
        ),
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
      home: const AuthRoutes(), // Navegación según autenticación
      theme: AppTheme.light,
      // Parámetros para inicializar EasyLocalization //
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      //////////////////////////////////////////////
    );
  }
}
