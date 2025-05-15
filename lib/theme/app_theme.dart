import 'package:flutter/material.dart';

ThemeData getLightTheme() {
  return ThemeData(
    colorSchemeSeed: Colors.blue,
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      elevation: 10,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      labelStyle: TextStyle(color: Colors.grey[600]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    ),
    cardTheme: const CardTheme(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    colorSchemeSeed: Colors.blue,
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850],
      selectedItemColor: Colors.blue[300],
      unselectedItemColor: Colors.grey[400],
      elevation: 10,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.grey[850],
    ),
  );
}
