class Destination {
  final String city;

  Destination({required this.city});

  factory Destination.fromString(String cityName) {
    return Destination(
      city: cityName,
    );
  }
}
