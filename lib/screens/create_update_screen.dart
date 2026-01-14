import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../providers/item_provider.dart';
import '../widgets/loading_widget.dart';
import '../main.dart'; // to access themeProvider

class CreateUpdateItemScreen extends ConsumerStatefulWidget {
  final ItemModel? existingItem; // if null → create, else → update
  const CreateUpdateItemScreen({super.key, this.existingItem});

  @override
  ConsumerState<CreateUpdateItemScreen> createState() =>
      _CreateUpdateItemScreenState();
}

class _CreateUpdateItemScreenState
    extends ConsumerState<CreateUpdateItemScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;
  late TextEditingController _dateController;
  late TextEditingController _categoryController;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(text: widget.existingItem?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.existingItem?.description ?? '');
    _statusController =
        TextEditingController(text: widget.existingItem?.status ?? '');
    _dateController =
        TextEditingController(text: widget.existingItem?.date ?? '');
    _categoryController =
        TextEditingController(text: widget.existingItem?.category ?? '');

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final newItem = ItemModel(
      id: widget.existingItem?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
      status: _statusController.text,
      date: _dateController.text,
    );

    final itemNotifier = ref.read(itemListProvider.notifier);

    try {
      if (widget.existingItem != null) {
        await itemNotifier.updateItem(newItem);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item updated successfully!')),
        );
      } else {
        await itemNotifier.addItem(newItem);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item created successfully!')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final isLoading = ref.watch(itemListProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingItem != null ? 'Update Item' : 'Create Item',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isLoading
            ? const Center(child: LoadingWidget(message: 'Saving item...'))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _animatedField(
                        child: TextFormField(
                          controller: _titleController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Enter a title' : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _animatedField(
                        child: TextFormField(
                          controller: _descriptionController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter a description'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _animatedField(
                        child: TextFormField(
                          controller: _statusController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Status',
                            labelStyle: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Enter a status' : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _animatedField(
                        child: TextFormField(
                          controller: _categoryController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Enter a category' : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _animatedField(
                        child: TextFormField(
                          controller: _dateController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Date (optional)',
                            labelStyle: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black54),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _animatedField(
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.blueGrey : Colors.blue,
                          ),
                          child: Text(
                            widget.existingItem != null ? 'Update' : 'Create',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _animatedField({required Widget child}) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, _) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
            child: child,
          ),
        );
      },
    );
  }
}
