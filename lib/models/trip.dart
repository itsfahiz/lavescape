class Trip {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final List<String> amenities;
  final int maxGuests;
  final String category;

  Trip({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    required this.maxGuests,
    this.category = 'I\'m Flexible', //  ADD DEFAULT
  });
}
