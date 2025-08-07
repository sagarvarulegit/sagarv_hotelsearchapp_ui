class Hotel {
  final String id;
  final String name;
  final String city;
  final String availableFrom;
  final String availableTo;
  final String imageUrl;
  final double rating;
  final double price;
  final String description;

  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.availableFrom,
    required this.availableTo,
    required this.imageUrl,
    required this.rating,
    required this.price,
    this.description = '',
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      availableFrom: json['available_from'] ?? '',
      availableTo: json['available_to'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'available_from': availableFrom,
      'available_to': availableTo,
      'image_url': imageUrl,
      'rating': rating,
      'price': price,
      'description': description,
    };
  }
}
