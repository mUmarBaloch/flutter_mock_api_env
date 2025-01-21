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
