import 'package:flutter/material.dart';

extension LocaleExtension on Locale {
  bool isCompatible(Locale target, {bool script = false, bool country = false}) {
    if (target == this) {
      return true;
    }
    if (target.languageCode != this.languageCode) {
      return false;
    }
    if (script) {
      return this.scriptCode == target.scriptCode;
    }
    if (country) {
      return this.countryCode == target.countryCode;
    }
    return this.scriptCode == target.scriptCode || this.countryCode == target.countryCode;
  }
}

Locale findCompatibleLocale(List<Locale> supportLocales, Locale target, {Locale orElse()?}) {
  return supportLocales.firstWhere((locale) => locale == target, orElse: () {
    return supportLocales.firstWhere((locale) => locale.isCompatible(target, script: true), orElse: () {
      return supportLocales.firstWhere((locale) => locale.isCompatible(target, country: true), orElse: () {
        return supportLocales.firstWhere((locale) => locale.isCompatible(target), orElse: orElse);
      });
    });
  });
}
