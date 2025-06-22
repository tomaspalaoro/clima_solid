part of 'contact_form_cubit.dart';

enum ContactFormStatus { initial, valid, submitting, success, failure }

class ContactFormState extends Equatable {
  final String name;
  final DateTime? birthDate;
  final String city;
  final String email;
  final String phone;
  final ContactFormStatus status;

  const ContactFormState({
    required this.name,
    required this.birthDate,
    required this.city,
    required this.email,
    required this.phone,
    required this.status,
  });

  factory ContactFormState.initial() {
    return const ContactFormState(
      name: '', birthDate: null, city: '', email: '', phone: '', status: ContactFormStatus.initial
    );
  }

  bool get canSubmit {
    return name.isNotEmpty && birthDate != null && city.isNotEmpty &&
           email.isNotEmpty && phone.isNotEmpty;
  }

  @override
  List<Object?> get props => [name, birthDate, city, email, phone, status];

  ContactFormState copyWith({
    String? name,
    DateTime? birthDate,
    String? city,
    String? email,
    String? phone,
    ContactFormStatus? status,
  }) {
    final newBirthDate = birthDate ?? this.birthDate;
    return ContactFormState(
      name: name ?? this.name,
      birthDate: newBirthDate,
      city: city ?? this.city,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? (canSubmit ? ContactFormStatus.valid : ContactFormStatus.initial),
    );
  }
}
