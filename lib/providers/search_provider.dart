import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String? _selectedLocation;
  DateTime? _selectedDate;
  int _adults = 1;
  int _children = 0;
  int _selectedCategory = 0;

  String? get selectedLocation => _selectedLocation;
  DateTime? get selectedDate => _selectedDate;
  int get adults => _adults;
  int get children => _children;
  int get selectedCategory => _selectedCategory;

  void setLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setAdults(int count) {
    _adults = count;
    notifyListeners();
  }

  void setChildren(int count) {
    _children = count;
    notifyListeners();
  }

  void setCategory(int index) {
    _selectedCategory = index;
    notifyListeners();
  }

  void reset() {
    _selectedLocation = null;
    _selectedDate = null;
    _adults = 1;
    _children = 0;
    _selectedCategory = 0;
    notifyListeners();
  }
}
