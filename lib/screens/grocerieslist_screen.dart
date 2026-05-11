import 'package:aplikasi_shoppinglist/providers/groceriesdata_provider.dart';
import 'package:aplikasi_shoppinglist/routes/screen_routes.dart';
import 'package:aplikasi_shoppinglist/widget/groceriesitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GrocerieslistScreen extends ConsumerWidget {
  const GrocerieslistScreen({super.key});

  void _openAddItemScreen(final BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addItem);
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final listGroceries = ref.watch(groceriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Groceries List',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: listGroceries.isEmpty
          ? const Center(child: Text('No groceries to display'))
          : ListView.builder(
              itemCount: listGroceries.length,
              itemBuilder: (final context, final index) {
                final listItem = listGroceries[index];
                return GroceryItemTile(
                  item: listItem,
                  category: listItem.category,
                  onDismissed: (final item) {
                    ref.read(groceriesProvider.notifier).removeItem(item.id);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddItemScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
