import 'package:flutter/material.dart';
import '../model/LanguageDataModel.dart';
import 'BaseLanguage.dart';
import 'LanguageAf.dart';
import 'LanguageAr.dart';
import 'LanguageEn.dart';
import 'LanguageFr.dart';
import 'LanguageHi.dart';
import 'LanguagePt.dart';
import 'LanguageVi.dart';
import 'LauguageTr.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'tr':
        return LanguageTr();
      case 'hi':
        return LanguageHi();
      case 'ar':
        return LanguageAr();
      case 'fr':
        return LanguageFr();
      case 'pt':
        return LanguagePt();
      case 'en':
        return LanguageEn();
      case 'af':
        return LanguageAf();
      case 'vi':
        return LanguageVi();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
