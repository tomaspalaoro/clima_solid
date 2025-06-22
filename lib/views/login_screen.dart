import 'package:clima_solid/blocs/login_cubit.dart';
import 'package:clima_solid/blocs/login_state.dart';
import 'package:clima_solid/services/login_service.dart';
import 'package:clima_solid/views/home_screen.dart';
import 'package:clima_solid/widgets/language_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pantalla de inicio de sesión
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(loginService: FakeLoginService()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    // Listener que espera a que el estado cambie a success
    return BlocListener<LoginCubit, LoginState>(
      listenWhen:
          (previous, current) =>
              previous.status != current.status &&
              current.status == LoginStatus.success,
      listener: (context, state) {
        // Si el estado es success, navegar a la pantalla de inicio
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: LanguageButton(),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            _buildBackground(),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 100.0,
              ),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  final cubit = context.read<LoginCubit>();
                  return Column(
                    children: [
                      const SizedBox(height: 20.0),
                      _buildTitle(context),
                      const SizedBox(height: 40.0),
                      // EMAIL
                      _buildTextField(
                        context: context,
                        label: tr('user'),
                        hint: tr('enter_email'),
                        value: state.email,
                        onChanged: cubit.emailChanged,
                        errorText: state.emailError,
                      ),
                      const SizedBox(height: 20.0),
                      // CONTRASEÑA
                      _buildTextField(
                        context: context,
                        label: tr('password'),
                        hint: tr('enter_password'),
                        value: state.password,
                        onChanged: cubit.passwordChanged,
                        isPassword: true,
                        obscureText: state.obscurePassword,
                        toggleObscure: cubit.toggleObscure,
                        errorText: state.passwordError,
                      ),
                      const SizedBox(height: 30.0),
                      // Botón de login
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed:
                              state.status != LoginStatus.submitting
                                  ? () {
                                    // Llama al cubit para enviar el formulario
                                    cubit.submit(context);
                                  }
                                  : null,
                          child:
                              // Mostrar un indicador de carga si el estado es submitting
                              state.status == LoginStatus.submitting
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    tr('login'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff6190e8), Color(0xffa7bfe8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.sunny, color: Colors.white, size: 40),
        const SizedBox(width: 10),
        Text(
          tr('app_title'),
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
    String? errorText,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10.0),
        TextField(
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType:
              isPassword
                  ? TextInputType.visiblePassword
                  : TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText?.isEmpty == true ? null : errorText,
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: toggleObscure,
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
