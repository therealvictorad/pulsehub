import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorWidgetCustom({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(
            'Oops! Something went wrong.\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
