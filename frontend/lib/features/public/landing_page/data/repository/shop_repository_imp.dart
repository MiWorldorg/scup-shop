import 'package:sculpture_shop/features/public/landing_page/domain/repository/landing_repository.dart';
import 'package:sculpture_shop/features/public/shop/data/service/shop_service.dart';

class LandingRepositoryImpl extends LandingRepository {
  final service = ShopService();
}
