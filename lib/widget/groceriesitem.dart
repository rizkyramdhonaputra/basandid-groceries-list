import 'package:aplikasi_shoppinglist/models/item_model.dart';
import '../models/category_model.dart';
import 'package:flutter/material.dart';

class GroceryItemTile extends StatelessWidget {
  const GroceryItemTile({
    super.key,
    required this.item,
    required this.category,
    required this.onDismissed,
  });

  final Grocery item;
  final Category category;
  final void Function(Grocery item) onDismissed;

  @override
  Widget build(final BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      onDismissed: (final direction) => onDismissed(item),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(color: category.color, width: 20, height: 20),
          ),
          Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            item.quantity.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
