import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clima_solid/blocs/login_cubit.dart';
import 'package:clima_solid/blocs/login_state.dart';
import 'package:clima_solid/services/login_service.dart';
import 'package:clima_solid/services/auth_service.dart';

/// servicio de auth falso
class TestAuthService implements AuthService {
  String? storedEmail;

  @override
  Future<String?> getLoggedEmail() async => storedEmail;

  @override
  Future<void> setLoggedEmail(String email) async {
    storedEmail = email;
  }

  @override
  Future<void> logout() async {
    storedEmail = null;
  }
}

void main() {
  group('LoginCubit', () {
    late LoginCubit cubit;
    late TestAuthService authService;

    setUp(() {
      authService = TestAuthService();
      cubit = LoginCubit(
        loginService: FakeLoginService(),
        authService: authService,
      );
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<LoginCubit, LoginState>(
      'emite [submitting, success] cuando el login es exitoso',
      build:
          () => LoginCubit(
            loginService: FakeLoginService(),
            authService: TestAuthService(),
          ),
      act: (cubit) async {
        cubit.emailChanged('test@example.com');
        cubit.passwordChanged('password123');
        await cubit.submit();
      },
      expect:
          () => [
            isA<LoginState>().having(
              (s) => s.email,
              'email',
              'test@example.com',
            ),
            isA<LoginState>().having(
              (s) => s.password,
              'password',
              'password123',
            ),
            isA<LoginState>().having(
              (s) => s.status,
              'status',
              LoginStatus.submitting,
            ),
            isA<LoginState>().having(
              (s) => s.status,
              'status',
              LoginStatus.success,
            ),
          ],
    );

    blocTest<LoginCubit, LoginState>(
      'emite error de email si el email es inválido',
      build:
          () => LoginCubit(
            loginService: FakeLoginService(),
            authService: TestAuthService(),
          ),
      act: (cubit) async {
        cubit.emailChanged('email-malo');
        cubit.passwordChanged('password123');
        await cubit.submit();
      },
      expect:
          () => [
            isA<LoginState>().having((s) => s.email, 'email', 'email-malo'),
            isA<LoginState>().having(
              (s) => s.password,
              'password',
              'password123',
            ),
            isA<LoginState>()
                .having((s) => s.emailError, 'emailError', isNotNull)
                .having((s) => s.passwordError, 'passwordError', isNull)
                .having((s) => s.status, 'status', LoginStatus.initial),
          ],
    );
  });
}
