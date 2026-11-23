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
  Future<void> logout({String? token}) async {
    if (token != null && token.isNotEmpty) {
      await service.logout(token);
      return;
    }
    // The active token is supplied by the shared session.
    await service.logout('');
  }
}
