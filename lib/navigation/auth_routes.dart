import 'package:clima_solid/blocs/auth_state.dart';
import 'package:clima_solid/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/blocs/auth_cubit.dart';
import 'package:clima_solid/views/home_screen.dart';
import 'package:clima_solid/views/login_screen.dart';

/// Encargado de la navegación reactiva según la autenticación
class AuthRoutes extends StatefulWidget {
  const AuthRoutes({super.key});

  @override
  State<AuthRoutes> createState() => _AuthRoutesState();
}

class _AuthRoutesState extends State<AuthRoutes> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen:
          (previous, current) =>
              current is AuthAuthenticated || current is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Si hay sesión, redirige a la pantalla de inicio
          _navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else if (state is AuthUnauthenticated) {
          // Si no hay sesión, redirige a la pantalla de login
          _navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute:
            // Pantalla temporal mientras se resuelve
            (_) => MaterialPageRoute(builder: (_) => const SplashScreen()),
      ),
    );
  }
}
