import 'package:clima_solid/blocs/contact_form_cubit.dart';
import 'package:clima_solid/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tab para el formulario de contacto
class ContactFormTab extends StatelessWidget {
  final DateFormatter dateFormatter;

  const ContactFormTab({super.key, required this.dateFormatter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactFormCubit, ContactFormState>(
      builder: (context, state) {
        final cubit = context.read<ContactFormCubit>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // NOMBRE
              TextFormField(
                initialValue: state.name,
                decoration: InputDecoration(
                  labelText: tr('contact_name'),
                  errorText: state.fieldErrors['name'],
                ),
                onChanged: cubit.nameChanged,
              ),
              const SizedBox(height: 16),
              // FECHA DE NACIMIENTO
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text:
                      state.birthDate == null
                          ? ''
                          : dateFormatter.format(
                            state.birthDate!,
                            context.locale,
                          ),
                ),
                onTap: () => _pickDate(context),
                decoration: InputDecoration(
                  labelText: tr('contact_birthdate'),
                  errorText: state.fieldErrors['birthDate'],
                ),
              ),
              const SizedBox(height: 16),
              // CIUDAD
              TextFormField(
                initialValue: state.city,
                decoration: InputDecoration(
                  labelText: tr('contact_city'),
                  errorText: state.fieldErrors['city'],
                ),
                onChanged: cubit.cityChanged,
              ),
              const SizedBox(height: 16),
              // CORREO ELECTRÓNICO
              TextFormField(
                initialValue: state.email,
                decoration: InputDecoration(
                  labelText: tr('contact_email'),
                  errorText: state.fieldErrors['email'],
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: cubit.emailChanged,
              ),
              const SizedBox(height: 16),
              // TELEFONO
              TextFormField(
                initialValue: state.phone,
                decoration: InputDecoration(
                  labelText: tr('contact_phone'),
                  errorText: state.fieldErrors['phone'],
                ),
                keyboardType: TextInputType.phone,
                onChanged: cubit.phoneChanged,
              ),
              const SizedBox(height: 24),
              // Enviar
              FilledButton(
                onPressed:
                    // El botón se activa cuando todos los campos son válidos
                    state.canSubmit
                        ? () async {
                          // Enviar el formulario
                          await cubit.submit();
                          // Si se envió correctamente, muestra un mensaje
                          if (context.mounted &&
                              cubit.state.status == ContactFormStatus.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(tr('sent_success'))),
                            );
                          }
                        }
                        : null,
                child:
                    // Mostrar un indicador de carga si se está enviando
                    state.status == ContactFormStatus.submitting
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Text(tr('send')),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Abre el selector de fecha
  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<ContactFormCubit>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      // fecha inicial
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      // fecha mínima
      firstDate: DateTime(1900),
      // fecha máxima
      lastDate: now,
    );
    if (picked != null) {
      cubit.birthDateChanged(picked);
    }
  }
}
