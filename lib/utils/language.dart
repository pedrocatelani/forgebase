import 'package:flutter/material.dart';

const String defaultLanguageCode = 'pt-BR';
const List<String> supportedLanguageCodes = ['pt-BR', 'en', 'es'];

const Map<String, String> _languageNormalizationMap = {
  'pt-BR': 'pt-BR', 'pt_BR': 'pt-BR', 'pt': 'pt-BR',
  'en': 'en',       'en_': 'en',       'en-US': 'en',
  'es': 'es',       'es_': 'es',       'es-ES': 'es',
};

const Map<String, Locale> _localeMap = {
  'pt-BR': Locale('pt', 'BR'),
  'en': Locale('en'),
  'es': Locale('es'),
};

String normalizeLanguageCode(String? code) {
  return _languageNormalizationMap[code] ?? defaultLanguageCode;
}

String languageCodeFromLocale(Locale locale) {
  final fullCode = locale.countryCode != null 
      ? '${locale.languageCode}-${locale.countryCode}' 
      : locale.languageCode;
      
  return normalizeLanguageCode(fullCode);
}

Locale localeFromLanguageCode(String code) {
  final normalized = normalizeLanguageCode(code);
  return _localeMap[normalized] ?? _localeMap[defaultLanguageCode]!;
}