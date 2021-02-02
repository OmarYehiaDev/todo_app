import 'package:flutter/material.dart';

final ThemeData kDarkTheme = ThemeData.dark().copyWith(
  accentColor: Colors.white,
  textSelectionHandleColor: Colors.white,
  textSelectionColor: Colors.white,
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
