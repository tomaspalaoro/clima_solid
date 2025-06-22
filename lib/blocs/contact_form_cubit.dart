import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clima_solid/models/contact_model.dart';
import 'package:clima_solid/services/contact_service.dart';

part 'contact_form_state.dart';

class ContactFormCubit extends Cubit<ContactFormState> {
  final ContactService contactService;

  ContactFormCubit({required this.contactService})
    : super(ContactFormState.initial());

  void nameChanged(String value) => emit(state.copyWith(name: value));
  void birthDateChanged(DateTime value) =>
      emit(state.copyWith(birthDate: value));
  void cityChanged(String value) => emit(state.copyWith(city: value));
  void emailChanged(String value) => emit(state.copyWith(email: value));
  void phoneChanged(String value) => emit(state.copyWith(phone: value));

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(status: ContactFormStatus.submitting));
    try {
      final contact = Contact(
        name: state.name.trim(),
        birthDate: state.birthDate!,
        city: state.city.trim(),
        email: state.email.trim(),
        phone: state.phone.trim(),
      );
      await contactService.send(contact);
      emit(state.copyWith(status: ContactFormStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ContactFormStatus.failure));
    }
  }
}
