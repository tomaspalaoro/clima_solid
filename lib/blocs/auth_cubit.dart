import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

  /// Comprueba si hay una sesión guardada.
  /// Si hay una sesión, emite AuthAuthenticated.
  /// Si no hay una sesión, emite AuthUnauthenticated.
  Future<void> checkSession() async {
    try {
      final email = await authService.getLoggedEmail();
      if (email != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Cierra la sesión
  Future<void> logout() async {
    try {
      await authService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
