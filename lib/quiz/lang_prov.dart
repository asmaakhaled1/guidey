import 'package:flutter/material.dart';
import 'package:guidey/quiz/lang_e.dart';
import 'package:guidey/quiz//lang_a.dart';



class LanguageProvider extends ChangeNotifier {
  String currentLangCode = 'en';
  Map<String, String> currentLang = en;

  Map<String, String> get enLang => en;
  Map<String, String> get arLang => ar;

  void setLanguage(String code) {
    currentLangCode = code;
    if (code == 'en') {
      currentLang = en;
    } else if (code == 'ar') {
      currentLang = ar;
    }
    notifyListeners();
  }
}