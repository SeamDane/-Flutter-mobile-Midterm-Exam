class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.thumbnail,
    required this.discountPercentage,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String brand;
  final String thumbnail;
  final double discountPercentage;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int? ?? 0,
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        brand: json['brand']?.toString() ?? '',
        thumbnail: json['thumbnail']?.toString() ?? '',
        discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      );
}
