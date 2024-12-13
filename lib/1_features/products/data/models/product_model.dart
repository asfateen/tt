class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String location;
  final DateTime dateListed;
  final String imageUrl;
  final int sellerId;
  final bool isFavorite;
  final int? numberOfBedrooms;
  final int? numberOfBathrooms;
  final int? area;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.dateListed,
    required this.imageUrl,
    required this.sellerId,
    this.isFavorite = false,
    this.numberOfBedrooms,
    this.numberOfBathrooms,
    this.area,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      location: json['location'],
      dateListed: DateTime.parse(json['date_listed']),
      imageUrl: json['image'],
      sellerId: json['seller'],
      isFavorite: json['is_favorite'] ?? false,
      numberOfBedrooms: json['number_of_bedrooms'],
      numberOfBathrooms: json['number_of_bathrooms'],
      area: json['area'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'image': imageUrl,
      'number_of_bedrooms': numberOfBedrooms,
      'number_of_bathrooms': numberOfBathrooms,
      'area': area,
    };
  }
}