import 'package:equatable/equatable.dart';

enum LoginStatus { initial, submitting, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool obscurePassword;
  final LoginStatus status;
  final String? emailError;
  final String? passwordError;

  const LoginState({
    required this.email,
    required this.password,
    required this.obscurePassword,
    required this.status,
    required this.emailError,
    required this.passwordError,
  });

  factory LoginState.initial() => const LoginState(
    email: '',
    password: '',
    obscurePassword: true,
    status: LoginStatus.initial,
    emailError: null,
    passwordError: null,
  );

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    LoginStatus? status,
    String? emailError,
    String? passwordError,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    obscurePassword,
    status,
    emailError,
    passwordError,
  ];
}
