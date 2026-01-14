import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/details_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_update_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: PulseHubApp()));
}

// ThemeProvider using Riverpod
final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setBool('isDarkMode', true);
    } else {
      state = ThemeMode.light;
      await prefs.setBool('isDarkMode', false);
    }
  }
}

class PulseHubApp extends ConsumerWidget {
  const PulseHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'PulseHub',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: themeMode, 
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      routes: {
        '/details': (_) => const DetailsScreen(),
        '/create': (_) => const CreateUpdateItemScreen(),
        '/login': (_) => const LoginScreen(),
      },
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const LoginScreen(),
      data: (user) {
        if (user != null) {
          return const DashboardScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
