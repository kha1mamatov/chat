import 'package:flutter/material.dart';

// Define your custom colors
const Color lightScaffoldColor = Color(0xFFFFFFFF);
const Color lightPrimaryColor = Color(0xFFDDDDDD);
const Color lightTextColor = Color(0xFF333333);
const Color lightShadowColor = Color(0xFFDDDDDD);
const Color lightButtonColor = Color(0xFF0890FF);
const Color hintColor = Color(0xDD000000);

final ThemeData lightTheme = ThemeData(
  // Define scaffold background color
  scaffoldBackgroundColor: lightScaffoldColor,

  // Define primary color
  primaryColor: lightPrimaryColor,

  // Define hint color
  hintColor: hintColor,

  // Define color scheme
  colorScheme: const ColorScheme.light(
    primary: lightPrimaryColor,
    onPrimary: lightTextColor,
    secondary: lightButtonColor,
    onSecondary: lightScaffoldColor,
    surface: lightPrimaryColor,
    onSurface: lightTextColor,
    surfaceTint: lightScaffoldColor,
    error: Colors.red,
    onError: Colors.white,
  ),
  // Define app bar theme
  appBarTheme: const AppBarTheme(
    elevation: 0.5,
    backgroundColor: lightPrimaryColor,
    shadowColor: lightShadowColor,
    iconTheme: IconThemeData(color: lightTextColor),
    titleTextStyle: TextStyle(
        color: lightTextColor, fontSize: 20, fontWeight: FontWeight.bold),
  ),

  // Define icon theme
  iconTheme: const IconThemeData(color: lightTextColor),

  // Define button theme
  buttonTheme: const ButtonThemeData(
    buttonColor: lightButtonColor,
    textTheme: ButtonTextTheme.primary,
  ),

  // Define floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: lightPrimaryColor,
  ),

  // Define list tile theme
  listTileTheme: const ListTileThemeData(
    textColor: lightTextColor,
    iconColor: lightTextColor,
    tileColor: lightScaffoldColor,
    selectedColor: lightButtonColor,
  ),
);
