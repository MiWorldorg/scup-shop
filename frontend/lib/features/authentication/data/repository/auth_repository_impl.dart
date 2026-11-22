import 'package:sculpture_shop/features/authentication/data/service/auth_service.dart';
import 'package:sculpture_shop/features/authentication/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final service = AuthService();

  @override
  Future<Map<String, dynamic>> login(String email, String password) =>
      service.login(email, password);
}
