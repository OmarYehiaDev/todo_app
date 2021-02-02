import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/utils/sharedPrefsUtils.dart';
import 'package:todo_app/utils/theme/themeProvider.dart';

class ThemeSwitch extends StatefulWidget {
  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _darkTheme = false;

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(kDarkTheme)
        : themeNotifier.setTheme(kLightTheme);
    final _sharedPrefsUtils = SharedPrefsUtils.getInstance();
    // ignore: unused_local_variable
    var isSuccess = await _sharedPrefsUtils.saveData<bool>(
        SharedPreferencesKeys.isDarkTheme, value);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == kDarkTheme);
    return Switch(
      activeColor: Theme.of(context).cursorColor,
      onChanged: (value) {
        setState(() {
          _darkTheme = value;
        });
        onThemeChanged(value, themeNotifier);
      },
      value: _darkTheme,
    );
  }
}
