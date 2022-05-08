import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zain/lang/language.dart';

import '../main.dart';
import 'localization.dart';


class LocalizationConst {
  static const String LAGUAGE_CODE = 'languageCode';

  //languages code
  static const String ENGLISH = 'en';
  static const String ARABIC = 'ar';


  static Future<Locale> setLocale(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(LAGUAGE_CODE, languageCode);
    return _locale(languageCode);
  }

  static Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
    return _locale(languageCode);
  }

  static Locale _locale(String languageCode) {
    switch (languageCode) {
      case ENGLISH:
        return Locale(ENGLISH, 'US');
      case ARABIC:
        return Locale(ARABIC, "EG");
      default:
        return Locale(ENGLISH, 'US');
    }
  }

  static String translate(BuildContext context, String key) {
    return Localization.of(context).getTranslate(key);
  }

  static void changeLanguage(BuildContext context,
      Language language) async {
    String languageCode = language.languageCode;
    Locale _temp = await setLocale(languageCode);
    MyApp.setLocale(context, _temp);
  }

  static int getCurrentLang(BuildContext context){
    Locale currentLoc = Localizations.localeOf(context);
    return Language.languageList().firstWhere((element) =>
    element.languageCode == currentLoc.languageCode).id;
  }
}

