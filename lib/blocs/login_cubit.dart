import 'package:clima_solid/blocs/login_state.dart';
import 'package:clima_solid/services/login_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:clima_solid/utils/form_validator.dart';

/// Encargado de validar y gestionar el inicio de sesión
class LoginCubit extends Cubit<LoginState> {
  final LoginService loginService;

  LoginCubit({required this.loginService}) : super(LoginState.initial());

  void emailChanged(String value) =>
      emit(state.copyWith(email: value.trim(), emailError: null));

  void passwordChanged(String value) =>
      emit(state.copyWith(password: value, passwordError: null));

  void toggleObscure() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  /// Envía el formulario de inicio de sesión
  Future<void> submit() async {
    // Comprobar errores
    final emailError = FormValidator.validateEmail(state.email);
    final passwordError = FormValidator.validatePassword(state.password);
    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(emailError: emailError, passwordError: passwordError),
      );
      return;
    }
    // No hay errores, emitir estado de submitting
    emit(
      state.copyWith(
        status: LoginStatus.submitting,
        emailError: null,
        passwordError: null,
      ),
    );

    // Login en el servicio
    await loginService.login(state.email, state.password);

    // Emitir el estado de éxito
    emit(state.copyWith(status: LoginStatus.success));
  }
}
