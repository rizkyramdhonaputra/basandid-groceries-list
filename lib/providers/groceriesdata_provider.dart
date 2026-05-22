import 'dart:convert';

import 'package:aplikasi_shoppinglist/data/categories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import 'package:http/http.dart' as http;

class GroceriesNotifier extends AsyncNotifier<List<Grocery>> {
  static const String _baseUrl =
      'learning-flutter-d15c6-default-rtdb.asia-southeast1.firebasedatabase.app';
  static final _url = Uri.https(_baseUrl, 'groceries-list.json');

  @override
  Future<List<Grocery>> build() async {
    return await _fetchGroceriesData();
  }

  Future<List<Grocery>> _fetchGroceriesData() async {
    final response = await http.get(_url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load groceries. Status code: ${response.statusCode}',
      );
    }

    final dynamic decodeBody = json.decode(response.body);

    if (decodeBody == null) {
      return [];
    }

    final Map<String, dynamic> data = decodeBody;
    final List<Grocery> loadedGroceries = [];

    data.forEach((final id, final itemData) {
      loadedGroceries.add(
        Grocery(
          id: id,
          name: itemData['name'],
          quantity: itemData['quantity'],
          category: categories.entries
              .firstWhere(
                (category) => category.value.title == itemData['category'],
              )
              .value,
        ),
      );
    });
    return loadedGroceries; // Return the fetched groceries
  }

  Future<void> addItem(final GroceryInput item) async {
    state = await AsyncValue.guard(() async {
      final response = await http.post(
        _url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': item.name,
          'quantity': item.quantity,
          'category': item.category.title,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final firebaseKey = json.decode(response.body)['name'];
        final newItem = Grocery(
          id: firebaseKey,
          name: item.name,
          quantity: item.quantity,
          category: item.category,
        );
        return [
          ...state.value!,
          newItem,
        ]; // Return the updated list of groceries
      } else {
        throw Exception(
          'Failed to add item. Status code: ${response.statusCode}',
        );
      }
    });
  }

  Future<void> removeItem(final String id) async {
    state = await AsyncValue.guard(() async {
      final response = await http.delete(
        Uri.https(_baseUrl, 'groceries-list/$id.json'),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return state.value!
            .where((final item) => item.id != id)
            .toList(); // Update the state by removing the item with the specified id
      } else {
        throw Exception(
          'Failed to remove item. Status code: ${response.statusCode}',
        );
      }
    });
  }
}

final groceriesProvider =
    AsyncNotifierProvider<GroceriesNotifier, List<Grocery>>(
      GroceriesNotifier.new,
    );
