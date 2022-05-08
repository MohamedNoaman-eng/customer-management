import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Localization {
  final Locale locale;

  Localization(this.locale);

  /*
  static Future<DemoLocalization> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String locale = Intl.canonicalizedLocale(name);
    return initializeMessages(locale).then((_) {
      return DemoLocalization(locale);
    });
  }
*/
  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  Map<String,String> _localizedValues;

  Future<bool> load() async {
    // Load JSON file from the "language" folder
    String jsonString =
    await rootBundle.loadString('assets/${locale.languageCode}.json');
    Map<String, dynamic> jsonLanguageMap = json.decode(jsonString);

    _localizedValues = jsonLanguageMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // called from every widget which needs a localized text
  String getTranslate(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<Localization> delegate = LocalizationDelegate();
}

class LocalizationDelegate extends LocalizationsDelegate<Localization>{
  const LocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en','ar'].contains(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) async{
    Localization localization = new Localization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;

}
