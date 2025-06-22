import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clima_solid/models/contact_model.dart';
import 'package:clima_solid/services/contact_service.dart';
import 'package:clima_solid/utils/form_validator.dart';

part 'contact_form_state.dart';

/// Encargado de validar y enviar el formulario de contacto
class ContactFormCubit extends Cubit<ContactFormState> {
  final ContactService contactService;

  ContactFormCubit({required this.contactService})
    : super(ContactFormState.initial());

  void nameChanged(String value) {
    final error = FormValidator.validateName(value);
    emit(
      state.copyWith(
        name: value,
        fieldErrors: {...state.fieldErrors, 'name': error},
      ),
    );
  }

  void birthDateChanged(DateTime value) {
    final error = FormValidator.validateBirthDate(value);
    emit(
      state.copyWith(
        birthDate: value,
        fieldErrors: {...state.fieldErrors, 'birthDate': error},
      ),
    );
  }

  void cityChanged(String value) {
    final error = FormValidator.validateCity(value);
    emit(
      state.copyWith(
        city: value,
        fieldErrors: {...state.fieldErrors, 'city': error},
      ),
    );
  }

  void emailChanged(String value) {
    final error = FormValidator.validateEmail(value);
    emit(
      state.copyWith(
        email: value,
        fieldErrors: {...state.fieldErrors, 'email': error},
      ),
    );
  }

  void phoneChanged(String value) {
    final error = FormValidator.validatePhone(value);
    emit(
      state.copyWith(
        phone: value,
        fieldErrors: {...state.fieldErrors, 'phone': error},
      ),
    );
  }

  /// Intenta enviar el formulario y emite el estado resultante
  Future<void> submit() async {
    // Vuelve a validar todos los campos
    final errors = {
      'name': FormValidator.validateName(state.name),
      'birthDate': FormValidator.validateBirthDate(state.birthDate),
      'city': FormValidator.validateCity(state.city),
      'email': FormValidator.validateEmail(state.email),
      'phone': FormValidator.validatePhone(state.phone),
    };
    if (errors.values.any((e) => e != null)) {
      emit(state.copyWith(fieldErrors: errors));
      return;
    }
    // Si no hay errores, entra en estado de envío
    emit(state.copyWith(status: ContactFormStatus.submitting));
    try {
      final contact = Contact(
        name: state.name.trim(),
        birthDate: state.birthDate!,
        city: state.city.trim(),
        email: state.email.trim(),
        phone: state.phone.trim(),
      );
      // Envía el formulario
      await contactService.send(contact);
      // Si el service envía correctamente, entra en estado de éxito
      emit(state.copyWith(status: ContactFormStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ContactFormStatus.failure));
    }
  }
}
