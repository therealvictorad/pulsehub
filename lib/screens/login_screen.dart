import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulsehub/main.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_widget.dart';
import 'dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    _animController.forward();

    // Listen for auth changes
    ref.listenManual<AsyncValue<UserModel?>>(
      currentUserProvider,
      (prev, next) {
        next.when(
          data: (user) {
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            }
          },
          loading: () {},
          error: (e, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(currentUserProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(currentUserProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;


    return Scaffold(
      appBar: AppBar(title: const Text('PulseHub',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      letterSpacing: 1.2,
    ),
  ),
  centerTitle: true, 
  elevation: 0,
  backgroundColor: Colors.blueAccent,
),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email Box
                Container(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: isDark ? Colors.grey[800] : Colors.blueGrey[50],
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: TextFormField(
    controller: _emailController,
    style: TextStyle(color: isDark ? Colors.white : Colors.black),
    decoration: InputDecoration(
      labelText: 'Email',
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      hintText: 'Enter your email',
      hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
      border: InputBorder.none,
    ),
    keyboardType: TextInputType.emailAddress,
    validator: (v) {
      if (v == null || v.isEmpty) return 'Email cannot be empty';
      if (!v.contains('@')) return 'Enter a valid email';
      return null;
    },
  ),
),

const SizedBox(height: 20),

                // Password Box
                Container(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: isDark ? Colors.grey[800] : Colors.blueGrey[50],
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: TextFormField(
    controller: _passwordController,
    obscureText: true,
    style: TextStyle(color: isDark ? Colors.white : Colors.black),
    decoration: InputDecoration(
      labelText: 'Password',
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      hintText: 'Enter your password',
      hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
      border: InputBorder.none,
    ),
    validator: (v) {
      if (v == null || v.isEmpty) return 'Password cannot be empty';
      if (v.length < 6) return 'Password must be at least 6 characters';
      return null;
    },
  ),
),

const SizedBox(height: 18),

                // Login Button / Loading Widget
                authState.isLoading
                    ? const LoadingWidget(message: 'Authenticating...')
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
