import 'category_model.dart';

class Grocery {
  const Grocery({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  final String id;
  final String name;
  final int quantity;
  final Category category;

  Grocery copyWith({
    String? id,
    String? name,
    int? quantity,
    Category? category,
  }) {
    return Grocery(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }
}

class GroceryInput {
  const GroceryInput({
    required this.name,
    required this.quantity,
    required this.category,
  });

  final String name;
  final int quantity;
  final Category category;
}
