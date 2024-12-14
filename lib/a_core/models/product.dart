class Product {
  final int id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final String location;
  final DateTime dateListed;
  final int? numberOfBedrooms;
  final int? numberOfBathrooms;
  final int? area;
  bool isFavorite;

  Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.dateListed,
    this.numberOfBedrooms,
    this.numberOfBathrooms,
    this.area,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      location: json['location'],
      dateListed: DateTime.parse(json['dateListed']),
      numberOfBedrooms: json['numberOfBedrooms'],
      numberOfBathrooms: json['numberOfBathrooms'],
      area: json['area'],
      isFavorite: json['isFavorite'],
    );
  }
}