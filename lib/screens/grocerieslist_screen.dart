import 'package:aplikasi_shoppinglist/models/item_model.dart';
import 'package:aplikasi_shoppinglist/providers/groceriesdata_provider.dart';
import 'package:aplikasi_shoppinglist/routes/screen_routes.dart';
import 'package:aplikasi_shoppinglist/widget/groceriesitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GrocerieslistScreen extends ConsumerWidget {
  const GrocerieslistScreen({super.key});

  void _openAddItemScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addItem);
  }

  AppBar _buildAppBar(BuildContext context, WidgetRef ref, bool isLoading) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Groceries List',
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      actions: [
        if (!isLoading)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(groceriesProvider),
          ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Failed to load groceries.',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(groceriesProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'No groceries to display',
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<Grocery> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GroceryItemTile(
          item: item,
          category: item.category,
          onDismissed: (_) {
            ref.read(groceriesProvider.notifier).removeItem(item.id);
          },
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final groceriesAsync = ref.watch(groceriesProvider);

    return Scaffold(
      appBar: _buildAppBar(context, ref, groceriesAsync.isLoading),
      body: groceriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildErrorState(context, ref),
        data: (items) => items.isEmpty
            ? _buildEmptyState(context)
            : _buildList(context, ref, items),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddItemScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
