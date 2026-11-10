import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Siembra Segura'**
  String get appTitle;

  /// No description provided for @tabClimate.
  ///
  /// In es, this message translates to:
  /// **'Clima'**
  String get tabClimate;

  /// No description provided for @tabWhatToPlant.
  ///
  /// In es, this message translates to:
  /// **'Qué sembrar'**
  String get tabWhatToPlant;

  /// No description provided for @tabRotation.
  ///
  /// In es, this message translates to:
  /// **'Rotación'**
  String get tabRotation;

  /// No description provided for @tabAlerts.
  ///
  /// In es, this message translates to:
  /// **'Avisos'**
  String get tabAlerts;

  /// No description provided for @tabAlertsUnreadSemantics.
  ///
  /// In es, this message translates to:
  /// **'Avisos, hay avisos nuevos'**
  String get tabAlertsUnreadSemantics;

  /// No description provided for @actionStart.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get actionStart;

  /// No description provided for @actionBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get actionBack;

  /// No description provided for @actionRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get actionRetry;

  /// No description provided for @actionListen.
  ///
  /// In es, this message translates to:
  /// **'Escuchar'**
  String get actionListen;

  /// No description provided for @actionChange.
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get actionChange;

  /// No description provided for @actionCompareOptions.
  ///
  /// In es, this message translates to:
  /// **'Comparar con otras opciones'**
  String get actionCompareOptions;

  /// No description provided for @actionWhenToPlant.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo siembro?'**
  String get actionWhenToPlant;

  /// No description provided for @actionSeeMyRecommendation.
  ///
  /// In es, this message translates to:
  /// **'Ver mi recomendación'**
  String get actionSeeMyRecommendation;

  /// No description provided for @farmTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu parcela'**
  String get farmTitle;

  /// No description provided for @climateTitle.
  ///
  /// In es, this message translates to:
  /// **'Cómo viene tu valle'**
  String get climateTitle;

  /// No description provided for @recommendationTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué me conviene sembrar?'**
  String get recommendationTitle;

  /// No description provided for @plantingScheduleTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo siembro?'**
  String get plantingScheduleTitle;

  /// No description provided for @rotationTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu plan de rotación'**
  String get rotationTitle;

  /// No description provided for @alertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Avisos'**
  String get alertsTitle;

  /// No description provided for @alertMessageTitle.
  ///
  /// In es, this message translates to:
  /// **'Mensaje'**
  String get alertMessageTitle;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando…'**
  String get loading;

  /// No description provided for @emptyDefault.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay información.'**
  String get emptyDefault;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get comingSoon;

  /// No description provided for @placeholderUnderConstruction.
  ///
  /// In es, this message translates to:
  /// **'Pantalla en construcción.'**
  String get placeholderUnderConstruction;

  /// No description provided for @errorNetwork.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión. Revisa tu señal e inténtalo de nuevo.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In es, this message translates to:
  /// **'La respuesta tardó demasiado. Inténtalo de nuevo.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión terminó. Vuelve a ingresar.'**
  String get errorUnauthorized;

  /// No description provided for @errorServer.
  ///
  /// In es, this message translates to:
  /// **'Tuvimos un problema. Inténtalo más tarde.'**
  String get errorServer;

  /// No description provided for @errorNotFound.
  ///
  /// In es, this message translates to:
  /// **'No encontramos esta información.'**
  String get errorNotFound;

  /// No description provided for @errorUnexpected.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Inténtalo de nuevo.'**
  String get errorUnexpected;

  /// No description provided for @errorSpeechUnavailable.
  ///
  /// In es, this message translates to:
  /// **'No se pudo reproducir el audio en este celular.'**
  String get errorSpeechUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
