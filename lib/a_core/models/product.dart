class Product {
  final String id;
  final String category;
  final DateTime dateListed;
  final String description;
  final String imageUrl;
  bool isFavorite;
  final String location;
  final double price;
  final String title;
  final int? area;
  final int? numberOfBathrooms;
  final int? numberOfBedrooms;

  Product({
    required this.id,
    required this.category,
    required this.dateListed,
    required this.description,
    required this.imageUrl,
    required this.isFavorite,
    required this.location,
    required this.price,
    required this.title,
    this.area,
    this.numberOfBathrooms,
    this.numberOfBedrooms,
  });

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      category: json['category']?.toString() ?? '',
      dateListed: DateTime.tryParse(json['dateListed']?.toString() ?? '') ?? DateTime.now(),
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      location: json['location']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      title: json['title']?.toString() ?? '',
      area: json['area'] as int?,
      numberOfBathrooms: json['numberOfBathrooms'] as int?,
      numberOfBedrooms: json['numberOfBedrooms'] as int?,
    );
  }
}
