import 'package:sculpture_shop/features/public/shop/data/entity/product_response.dart';
import 'package:sculpture_shop/features/public/shop/data/service/shop_service.dart';
import 'package:sculpture_shop/features/public/shop/domain/repository/shop_repository.dart';

class ShopRepositoryImpl extends ShopRepository {
  final service = ShopService();

  @override
  Future<List<ProductResponse>> getProducts(int page) async {
    return await service.call(page);
  }
}
