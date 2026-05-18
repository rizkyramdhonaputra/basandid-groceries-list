import 'package:aplikasi_shoppinglist/providers/groceriesdata_provider.dart';
import 'package:aplikasi_shoppinglist/routes/screen_routes.dart';
import 'package:aplikasi_shoppinglist/widget/groceriesitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GrocerieslistScreen extends ConsumerStatefulWidget {
  const GrocerieslistScreen({super.key});

  @override
  ConsumerState<GrocerieslistScreen> createState() =>
      _GrocerieslistScreenState();
}

class _GrocerieslistScreenState extends ConsumerState<GrocerieslistScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _fetchGroceriesData() async {
    try {
      await ref.read(groceriesProvider.notifier).fetchGroceriesData();
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load groceries. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGroceriesData();
  }

  void _openAddItemScreen() {
    Navigator.pushNamed(context, AppRoutes.addItem);
  }

  @override
  Widget build(final BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            _errorMessage!,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

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
          ? Center(
              child: Text(
                'No groceries to display',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
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
        onPressed: _openAddItemScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
