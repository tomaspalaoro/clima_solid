abstract class LoginService {
  Future<void> login(String email, String password);
}

class FakeLoginService implements LoginService {
  @override
  Future<void> login(String email, String password) async {
    // Simula envío a backend
    await Future.delayed(const Duration(seconds: 1));
  }
}
