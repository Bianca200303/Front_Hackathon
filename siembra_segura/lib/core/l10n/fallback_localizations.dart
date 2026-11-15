import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Flutter no trae textos propios (botones de diálogos, lectores de
/// pantalla, etc.) para el quechua. Estos delegados usan los de español
/// para `qu`, que es lo que leen los quechuahablantes bilingües.
abstract final class FallbackLocalizations {
  static const _fallback = Locale('es');
  static const _languages = {'qu'};

  /// Delegados a agregar después de los de `AppLocalizations`.
  static const delegates = <LocalizationsDelegate<Object?>>[
    _MaterialFallback(),
    _CupertinoFallback(),
    _WidgetsFallback(),
  ];
}

class _MaterialFallback extends LocalizationsDelegate<MaterialLocalizations> {
  const _MaterialFallback();

  @override
  bool isSupported(Locale locale) =>
      FallbackLocalizations._languages.contains(locale.languageCode);

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(
        FallbackLocalizations._fallback,
      );

  @override
  bool shouldReload(_MaterialFallback old) => false;
}

class _CupertinoFallback extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CupertinoFallback();

  @override
  bool isSupported(Locale locale) =>
      FallbackLocalizations._languages.contains(locale.languageCode);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(
        FallbackLocalizations._fallback,
      );

  @override
  bool shouldReload(_CupertinoFallback old) => false;
}

class _WidgetsFallback extends LocalizationsDelegate<WidgetsLocalizations> {
  const _WidgetsFallback();

  @override
  bool isSupported(Locale locale) =>
      FallbackLocalizations._languages.contains(locale.languageCode);

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(FallbackLocalizations._fallback);

  @override
  bool shouldReload(_WidgetsFallback old) => false;
}
