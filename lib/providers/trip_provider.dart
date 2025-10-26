import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/mock_data_service.dart';
import '../services/storage_service.dart';

class TripProvider extends ChangeNotifier {
  List<Trip> _allTrips = [];
  List<Trip> _filteredTrips = [];
  List<String> _savedTripIds = [];
  bool _isLoading = false;

  List<Trip> get allTrips => _allTrips;
  List<Trip> get filteredTrips => _filteredTrips;
  List<String> get savedTripIds => _savedTripIds;
  bool get isLoading => _isLoading;

  TripProvider() {
    _loadTrips();
    _loadSavedTrips();
  }

  void _loadTrips() {
    _allTrips = MockDataService.getMockTrips();
    _filteredTrips = _allTrips;
    notifyListeners();
  }

  void _loadSavedTrips() {
    _savedTripIds = StorageService.getSavedTrips();
    notifyListeners();
  }

  void searchTrips(String query) {
    if (query.isEmpty) {
      _filteredTrips = _allTrips;
    } else {
      _filteredTrips = _allTrips
          .where(
            (trip) =>
                trip.name.toLowerCase().contains(query.toLowerCase()) ||
                trip.location.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  void filterByPrice(double minPrice, double maxPrice) {
    _filteredTrips = _allTrips
        .where((trip) => trip.price >= minPrice && trip.price <= maxPrice)
        .toList();
    notifyListeners();
  }

  Future<void> toggleSaveTrip(String tripId) async {
    if (_savedTripIds.contains(tripId)) {
      _savedTripIds.remove(tripId);
    } else {
      await StorageService.saveTripId(tripId);
      _savedTripIds.add(tripId);
    }
    notifyListeners();
  }

  bool isTripSaved(String tripId) {
    return _savedTripIds.contains(tripId);
  }

  Trip? getTripById(String id) {
    try {
      return _allTrips.firstWhere((trip) => trip.id == id);
    } catch (e) {
      return null;
    }
  }
}
