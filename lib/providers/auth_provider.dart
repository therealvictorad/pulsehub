import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Provides the AuthService instance
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Holds the current logged-in user state with AsyncValue
final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, AsyncValue<UserModel?>>(
  (ref) => CurrentUserNotifier(ref),
);

class CurrentUserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;

  CurrentUserNotifier(this.ref) : super(const AsyncValue.data(null)) {
    _loadUserFromPrefs();
  }

  // Load logged-in user on app start
  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      final email = prefs.getString('userEmail') ?? 'unknown@user.com';
      // Mock user object, you can customize this as needed
      state = AsyncValue.data(UserModel(
        id: '1',
        name: 'Victor',
        email: email,
        avatarUrl: '',
      ));
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authServiceProvider).login(email, password);
      state = AsyncValue.data(user);

      // Save login state locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Logout method
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).logout();

      // Clear login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
