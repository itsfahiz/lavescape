import 'package:get_storage/get_storage.dart';
import '../config/constants.dart';
import '../models/user.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  //  AUTHENTICATION METHODS
  static Future<void> setLoggedIn(bool value) async {
    await _storage.write('isLoggedIn', value);
  }

  static bool isLoggedIn() {
    return _storage.read('isLoggedIn') ?? false;
  }

  static Future<void> logout() async {
    await _storage.remove('isLoggedIn');
    await clearUser();
    await _storage.remove(AppConstants.tokenKey);
  }

  // User
  static Future<void> saveUser(User user) async {
    await _storage.write(AppConstants.userKey, user.toJson());
  }

  static User? getUser() {
    final userData = _storage.read(AppConstants.userKey);
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  static Future<void> clearUser() async {
    await _storage.remove(AppConstants.userKey);
  }

  // Token
  static Future<void> saveToken(String token) async {
    await _storage.write(AppConstants.tokenKey, token);
  }

  static String? getToken() {
    return _storage.read(AppConstants.tokenKey);
  }

  // Saved trips
  static Future<void> saveTripId(String tripId) async {
    try {
      final savedData = _storage.read(AppConstants.savedTripsKey);

      List<String> savedTrips = [];
      if (savedData != null) {
        if (savedData is List) {
          savedTrips = List<String>.from(
            savedData.map((trip) => trip.toString()).toList(),
          );
        }
      }

      if (!savedTrips.contains(tripId)) {
        savedTrips.add(tripId);
        await _storage.write(AppConstants.savedTripsKey, savedTrips);
      }
    } catch (e) {
      print('Error saving trip: $e');
    }
  }

  static List<String> getSavedTrips() {
    try {
      final savedData = _storage.read(AppConstants.savedTripsKey);

      if (savedData == null) {
        return [];
      }

      if (savedData is List) {
        return List<String>.from(
          savedData.map((trip) => trip.toString()).toList(),
        );
      }

      return [];
    } catch (e) {
      print('Error getting saved trips: $e');
      return [];
    }
  }

  static Future<void> removeTripId(String tripId) async {
    try {
      final savedData = _storage.read(AppConstants.savedTripsKey);

      List<String> savedTrips = [];
      if (savedData != null && savedData is List) {
        savedTrips = List<String>.from(
          savedData.map((trip) => trip.toString()).toList(),
        );
      }

      savedTrips.removeWhere((trip) => trip == tripId);
      await _storage.write(AppConstants.savedTripsKey, savedTrips);
    } catch (e) {
      print('Error removing trip: $e');
    }
  }

  static bool isTripSaved(String tripId) {
    try {
      return getSavedTrips().contains(tripId);
    } catch (e) {
      print('Error checking if trip saved: $e');
      return false;
    }
  }

  static Future<void> clearSavedTrips() async {
    try {
      await _storage.remove(AppConstants.savedTripsKey);
    } catch (e) {
      print('Error clearing saved trips: $e');
    }
  }

  // Recent searches
  static Future<void> addRecentSearch({
    required String city,
    required String title,
    required String date,
    required String image,
    String? guest,
    int? categoryIndex,
  }) async {
    try {
      final savedData = _storage.read(AppConstants.recentSearchesKey);

      List<Map<String, dynamic>> searches = [];
      if (savedData != null && savedData is List) {
        searches = List<Map<String, dynamic>>.from(
          savedData.map((search) {
            if (search is Map) {
              return Map<String, dynamic>.from(search);
            }
            return {};
          }).toList(),
        );
      }

      searches.removeWhere((search) => search['city'] == city);

      searches.insert(0, {
        'city': city,
        'title': title,
        'date': date,
        'image': image,
        'guest': guest ?? '',
        'categoryIndex': categoryIndex ?? 0,
      });

      if (searches.length > 3) {
        searches = searches.sublist(0, 3);
      }

      await _storage.write(AppConstants.recentSearchesKey, searches);
    } catch (e) {
      print('Error adding recent search: $e');
    }
  }

  static List<Map<String, dynamic>> getRecentSearches() {
    try {
      final recentSearches = _storage.read(AppConstants.recentSearchesKey);

      if (recentSearches == null) {
        return [];
      }

      if (recentSearches is List) {
        return List<Map<String, dynamic>>.from(
          recentSearches.map((search) {
            if (search is Map) {
              return Map<String, dynamic>.from(search);
            }
            return {};
          }).toList(),
        );
      }

      return [];
    } catch (e) {
      print('Error getting recent searches: $e');
      return [];
    }
  }

  static Future<void> clearRecentSearches() async {
    try {
      await _storage.remove(AppConstants.recentSearchesKey);
    } catch (e) {
      print('Error clearing recent searches: $e');
    }
  }
}
