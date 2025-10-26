import '../models/trip.dart';

class MockDataService {
  static List<Trip> getMockTrips() {
    return [
      Trip(
        id: '1',
        name: 'Desert Camel Adventure in Wadi Rum',
        imageUrl:
            'https://www.ramadahotelcappadocia.com/upload/atturu3-630x420.jpg',
        location: 'Wadi Rum, Jordan',
        description:
            'Experience the stunning red desert landscapes on camelback.',
        price: 89.99,
        rating: 4.8,
        reviewCount: 234,
        amenities: ['Camel', 'Guide', 'Water', 'Photos'],
        maxGuests: 8,
        category: 'Camel Riding',
      ),
      Trip(
        id: '2',
        name: 'Cooking Class with Local Chef',
        imageUrl:
            'https://www.few.ae/wp-content/uploads/2025/06/How-to-attend-Arabic-cooking-classes-in-Abu-Dhabi.jpg',
        location: 'Medina, Saudi Arabia',
        description: 'Learn authentic Arabian cooking techniques.',
        price: 75.99,
        rating: 4.9,
        reviewCount: 156,
        amenities: ['Chef', 'Ingredients', 'Recipes', 'Meals'],
        maxGuests: 12,
        category: 'Cooking Class',
      ),
      Trip(
        id: '3',
        name: 'Henna Art Workshop',
        imageUrl:
            'https://www.gamblegarden.org/wp-content/uploads/2024/08/henna-art.jpg',
        location: 'Dubai, UAE',
        description: 'Create beautiful henna designs.',
        price: 49.99,
        rating: 4.7,
        reviewCount: 445,
        amenities: ['Henna', 'Artist', 'Designs', 'Photos'],
        maxGuests: 10,
        category: 'Henna Art',
      ),
      Trip(
        id: '4',
        name: 'Premium Coffee Brewing Course',
        imageUrl:
            'https://beanburds.com/cdn/shop/articles/BI_-_03_Cov.jpg?v=1674208634',
        location: 'Cairo, Egypt',
        description: 'Master the art of coffee brewing.',
        price: 59.99,
        rating: 4.6,
        reviewCount: 312,
        amenities: ['Coffee', 'Equipment', 'Tasting', 'Certificate'],
        maxGuests: 8,
        category: 'Coffee Brewing',
      ),
      Trip(
        id: '5',
        name: 'Flexible Desert Adventure',
        imageUrl:
            'https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/12/73/a8/71.jpg',
        location: 'Oman Desert',
        description: 'Experience flexible adventure activities.',
        price: 99.99,
        rating: 4.8,
        reviewCount: 289,
        amenities: ['Guide', 'Transport', 'Meals', 'Activities'],
        maxGuests: 15,
        category: 'I\'m Flexible',
      ),
      Trip(
        id: '6',
        name: 'Gourmet Food Tour',
        imageUrl:
            'https://www.arabian-adventures.com/on/demandware.static/-/Sites-dnata-master-catalog/default/dw6030482d/images/hi-res/Taste_of_Dubai_Emirati_food_x1232.jpg',
        location: 'Istanbul, Turkey',
        description: 'Explore local cuisine and street food.',
        price: 129.99,
        rating: 4.9,
        reviewCount: 567,
        amenities: ['Guide', 'Tastings', 'Transport', 'Photos'],
        maxGuests: 12,
        category: 'Food Tours',
      ),
    ];
  }

  // ✅ GET UNIQUE POPULAR CITIES (rating >= 4.7)
  static List<String> getPopularCities() {
    final popularTrips = getMockTrips()
        .where((trip) => trip.rating >= 4.7)
        .toList();

    final cities = <String>{};
    for (var trip in popularTrips) {
      // Extract city name from location
      final cityName = trip.location.split(',').first.trim();
      cities.add(cityName);
    }

    return cities.toList();
  }

  //  FILTER TRIPS BY CATEGORY
  static List<Trip> getTripsByCategory(String category) {
    if (category == 'I\'m Flexible') {
      return getMockTrips();
    }
    return getMockTrips().where((trip) => trip.category == category).toList();
  }

  static List<String> getTripTypes() {
    return [
      'I\'m Flexible',
      'Camel Riding',
      'Cooking Class',
      'Henna Art',
      'Coffee Brewing',
      'Food Tours',
    ];
  }
}
