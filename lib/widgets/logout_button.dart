import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/blocs/auth_cubit.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
      iconSize: 20,
      onPressed: () => context.read<AuthCubit>().logout(),
    );
  }
}
