
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


List<Product> mockProducts = [
  Product(
    id: 1,
    name: "Smartphone",
    categoryName: "Electronics",
    description: "Latest 5G smartphone with high-speed performance.",
    price: 999.99,
    mrp: 1199.99,
    inventory: 50,
    addedAt: "2025-01-01",
    updatedAt: "2025-01-15",
    category: 1,
  ),
  Product(
    id: 2,
    name: "Laptop",
    categoryName: "Computers",
    description: "Lightweight and powerful laptop for professionals.",
    price: 1499.99,
    mrp: 1599.99,
    inventory: 30,
    addedAt: "2025-01-02",
    updatedAt: "2025-01-18",
    category: 2,
  ),
  Product(
    id: 3,
    name: "Bluetooth Speaker",
    categoryName: "Audio",
    description: "Portable Bluetooth speaker with high-quality sound.",
    price: 49.99,
    mrp: 59.99,
    inventory: 100,
    addedAt: "2025-01-03",
    updatedAt: "2025-01-12",
    category: 3,
  ),
  Product(
    id: 4,
    name: "Wristwatch",
    categoryName: "Accessories",
    description: "Stylish wristwatch with waterproof design.",
    price: 199.99,
    mrp: 249.99,
    inventory: 75,
    addedAt: "2025-01-04",
    updatedAt: "2025-01-14",
    category: 4,
  ),
  Product(
    id: 5,
    name: "Gaming Console",
    categoryName: "Gaming",
    description: "Next-gen gaming console with immersive gameplay.",
    price: 499.99,
    mrp: 549.99,
    inventory: 20,
    addedAt: "2025-01-05",
    updatedAt: "2025-01-16",
    category: 5,
  ),
  Product(
    id: 6,
    name: "Running Shoes",
    categoryName: "Footwear",
    description: "Comfortable running shoes for everyday wear.",
    price: 89.99,
    mrp: 99.99,
    inventory: 120,
    addedAt: "2025-01-06",
    updatedAt: "2025-01-17",
    category: 6,
  ),
  Product(
    id: 7,
    name: "Digital Camera",
    categoryName: "Photography",
    description: "High-resolution camera for stunning photos.",
    price: 699.99,
    mrp: 749.99,
    inventory: 15,
    addedAt: "2025-01-07",
    updatedAt: "2025-01-18",
    category: 7,
  ),
  Product(
    id: 8,
    name: "Smart TV",
    categoryName: "Home Appliances",
    description: "Ultra HD smart TV with voice control.",
    price: 1199.99,
    mrp: 1299.99,
    inventory: 10,
    addedAt: "2025-01-08",
    updatedAt: "2025-01-19",
    category: 8,
  ),
  Product(
    id: 9,
    name: "Fitness Tracker",
    categoryName: "Health",
    description: "Wearable fitness tracker with heart rate monitoring.",
    price: 49.99,
    mrp: 69.99,
    inventory: 200,
    addedAt: "2025-01-09",
    updatedAt: "2025-01-20",
    category: 9,
  ),
  Product(
    id: 10,
    name: "Coffee Maker",
    categoryName: "Kitchen",
    description: "Automatic coffee maker with multiple brewing options.",
    price: 79.99,
    mrp: 99.99,
    inventory: 40,
    addedAt: "2025-01-10",
    updatedAt: "2025-01-21",
    category: 10,
  ),
];
