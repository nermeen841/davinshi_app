import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/constants.dart';
import 'localizations.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = const Locale('en');
  Locale get appLocal => _appLocale;
  fetchLocale() async {
    String lang = prefs.getString('language_code')??'en';
    if (prefs.getString('language_code') == null) {
      _appLocale = const Locale('en');
      setLang(lang);
    }
    else{
      if(lang=='en'){
        _appLocale = const Locale('en');
      }else{
        _appLocale = const Locale('ar');
      }
      setLang(lang);
    }
    notifyListeners();
  }


  Future changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (type == const Locale("en")) {
      _appLocale = const Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
      setLang('en');
    }

    if (type == const Locale("ar")) {
      _appLocale = const Locale("ar");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', 'EG');
      setLang('ar');
    }
    notifyListeners();
  }
}

String translate(context,key,value){
  return AppLocalizations.of(context)!.translate(key, value);
}
String translateString(String a,String b){
  return language=='en'?a:b;
}