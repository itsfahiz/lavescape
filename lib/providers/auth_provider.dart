import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoggedIn = StorageService.isLoggedIn();
    _currentUser = StorageService.getUser();
    notifyListeners();
  }

  //  LOGIN WITH PHONE
  Future<void> login({
    String? phoneNumber,
    String? email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final user = User(
        id: DateTime.now().toString(),
        phoneNumber: phoneNumber ?? '',
        email: email ?? '',
        fullName: '',
        password: password,
      );

      await StorageService.saveUser(user);
      await StorageService.setLoggedIn(true);
      _currentUser = user;
      _isLoggedIn = true;
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //  SIGN UP (WITH FULL DATA)
  Future<void> signUp({
    required String phoneNumber,
    required String email,
    required String fullName,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final user = User(
        id: DateTime.now().toString(),
        phoneNumber: phoneNumber,
        email: email,
        fullName: fullName,
        password: password,
      );

      await StorageService.saveUser(user);
      await StorageService.setLoggedIn(true);
      _currentUser = user;
      _isLoggedIn = true;
    } catch (e) {
      _errorMessage = 'Sign up failed: $e';
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //  LOGOUT WITH SPLASH SCREEN
  Future<void> logout() async {
    await StorageService.logout();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
