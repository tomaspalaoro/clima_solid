import 'package:clima_solid/models/contact_model.dart';

abstract class ContactService {
  Future<void> send(Contact contact);
}

class FakeContactService implements ContactService {
  @override
  Future<void> send(Contact contact) async {
    // Simula envío a backend
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
