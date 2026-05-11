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
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  Category selectedCategoryController = categories[Categories.vegetables]!;

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ref
        .read(groceriesProvider.notifier)
        .addItem(
          Grocery(
            id: DateTime.now().toString(),
            name: _itemNameController.text,
            quantity: int.tryParse(_quantityController.text)!,
            category: selectedCategoryController,
          ),
        );
    Navigator.pop(context);
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
      child: Column(
        children: [
          TextFormField(
            controller: _itemNameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
            maxLength: 50,
            validator: (final value) => value == null || value.isEmpty
                ? 'Please enter an item name'
                : null,
          ),
          TextFormField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (final value) => value == null || value.isEmpty
                ? 'Please enter a quantity'
                : null,
          ),
          DropdownButtonFormField<Categories>(
            initialValue: Categories.vegetables,
            items: [
              for (Categories category in Categories.values)
                DropdownMenuItem(value: category, child: Text(category.name)),
            ],
            onChanged: (final value) {
              value != null
                  ? setState(() {
                      selectedCategoryController = categories[value]!;
                    })
                  : null;
            },
          ),
          ElevatedButton(onPressed: _submitForm, child: const Text('Add Item')),
        ],
      ),
    );
  }
}
