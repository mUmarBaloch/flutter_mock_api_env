
class Product {
  final int id;
  final String name;
  final String categoryName;
  final String description;
  final double price;
  final double? mrp;
  final int inventory;
  final String? addedAt;
  final String? updatedAt;
  final int? category;

  Product({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.description,
    required this.price,
    this.mrp,
    required this.inventory,
    this.addedAt,
    this.updatedAt,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      categoryName: json['category_name'],
      description: json['description'] ?? '',
      price: double.parse(json['price']),
      mrp: json['mrp'] != null ? double.parse(json['mrp']) : null,
      inventory: json['inventory'],
      addedAt: json['added_at'],
      updatedAt: json['updated_at'],
      category: json['category'],
    );
  }
}
