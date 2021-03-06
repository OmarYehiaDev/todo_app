import 'package:flutter/material.dart';

final ThemeData kDarkTheme = ThemeData.dark().copyWith(
  accentColor: Colors.white,
  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: Colors.white,
    selectionColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green,
  ),
);
final ThemeData kLightTheme = ThemeData(primarySwatch: Colors.green);
String appName, version, buildNumber;
