import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/item_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../main.dart'; // to access themeProvider

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemListProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

  final authState = ref.watch(currentUserProvider);
    // Mock user profile
    const mockUserName = 'Victor Adesina';
    const mockUserEmail = 'victoradesinna77@gmail.com';
    const mockAvatarUrl = 'https://i.pravatar.cc/150?img=3';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        centerTitle: true,
        actions: [
          // Dark mode toggle switch
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: isDark,
                onChanged: (_) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
              const Icon(Icons.dark_mode),
            ],
          ),


          // Logout button
IconButton(
  icon: authState.isLoading
      ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white, // adjust based on your AppBar theme
          ),
        )
      : const Icon(Icons.logout),
  tooltip: 'Logout',
  onPressed: authState.isLoading
      ? null // disable button while logging out
      : () async {
          await ref.read(currentUserProvider.notifier).logout();
          Navigator.pushReplacementNamed(context, '/login');
        },
),
        ],
      ),
      body: Column(
        children: [
          // === User Profile Summary ===
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? Colors.grey[850] : Colors.blueGrey[50],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: const NetworkImage(mockAvatarUrl),
                  backgroundColor: isDark ? Colors.grey[700] : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mockUserName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mockUserEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[300] : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // === Items List with Animation & Pull-to-Refresh ===
          Expanded(
            child: itemState.when(
              loading: () => const LoadingWidget(message: 'Loading items...'),
              error: (e, _) => ErrorWidgetCustom(
                error: e,
                onRetry: () => ref.read(itemListProvider.notifier).fetchItems(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: isDark ? Colors.white54 : Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'No items available',
                          style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white70 : Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(itemListProvider.notifier).fetchItems();
                  },
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final formattedDate = (() {
                        try {
                          return DateFormat.yMMMMd().format(
                            DateTime.parse(item.date).toLocal(),
                          );
                        } catch (_) {
                          return item.date;
                        }
                      })();

                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 500 + index * 100),
                        tween: Tween(begin: 0, end: 1),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 50 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Card(
                          color: isDark ? Colors.grey[900] : Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(
                              item.title,
                              style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            ),
                            subtitle: Text(
                              '${item.description}\n'
                              'Category: ${item.category}\n'
                              'Date: $formattedDate',
                              style: TextStyle(color: isDark ? Colors.grey[300] : Colors.black87),
                            ),
                            isThreeLine: true,
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 16, color: isDark ? Colors.white70 : Colors.black54),
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: item,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create'),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
