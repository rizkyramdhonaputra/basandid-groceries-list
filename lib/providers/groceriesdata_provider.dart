import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../data/dummy_item.dart';

class GroceriesNotifier extends Notifier<List<Grocery>> {
  @override
  List<Grocery> build() {
    return groceryItems;
  }

  void addItem(Grocery item) {
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final groceriesProvider = NotifierProvider<GroceriesNotifier, List<Grocery>>(
  () {
    return GroceriesNotifier();
  },
);
