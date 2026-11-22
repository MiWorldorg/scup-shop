class ProductListResponse {
  final int id;
  final String name;
  final String desc;
  final String image;
  final String sku;
  final int categoryId;
  final String categoryName;
  final int inventoryId;
  final int quantity;
  final int price;

  ProductListResponse({
    required this.id,
    required this.name,
    required this.desc,
    required this.image,
    required this.sku,
    required this.categoryId,
    required this.categoryName,
    required this.inventoryId,
    required this.quantity,
    required this.price,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final inventory = json['inventory'];
    return ProductListResponse(
      id: _integer(json['id']),
      name: json['name']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      categoryId: _integer(json['category_id']),
      categoryName: category is Map ? category['name']?.toString() ?? '' : '',
      inventoryId: _integer(json['inventory_id']),
      quantity: inventory is Map ? _integer(inventory['quantity']) : 0,
      price: _integer(json['price']),
    );
  }
}

class ProductCategoryResponse {
  final int id;
  final String name;

  const ProductCategoryResponse({required this.id, required this.name});

  factory ProductCategoryResponse.fromJson(Map<String, dynamic> json) =>
      ProductCategoryResponse(
        id: _integer(json['id']),
        name: json['name']?.toString() ?? '',
      );
}

int _integer(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
