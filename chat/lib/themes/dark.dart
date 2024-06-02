import 'package:flutter/material.dart';

// Define your custom colors
const Color darkScaffoldColor = Color(0xFF1E1E1F);
const Color darkPrimaryColor = Color(0xFF2E2E2F);
const Color darkTextColor = Color(0xFFECE8E8);
const Color darkShadowColor = Color(0xFFECE8E8);
const Color darkButtonColor = Color(0xFF0890FF);
const Color hintColor = Color(0xDD000000);

final ThemeData darkTheme = ThemeData(
  // Define scaffold background color
  scaffoldBackgroundColor: darkScaffoldColor,

  // Define primary color
  primaryColor: darkPrimaryColor,

  // Define hint color
  hintColor: hintColor,

  // Define color scheme
  colorScheme: const ColorScheme.dark(
    primary: darkPrimaryColor,
    onPrimary: darkTextColor,
    secondary: darkButtonColor,
    onSecondary: darkScaffoldColor,
    surface: darkPrimaryColor,
    onSurface: darkTextColor,
    surfaceTint: darkScaffoldColor,
    error: Colors.red,
    onError: Colors.white,
  ),

  // Define app bar theme
  appBarTheme: const AppBarTheme(
    elevation: 0.5,
    backgroundColor: darkPrimaryColor,
    shadowColor: darkShadowColor,
    iconTheme: IconThemeData(color: darkTextColor),
    titleTextStyle: TextStyle(
        color: darkTextColor, fontSize: 20, fontWeight: FontWeight.bold),
  ),

  // Define icon theme
  iconTheme: const IconThemeData(color: darkTextColor),

  // Define button theme
  buttonTheme: const ButtonThemeData(
    buttonColor: darkButtonColor,
    textTheme: ButtonTextTheme.primary,
  ),

  // Define floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: darkPrimaryColor,
  ),

  // Define list tile theme
  listTileTheme: const ListTileThemeData(
    textColor: darkTextColor,
    iconColor: darkTextColor,
    tileColor: darkPrimaryColor,
    selectedColor: darkButtonColor,
  ),
);
