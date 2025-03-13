class Restaurant {
  String id;
  String name;
  String category;
  String location;

  Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'location': location,
    };
  }

  factory Restaurant.fromMap(String id, Map<String, dynamic> map) {
    return Restaurant(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
    );
  }
}
