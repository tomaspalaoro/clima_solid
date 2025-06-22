import 'package:clima_solid/blocs/contact_form_cubit.dart';
import 'package:clima_solid/utils/form_validator.dart';
import 'package:clima_solid/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactFormTab extends StatelessWidget {
  final DateFormatter dateFormatter;

  const ContactFormTab({super.key, required this.dateFormatter});

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<ContactFormCubit>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      cubit.birthDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactFormCubit, ContactFormState>(
      builder: (context, state) {
        final cubit = context.read<ContactFormCubit>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: state.name,
                  decoration: InputDecoration(labelText: tr('contact_name')),
                  onChanged: cubit.nameChanged,
                  validator: FormValidator.validateName,
                ),
                const SizedBox(height: 16),
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
                  ),
                  validator:
                      (_) => FormValidator.validateBirthDate(state.birthDate),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: state.city,
                  decoration: InputDecoration(labelText: tr('contact_city')),
                  onChanged: cubit.cityChanged,
                  validator: FormValidator.validateCity,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: state.email,
                  decoration: InputDecoration(labelText: tr('contact_email')),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: cubit.emailChanged,
                  validator: FormValidator.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: state.phone,
                  decoration: InputDecoration(labelText: tr('contact_phone')),
                  keyboardType: TextInputType.phone,
                  onChanged: cubit.phoneChanged,
                  validator: FormValidator.validatePhone,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed:
                      state.canSubmit
                          ? () async {
                            await cubit.submit();
                            if (context.mounted &&
                                context.read<ContactFormCubit>().state.status ==
                                    ContactFormStatus.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(tr('sent_success'))),
                              );
                            }
                          }
                          : null,
                  child: Text(tr('send')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
