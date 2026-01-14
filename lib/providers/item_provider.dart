import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../services/api_service.dart';

// Provides API service instance
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Manages dashboard items state with AsyncValue
final itemListProvider =
    StateNotifierProvider<ItemListNotifier, AsyncValue<List<ItemModel>>>(
  (ref) => ItemListNotifier(ref),
);

class ItemListNotifier extends StateNotifier<AsyncValue<List<ItemModel>>> {
  final Ref ref;

  ItemListNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchItems(); // fetch items immediately
  }

  // Fetch items from API
  Future<void> fetchItems() async {
    state = const AsyncValue.loading();
    try {
      final items = await ref.read(apiServiceProvider).fetchItems();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Add a new item immutably
  Future<void> addItem(ItemModel item) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data([...currentItems, item]);
  }

  // Update an existing item immutably
  Future<void> updateItem(ItemModel updatedItem) async {
    final currentItems = state.value ?? [];
    final index = currentItems.indexWhere((i) => i.id == updatedItem.id);
    if (index != -1) {
      final updatedItems = [...currentItems];
      updatedItems[index] = updatedItem;
      state = AsyncValue.data(updatedItems);
    }
  }

  // Optional: Remove item
  Future<void> removeItem(String id) async {
    final currentItems = state.value ?? [];
    state = AsyncValue.data(currentItems.where((i) => i.id != id).toList());
  }
}
