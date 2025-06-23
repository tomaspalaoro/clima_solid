import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/blocs/auth_cubit.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tr('logout'),
      icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
      iconSize: 20,
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(tr('logout')),
                content: Text(tr('logout_confirmation')),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(tr('cancel')),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(tr('accept')),
                  ),
                ],
              ),
        );

        if (confirmed == true && context.mounted) {
          await context.read<AuthCubit>().logout();
        }
      },
    );
  }
}
