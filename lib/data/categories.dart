import 'package:flutter/material.dart';
import '../models/category_model.dart';

const categories = {
  ItemCategories.vegetables: Category(
    'Vegetables',
    Color.fromARGB(255, 0, 255, 128),
  ),
  ItemCategories.fruit: Category('Fruit', Color.fromARGB(255, 145, 255, 0)),
  ItemCategories.meat: Category('Meat', Color.fromARGB(255, 255, 102, 0)),
  ItemCategories.dairy: Category('Dairy', Color.fromARGB(255, 0, 208, 255)),
  ItemCategories.carbs: Category('Carbs', Color.fromARGB(255, 0, 60, 255)),
  ItemCategories.sweets: Category('Sweets', Color.fromARGB(255, 255, 149, 0)),
  ItemCategories.spices: Category('Spices', Color.fromARGB(255, 255, 187, 0)),
  ItemCategories.convenience: Category(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
  ),
  ItemCategories.hygiene: Category('Hygiene', Color.fromARGB(255, 149, 0, 255)),
  ItemCategories.other: Category('Other', Color.fromARGB(255, 0, 225, 255)),
};
