class Category {
  final String id;
  final String icon;
  final String name;

  Category({
    required this.id,
    required this.icon,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      icon: json['icon'] as String,
      name: json['name'] as String,
    );
  }
} 