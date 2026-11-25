class ShopCategoryResponse {
  final int id;
  final String name;

  const ShopCategoryResponse({required this.id, required this.name});

  factory ShopCategoryResponse.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return ShopCategoryResponse(
      id: rawId is num ? rawId.toInt() : int.tryParse('$rawId') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}
