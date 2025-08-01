class Hotel {
  final String name;
  final String city;
  final String availableFrom;
  final String availableTo;
  final String imageUrl;

  Hotel({
    required this.name,
    required this.city,
    required this.availableFrom,
    required this.availableTo,
    required this.imageUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'],
      city: json['city'],
      availableFrom: json['available_from'],
      availableTo: json['available_to'],
      imageUrl: json['image_url'],
    );
  }
}
