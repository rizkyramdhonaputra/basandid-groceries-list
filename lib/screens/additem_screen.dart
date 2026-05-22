import 'package:aplikasi_shoppinglist/data/categories.dart';
import 'package:aplikasi_shoppinglist/models/category_model.dart';
import 'package:aplikasi_shoppinglist/models/item_model.dart';
import 'package:aplikasi_shoppinglist/providers/groceriesdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredItemName = '';
  int _enteredItemQuantity = 0;
  Category _selectedCategory = categories[ItemCategories.vegetables]!;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_isLoading) {
      return; // Prevent multiple submissions
    }
    setState(() {
      _isLoading = true;
    });
    try {
      if (!_formKey.currentState!.validate()) {
        setState(() => _isLoading = false);
        return;
      }
      _formKey.currentState!.save();
      final navigator = Navigator.of(context);
      final snackbarProcess = ScaffoldMessenger.of(context);
      await ref
          .read(groceriesProvider.notifier)
          .addItem(
            GroceryInput(
              name: _enteredItemName,
              quantity: _enteredItemQuantity,
              category: _selectedCategory,
            ),
          );
      navigator.pop();
      snackbarProcess.clearSnackBars();
      snackbarProcess.showSnackBar(
        SnackBar(
          content: Text('$_enteredItemName added to the shopping list!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (error) {
      if (mounted) {
        final snackbarProcess = ScaffoldMessenger.of(context);
        snackbarProcess.clearSnackBars();
        snackbarProcess.showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add $_enteredItemName. Please try again later.',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _enteredItemName = '';
      _enteredItemQuantity = 0;
      _selectedCategory = categories[ItemCategories.vegetables]!;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildForm(context));
  }

  AppBar _buildAppBar(final BuildContext context) {
    return AppBar(
      title: Text(
        'Add Item',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildItemNameField(final BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Item Name'),
      onSaved: (enteredValue) => _enteredItemName = enteredValue!,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      maxLength: 50,
      validator: (final value) =>
          value == null || value.isEmpty || value.length <= 2
          ? 'Please enter an item name (at least 3 characters)'
          : null,
    );
  }

  Widget _buildQuantityField(final BuildContext context) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Quantity'),
        onSaved: (enteredValue) =>
            _enteredItemQuantity = int.parse(enteredValue!),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (final value) =>
            value == null ||
                value.isEmpty ||
                int.tryParse(value) == null ||
                int.parse(value) < 1
            ? 'Please enter a quantity'
            : null,
      ),
    );
  }

  Widget _buildCategoryDropdown(final BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<Category>(
        initialValue: categories[ItemCategories.vegetables],
        decoration: const InputDecoration(labelText: 'Category'),
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        items: [
          for (final inputCategory in categories.entries)
            DropdownMenuItem(
              value: inputCategory.value,
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: inputCategory.value.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    inputCategory.value.title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
        ],
        onChanged: (final value) {
          if (value == null) {
            return;
          }
          setState(() {
            _selectedCategory = value;
          });
        },
      ),
    );
  }

  Widget _buildActionButtons(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _isLoading ? null : _resetForm,
          child: const Text('Reset'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add Item'),
        ),
      ],
    );
  }

  Widget _buildForm(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildItemNameField(context),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildQuantityField(context),
                const SizedBox(width: 16),
                _buildCategoryDropdown(context),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }
}
