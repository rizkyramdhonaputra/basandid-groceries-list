import 'package:aplikasi_shoppinglist/routes/screen_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 147, 229, 250),
    brightness: Brightness.dark,
    surface: const Color.fromARGB(255, 42, 51, 59),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
  textTheme: GoogleFonts.googleSansTextTheme(),
);

void main() {
  runApp(const ProviderScope(child: ShoppingList()));
}

class ShoppingList extends StatelessWidget {
  const ShoppingList({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: theme,
      initialRoute: AppRoutes.groceriesList,
      routes: AppRoutes.getRoutes(),
    );
  }
}
