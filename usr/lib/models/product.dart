class Product {
  final String id;
  String name;
  String sku;
  double price;
  int stock;
  String description;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.stock,
    this.description = '',
  });

  Product copyWith({
    String? id,
    String? name,
    String? sku,
    double? price,
    int? stock,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      description: description ?? this.description,
    );
  }
}
