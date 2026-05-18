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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    ref
        .read(groceriesProvider.notifier)
        .addItem(
          GroceryInput(
            name: _enteredItemName,
            quantity: _enteredItemQuantity,
            category: _selectedCategory,
          ),
        );
    final snackbarProcess = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    snackbarProcess.clearSnackBars();
    snackbarProcess.showSnackBar(
      const SnackBar(
        content: Text('Item added to the shopping list!'),
        duration: Duration(seconds: 2),
      ),
    );
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
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildForm(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
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
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
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
                ),
                const SizedBox(width: 16),
                Expanded(
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
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: _resetForm, child: const Text('Reset')),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
