import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  /// Login method
  Future<UserModel> login(String email, String password) async {
    // Simulate network/API call
    await Future.delayed(const Duration(seconds: 2));

    // user object (mock)
    final user = UserModel(id: '1', name: 'Victor', email: email, avatarUrl: '');

    // Store login state locally (SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    // Store sensitive data securely
    await secureStorage.write(key: 'userEmail', value: email);

    return user;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  /// Get logged-in user email from secure storage
  Future<String?> getLoggedInUserEmail() async {
    return await secureStorage.read(key: 'userEmail');
  }

  /// Logout method
  Future<void> logout() async {
    // Clear login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Clear secure storage
    await secureStorage.delete(key: 'userEmail');
  }
}
