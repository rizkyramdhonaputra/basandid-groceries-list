import 'package:aplikasi_shoppinglist/models/item_model.dart';
import '../models/category_model.dart';
import 'package:flutter/material.dart';

class GroceryItemTile extends StatelessWidget {
  const GroceryItemTile({super.key, required this.item, required this.category});

  final Grocery item;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Container(
            color: category.color,
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 10),
          ),
          const SizedBox(width: 10),
          Text(item.name),
          const Spacer(),
          Text(item.quantity.toString()),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}