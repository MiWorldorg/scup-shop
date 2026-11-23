import 'package:sculpture_shop/features/authentication/data/service/auth_service.dart';
import 'package:sculpture_shop/features/authentication/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  AuthRepositoryImpl({required this.service});

  @override
  Future<Map<String, dynamic>> login(String email, String password) =>
      service.login(email, password);

  @override
  Future<Map<String, dynamic>> currentUser() => service.currentUser();

  @override
  Future<void> logout() async {
    final session = await service.currentUser();
    // The service revokes the bearer token currently held by ApiSession.
    await service.logout(session['token']?.toString() ?? '');
  }
}
