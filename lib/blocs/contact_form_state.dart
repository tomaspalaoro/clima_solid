part of 'contact_form_cubit.dart';

enum ContactFormStatus { initial, valid, submitting, success, failure }

/// Estado del cubit de contacto
class ContactFormState extends Equatable {
  final String name;
  final DateTime? birthDate;
  final String city;
  final String email;
  final String phone;
  final ContactFormStatus status;
  final Map<String, String?> fieldErrors;

  const ContactFormState({
    required this.name,
    required this.birthDate,
    required this.city,
    required this.email,
    required this.phone,
    required this.status,
    required this.fieldErrors,
  });

  factory ContactFormState.initial() {
    return const ContactFormState(
      name: '',
      birthDate: null,
      city: '',
      email: '',
      phone: '',
      status: ContactFormStatus.initial,
      fieldErrors: {},
    );
  }

  bool get canSubmit =>
      name.isNotEmpty &&
      birthDate != null &&
      city.isNotEmpty &&
      email.isNotEmpty &&
      phone.isNotEmpty &&
      fieldErrors.values.every((e) => e == null);

  /// Crea una copia del estado con los valores proporcionados
  ContactFormState copyWith({
    String? name,
    DateTime? birthDate,
    String? city,
    String? email,
    String? phone,
    ContactFormStatus? status,
    Map<String, String?>? fieldErrors,
  }) {
    return ContactFormState(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      city: city ?? this.city,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  List<Object?> get props => [
    name,
    birthDate,
    city,
    email,
    phone,
    status,
    fieldErrors,
  ];
}
