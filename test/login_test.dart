import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clima_solid/blocs/login_cubit.dart';
import 'package:clima_solid/blocs/login_state.dart';
import 'package:clima_solid/services/login_service.dart';

/// servicio de login falso
class FakeLoginService implements LoginService {
  @override
  Future<void> login(String email, String password) async {
    // simulamos llamada exitosa
    return;
  }
}

void main() {
  group('LoginCubit', () {
    late LoginCubit cubit;

    setUp(() {
      cubit = LoginCubit(loginService: FakeLoginService());
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<LoginCubit, LoginState>(
      'emite [submitting, success] cuando el login es exitoso',
      build: () => LoginCubit(loginService: FakeLoginService()),
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
      build: () => LoginCubit(loginService: FakeLoginService()),
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
