class ShopModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int owner;

  ShopModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
  });

  
  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      owner: json['owner'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'owner': owner,
    };
  }
}


List<ShopModel> mockShops = [
  ShopModel(
    id: 1,
    name: "Tech Haven",
    description: "Your one-stop shop for the latest in electronics and gadgets.",
    address: "123 Tech Street, Silicon Valley, CA",
    createdAt: DateTime.parse("2025-01-01T10:00:00Z"),
    updatedAt: DateTime.parse("2025-01-15T12:00:00Z"),
    owner: 101,
  ),
  ShopModel(
    id: 2,
    name: "Style Hub",
    description: "Trendy apparel and accessories for men and women.",
    address: "456 Fashion Avenue, New York, NY",
    createdAt: DateTime.parse("2025-01-02T11:30:00Z"),
    updatedAt: DateTime.parse("2025-01-20T14:45:00Z"),
    owner: 102,
  ),
];
