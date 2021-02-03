import 'package:flutter/material.dart';
import 'package:todo_app/utils/sharedPrefsUtils.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale;

  Future<void> fetchLocale() async {
    Locale _locale;
    await SharedPrefsUtils.init();
    final SharedPrefsUtils prefs = SharedPrefsUtils.getInstance();
    if (prefs.getData('language_code') == null) {
      _locale = Locale('en');
    }
    if (prefs.getData('language_code') == "ar") {
      _locale = Locale("ar");
    } else if (prefs.getData('language_code') == "en") {
      _locale = Locale("en");
    }
    _appLocale = _locale;
    notifyListeners();
  }

  void changeLanguage() async {
    await SharedPrefsUtils.init();
    final SharedPrefsUtils prefs = SharedPrefsUtils.getInstance();
    if (appLocal == Locale("ar")) {
      _appLocale = Locale("en");
      await prefs.saveData('language_code', 'en');
      await prefs.saveData('countryCode', 'US');
    } else if (appLocal == Locale("en")) {
      _appLocale = Locale("ar");
      await prefs.saveData('language_code', 'ar');
      await prefs.saveData('countryCode', '');
    } else {
      _appLocale = Locale("en");
      await prefs.saveData('language_code', 'en');
      await prefs.saveData('countryCode', 'US');
    }
    notifyListeners();
  }

  Locale get appLocal => _appLocale == null ? Locale("en") : _appLocale;
}
