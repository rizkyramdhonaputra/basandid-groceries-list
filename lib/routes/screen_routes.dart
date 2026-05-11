import 'package:aplikasi_shoppinglist/screens/additem_screen.dart';
import 'package:aplikasi_shoppinglist/screens/grocerieslist_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String groceriesList = '/groceries-list';
  static const String addItem = '/add-item';

  static Map<String, Widget Function(BuildContext)> getRoutes() => {
    groceriesList: (final context) => const GrocerieslistScreen(),
    addItem: (final context) => const AddItemScreen(),
  };
}
