class ProductResponse {
  final String image;
  final String name;
  final String description;
  final String sku;
  final int productId;
  final String categoryName;
  final int inventoryId;
  final int price;

  ProductResponse({
    required this.image,
    required this.name,
    required this.description,
    required this.sku,
    required this.productId,
    required this.categoryName,
    required this.inventoryId,
    required this.price,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    return ProductResponse(
      image: json['image']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['desc']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      productId: _integer(json['id']),
      categoryName: category is Map ? category['name']?.toString() ?? '' : '',
      inventoryId: _integer(json['inventory_id']),
      price: _integer(json['price']),
    );
  }

  static int _integer(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
}
