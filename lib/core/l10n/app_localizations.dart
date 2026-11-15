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

  /// No description provided for @actionDone.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get actionDone;

  /// No description provided for @actionUndo.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get actionUndo;

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

  /// No description provided for @actionListenSemantics.
  ///
  /// In es, this message translates to:
  /// **'Escuchar el contenido de esta pantalla'**
  String get actionListenSemantics;

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

  /// No description provided for @emptyRecommendation.
  ///
  /// In es, this message translates to:
  /// **'Con lo que indicaste no encontramos opciones. Revisa lo que no puedes hacer en Tu parcela.'**
  String get emptyRecommendation;

  /// No description provided for @emptyAlerts.
  ///
  /// In es, this message translates to:
  /// **'No tienes avisos por ahora.'**
  String get emptyAlerts;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get comingSoon;

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

  /// No description provided for @sampleDataDisclaimer.
  ///
  /// In es, this message translates to:
  /// **'Cifras de ejemplo.'**
  String get sampleDataDisclaimer;

  /// No description provided for @guideDisclaimer.
  ///
  /// In es, this message translates to:
  /// **'Esta app es una guía. La decisión final es tuya: conversa estos resultados con tu técnico o la agencia agraria.'**
  String get guideDisclaimer;

  /// No description provided for @whatDoesItMean.
  ///
  /// In es, this message translates to:
  /// **'¿Qué significa?'**
  String get whatDoesItMean;

  /// No description provided for @optionalLabel.
  ///
  /// In es, this message translates to:
  /// **'(opcional)'**
  String get optionalLabel;

  /// No description provided for @rotationNameSequence.
  ///
  /// In es, this message translates to:
  /// **'{first} y después {second}'**
  String rotationNameSequence(String first, String second);

  /// No description provided for @rotationNameRepeated.
  ///
  /// In es, this message translates to:
  /// **'{first} y {second}'**
  String rotationNameRepeated(String first, String second);

  /// No description provided for @listJoin.
  ///
  /// In es, this message translates to:
  /// **'{first} y {second}'**
  String listJoin(String first, String second);

  /// No description provided for @scenarioHeavyRains.
  ///
  /// In es, this message translates to:
  /// **'Lluvias fuertes'**
  String get scenarioHeavyRains;

  /// No description provided for @scenarioNormal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get scenarioNormal;

  /// No description provided for @scenarioDry.
  ///
  /// In es, this message translates to:
  /// **'Seco'**
  String get scenarioDry;

  /// No description provided for @scenarioOptionHeavyRains.
  ///
  /// In es, this message translates to:
  /// **'Con lluvias'**
  String get scenarioOptionHeavyRains;

  /// No description provided for @scenarioPhraseHeavyRains.
  ///
  /// In es, this message translates to:
  /// **'un año con lluvias fuertes'**
  String get scenarioPhraseHeavyRains;

  /// No description provided for @scenarioPhraseNormal.
  ///
  /// In es, this message translates to:
  /// **'un año normal'**
  String get scenarioPhraseNormal;

  /// No description provided for @scenarioPhraseDry.
  ///
  /// In es, this message translates to:
  /// **'un año seco'**
  String get scenarioPhraseDry;

  /// No description provided for @climateRiskLow.
  ///
  /// In es, this message translates to:
  /// **'Bajo'**
  String get climateRiskLow;

  /// No description provided for @climateRiskMedium.
  ///
  /// In es, this message translates to:
  /// **'Medio'**
  String get climateRiskMedium;

  /// No description provided for @climateRiskHigh.
  ///
  /// In es, this message translates to:
  /// **'Alto'**
  String get climateRiskHigh;

  /// No description provided for @soilVeryTired.
  ///
  /// In es, this message translates to:
  /// **'Muy cansada'**
  String get soilVeryTired;

  /// No description provided for @soilTired.
  ///
  /// In es, this message translates to:
  /// **'Cansada'**
  String get soilTired;

  /// No description provided for @soilRegular.
  ///
  /// In es, this message translates to:
  /// **'Regular'**
  String get soilRegular;

  /// No description provided for @soilGood.
  ///
  /// In es, this message translates to:
  /// **'Buena'**
  String get soilGood;

  /// No description provided for @soilWithLabel.
  ///
  /// In es, this message translates to:
  /// **'Tierra: {condition}'**
  String soilWithLabel(String condition);

  /// No description provided for @soilImpactDegrades.
  ///
  /// In es, this message translates to:
  /// **'se cansa más'**
  String get soilImpactDegrades;

  /// No description provided for @soilImpactNeutral.
  ///
  /// In es, this message translates to:
  /// **'queda igual'**
  String get soilImpactNeutral;

  /// No description provided for @soilImpactImproves.
  ///
  /// In es, this message translates to:
  /// **'mejora'**
  String get soilImpactImproves;

  /// No description provided for @soilImpactImprovesALot.
  ///
  /// In es, this message translates to:
  /// **'mejora mucho'**
  String get soilImpactImprovesALot;

  /// No description provided for @farmGreeting.
  ///
  /// In es, this message translates to:
  /// **'Hola, {name}'**
  String farmGreeting(String name);

  /// No description provided for @farmSatelliteCaption.
  ///
  /// In es, this message translates to:
  /// **'Tu chacra en el valle'**
  String get farmSatelliteCaption;

  /// No description provided for @farmMapSemantics.
  ///
  /// In es, this message translates to:
  /// **'Mapa del valle con tu chacra marcada'**
  String get farmMapSemantics;

  /// No description provided for @farmMapQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Dónde está tu chacra?'**
  String get farmMapQuestion;

  /// No description provided for @farmMapHint.
  ///
  /// In es, this message translates to:
  /// **'Toca el mapa para marcarla: los datos de la NASA se piden para ese punto.'**
  String get farmMapHint;

  /// No description provided for @farmMapCoordinates.
  ///
  /// In es, this message translates to:
  /// **'{lat}, {lon}'**
  String farmMapCoordinates(String lat, String lon);

  /// No description provided for @farmMapPinSemantics.
  ///
  /// In es, this message translates to:
  /// **'Tu chacra está en {lat}, {lon}. Toca el mapa para moverla.'**
  String farmMapPinSemantics(String lat, String lon);

  /// No description provided for @farmValley.
  ///
  /// In es, this message translates to:
  /// **'Valle'**
  String get farmValley;

  /// No description provided for @farmIrrigation.
  ///
  /// In es, this message translates to:
  /// **'Riego de'**
  String get farmIrrigation;

  /// No description provided for @farmAreaValue.
  ///
  /// In es, this message translates to:
  /// **'{area} ha'**
  String farmAreaValue(String area);

  /// No description provided for @farmLastCropQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué sembraste la última campaña?'**
  String get farmLastCropQuestion;

  /// No description provided for @farmLastCropHint.
  ///
  /// In es, this message translates to:
  /// **'Por el satélite creemos que fue {crop}. Si no es así, toca el correcto.'**
  String farmLastCropHint(String crop);

  /// No description provided for @farmLastCropGroupSemantics.
  ///
  /// In es, this message translates to:
  /// **'Cultivo de la última campaña'**
  String get farmLastCropGroupSemantics;

  /// No description provided for @farmCampaignTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu campaña'**
  String get farmCampaignTitle;

  /// No description provided for @farmAreaQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántas hectáreas vas a sembrar?'**
  String get farmAreaQuestion;

  /// No description provided for @farmAreaDecrease.
  ///
  /// In es, this message translates to:
  /// **'Quitar media hectárea'**
  String get farmAreaDecrease;

  /// No description provided for @farmAreaIncrease.
  ///
  /// In es, this message translates to:
  /// **'Agregar media hectárea'**
  String get farmAreaIncrease;

  /// No description provided for @farmPlantingDateQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo quieres sembrar?'**
  String get farmPlantingDateQuestion;

  /// No description provided for @farmPlantingDateHint.
  ///
  /// In es, this message translates to:
  /// **'Puedes cambiarla cuando quieras.'**
  String get farmPlantingDateHint;

  /// No description provided for @farmPlantingDatePickerTitle.
  ///
  /// In es, this message translates to:
  /// **'Fecha de siembra'**
  String get farmPlantingDatePickerTitle;

  /// No description provided for @farmCampaignsQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántas campañas seguidas sembraste {crop}?'**
  String farmCampaignsQuestion(String crop);

  /// No description provided for @farmCampaignsValue.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 campaña} other{{count} campañas}}'**
  String farmCampaignsValue(int count);

  /// No description provided for @farmCampaignsDecrease.
  ///
  /// In es, this message translates to:
  /// **'Quitar una campaña'**
  String get farmCampaignsDecrease;

  /// No description provided for @farmCampaignsIncrease.
  ///
  /// In es, this message translates to:
  /// **'Agregar una campaña'**
  String get farmCampaignsIncrease;

  /// No description provided for @farmPriorityQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué te importa más esta campaña?'**
  String get farmPriorityQuestion;

  /// No description provided for @farmPriorityGroupSemantics.
  ///
  /// In es, this message translates to:
  /// **'Prioridad'**
  String get farmPriorityGroupSemantics;

  /// No description provided for @farmPriorityNote.
  ///
  /// In es, this message translates to:
  /// **'Puedes cambiarlo después desde el botón de ajustes de cada pantalla.'**
  String get farmPriorityNote;

  /// No description provided for @farmResetAction.
  ///
  /// In es, this message translates to:
  /// **'Volver a los valores sugeridos'**
  String get farmResetAction;

  /// No description provided for @farmResetDone.
  ///
  /// In es, this message translates to:
  /// **'Listo: usamos de nuevo los valores sugeridos.'**
  String get farmResetDone;

  /// No description provided for @farmSettingsTooltip.
  ///
  /// In es, this message translates to:
  /// **'Mi parcela: cambiar cultivo, prioridad o restricciones'**
  String get farmSettingsTooltip;

  /// No description provided for @farmRestrictionsQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Hay algo que no puedas hacer?'**
  String get farmRestrictionsQuestion;

  /// No description provided for @farmSoilTextureHint.
  ///
  /// In es, this message translates to:
  /// **'Agarra un puñado de tierra de tu chacra y toca la que se parezca. Lo que tú ves manda sobre lo que estima el satélite.'**
  String get farmSoilTextureHint;

  /// No description provided for @farmSoilTextureGroupSemantics.
  ///
  /// In es, this message translates to:
  /// **'Cómo es tu tierra'**
  String get farmSoilTextureGroupSemantics;

  /// No description provided for @farmSoilTextureUnknown.
  ///
  /// In es, this message translates to:
  /// **'No estoy seguro'**
  String get farmSoilTextureUnknown;

  /// No description provided for @farmSoilTextureUnknownHint.
  ///
  /// In es, this message translates to:
  /// **'Usamos la tierra que estima el satélite para tu punto.'**
  String get farmSoilTextureUnknownHint;

  /// No description provided for @farmNarration.
  ///
  /// In es, this message translates to:
  /// **'Hola {name}. Por el satélite creemos que la última campaña sembraste {crop}. Si no es así, toca el cultivo correcto. Luego dinos cuántas hectáreas vas a sembrar, cuándo quieres sembrar y qué te importa más esta campaña.'**
  String farmNarration(String name, String crop);

  /// No description provided for @weatherSunny.
  ///
  /// In es, this message translates to:
  /// **'Sol'**
  String get weatherSunny;

  /// No description provided for @weatherCloudy.
  ///
  /// In es, this message translates to:
  /// **'Nubes'**
  String get weatherCloudy;

  /// No description provided for @weatherRain.
  ///
  /// In es, this message translates to:
  /// **'Lluvia'**
  String get weatherRain;

  /// No description provided for @weatherModerateRain.
  ///
  /// In es, this message translates to:
  /// **'Lluvia moderada'**
  String get weatherModerateRain;

  /// No description provided for @weatherHeavyRain.
  ///
  /// In es, this message translates to:
  /// **'Lluvia fuerte'**
  String get weatherHeavyRain;

  /// No description provided for @weatherHeavyRainShort.
  ///
  /// In es, this message translates to:
  /// **'Fuerte'**
  String get weatherHeavyRainShort;

  /// No description provided for @climateToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy, {weekday}'**
  String climateToday(String weekday);

  /// No description provided for @climateTodayDetails.
  ///
  /// In es, this message translates to:
  /// **'{probability} de probabilidad · {rain} · {temperature}'**
  String climateTodayDetails(
    String probability,
    String rain,
    String temperature,
  );

  /// No description provided for @climateThisWeek.
  ///
  /// In es, this message translates to:
  /// **'Esta semana'**
  String get climateThisWeek;

  /// No description provided for @climateHeavyRainDay.
  ///
  /// In es, this message translates to:
  /// **'El {weekday} se espera lluvia fuerte.'**
  String climateHeavyRainDay(String weekday);

  /// No description provided for @climateAdviceLead.
  ///
  /// In es, this message translates to:
  /// **'Qué hacer:'**
  String get climateAdviceLead;

  /// No description provided for @climatePlanTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué te conviene sembrar?'**
  String get climatePlanTitle;

  /// No description provided for @climatePlanAction.
  ///
  /// In es, this message translates to:
  /// **'Toca para ver tu recomendación y cuándo sembrar.'**
  String get climatePlanAction;

  /// No description provided for @climateComparisonTitle.
  ///
  /// In es, this message translates to:
  /// **'Comparado con un año normal'**
  String get climateComparisonTitle;

  /// No description provided for @climateComparisonNote.
  ///
  /// In es, this message translates to:
  /// **'La raya negra marca lo normal para este mes. Datos de satélite NASA (lluvia y humedad del suelo) y pronóstico del día.'**
  String get climateComparisonNote;

  /// No description provided for @anomalyRainfall.
  ///
  /// In es, this message translates to:
  /// **'Lluvia del mes'**
  String get anomalyRainfall;

  /// No description provided for @anomalyTemperature.
  ///
  /// In es, this message translates to:
  /// **'Calor'**
  String get anomalyTemperature;

  /// No description provided for @anomalySoilMoisture.
  ///
  /// In es, this message translates to:
  /// **'Humedad de tu suelo'**
  String get anomalySoilMoisture;

  /// No description provided for @anomalyTimesMore.
  ///
  /// In es, this message translates to:
  /// **'{count} veces más'**
  String anomalyTimesMore(String count);

  /// No description provided for @anomalyTimesLess.
  ///
  /// In es, this message translates to:
  /// **'{count} veces menos'**
  String anomalyTimesLess(String count);

  /// No description provided for @anomalyDegreesMore.
  ///
  /// In es, this message translates to:
  /// **'{degrees} °C más'**
  String anomalyDegreesMore(String degrees);

  /// No description provided for @anomalyDegreesLess.
  ///
  /// In es, this message translates to:
  /// **'{degrees} °C menos'**
  String anomalyDegreesLess(String degrees);

  /// No description provided for @anomalyAsNormal.
  ///
  /// In es, this message translates to:
  /// **'Como lo normal'**
  String get anomalyAsNormal;

  /// No description provided for @anomalyBarSemantics.
  ///
  /// In es, this message translates to:
  /// **'{metric}: {status}'**
  String anomalyBarSemantics(String metric, String status);

  /// No description provided for @moistureVeryWet.
  ///
  /// In es, this message translates to:
  /// **'Muy húmedo'**
  String get moistureVeryWet;

  /// No description provided for @moistureWet.
  ///
  /// In es, this message translates to:
  /// **'Húmedo'**
  String get moistureWet;

  /// No description provided for @moistureNormal.
  ///
  /// In es, this message translates to:
  /// **'Normal'**
  String get moistureNormal;

  /// No description provided for @moistureDry.
  ///
  /// In es, this message translates to:
  /// **'Seco'**
  String get moistureDry;

  /// No description provided for @climateExplainerSoilMoistureTerm.
  ///
  /// In es, this message translates to:
  /// **'Humedad del suelo:'**
  String get climateExplainerSoilMoistureTerm;

  /// No description provided for @climateExplainerSoilMoistureBody.
  ///
  /// In es, this message translates to:
  /// **'cuánta agua tiene tu tierra. La mide el satélite SMAP de la NASA.'**
  String get climateExplainerSoilMoistureBody;

  /// No description provided for @climateExplainerNormalTerm.
  ///
  /// In es, this message translates to:
  /// **'Lo normal:'**
  String get climateExplainerNormalTerm;

  /// No description provided for @climateExplainerNormalBody.
  ///
  /// In es, this message translates to:
  /// **'el promedio de los últimos 20 años para este mes en tu valle.'**
  String get climateExplainerNormalBody;

  /// No description provided for @climateExplainerSatelliteTerm.
  ///
  /// In es, this message translates to:
  /// **'Satélite vs tu chacra:'**
  String get climateExplainerSatelliteTerm;

  /// No description provided for @climateExplainerSatelliteBody.
  ///
  /// In es, this message translates to:
  /// **'el satélite mide toda la zona desde el espacio, así que puede diferir un poco de lo que ves en tu campo. Por eso te pedimos confirmar lo que sembraste: tu respuesta corrige al satélite.'**
  String get climateExplainerSatelliteBody;

  /// No description provided for @climateNarration.
  ///
  /// In es, this message translates to:
  /// **'Hoy en tu valle se espera {condition}, con {probability} de probabilidad.'**
  String climateNarration(String condition, String probability);

  /// No description provided for @recommendationThinkingOf.
  ///
  /// In es, this message translates to:
  /// **'Pensando en: {priority}'**
  String recommendationThinkingOf(String priority);

  /// No description provided for @recommendationHeadline.
  ///
  /// In es, this message translates to:
  /// **'TE RECOMENDAMOS'**
  String get recommendationHeadline;

  /// No description provided for @recommendationScenarioNote.
  ///
  /// In es, this message translates to:
  /// **'Calculado con el clima de los años de referencia de cada escenario (NASA POWER).'**
  String get recommendationScenarioNote;

  /// No description provided for @recommendationIfHeavyRains.
  ///
  /// In es, this message translates to:
  /// **'SI EL AÑO VIENE CON LLUVIAS FUERTES, TE CONVIENE'**
  String get recommendationIfHeavyRains;

  /// No description provided for @recommendationIfDry.
  ///
  /// In es, this message translates to:
  /// **'SI EL AÑO VIENE SECO, TE CONVIENE'**
  String get recommendationIfDry;

  /// No description provided for @outcomeWater.
  ///
  /// In es, this message translates to:
  /// **'Agua de riego:'**
  String get outcomeWater;

  /// No description provided for @outcomeClimateRisk.
  ///
  /// In es, this message translates to:
  /// **'Riesgo de clima:'**
  String get outcomeClimateRisk;

  /// No description provided for @outcomeSoil.
  ///
  /// In es, this message translates to:
  /// **'Tu tierra:'**
  String get outcomeSoil;

  /// No description provided for @forArea.
  ///
  /// In es, this message translates to:
  /// **'Para {area} ha.'**
  String forArea(String area);

  /// No description provided for @recommendationRepeatOverline.
  ///
  /// In es, this message translates to:
  /// **'SI SIEMBRAS {crop} OTRA VEZ'**
  String recommendationRepeatOverline(String crop);

  /// No description provided for @recommendationExploreScenarios.
  ///
  /// In es, this message translates to:
  /// **'Explorar otros escenarios'**
  String get recommendationExploreScenarios;

  /// No description provided for @recommendationExploreQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Y si el año viene distinto?'**
  String get recommendationExploreQuestion;

  /// No description provided for @scenarioSelectorSemantics.
  ///
  /// In es, this message translates to:
  /// **'Ver otro escenario'**
  String get scenarioSelectorSemantics;

  /// No description provided for @recommendationNarration.
  ///
  /// In es, this message translates to:
  /// **'Pensando en {priority}, para {scenario} te recomendamos {rotation}. Necesitarías {water} de agua de riego y el riesgo de clima es {risk}. Tu tierra {soil}. {repeatWarning}'**
  String recommendationNarration(
    String priority,
    String scenario,
    String rotation,
    String water,
    String risk,
    String soil,
    String repeatWarning,
  );

  /// No description provided for @scheduleDecideBefore.
  ///
  /// In es, this message translates to:
  /// **'Decide antes del'**
  String get scheduleDecideBefore;

  /// No description provided for @scheduleYourCalendar.
  ///
  /// In es, this message translates to:
  /// **'Tu calendario'**
  String get scheduleYourCalendar;

  /// No description provided for @scheduleCalendarSemantics.
  ///
  /// In es, this message translates to:
  /// **'{crop}: {months} meses'**
  String scheduleCalendarSemantics(String crop, int months);

  /// No description provided for @scheduleRiskLegend.
  ///
  /// In es, this message translates to:
  /// **'{months}: riesgo de lluvia fuerte. Ten la cosecha cerca o protegida.'**
  String scheduleRiskLegend(String months);

  /// No description provided for @scheduleFallowLead.
  ///
  /// In es, this message translates to:
  /// **'De agosto a noviembre tu campo queda sin cultivo.'**
  String get scheduleFallowLead;

  /// No description provided for @scheduleFallowBody.
  ///
  /// In es, this message translates to:
  /// **'Puedes sembrar un cultivo de cobertura (como frejol de palo o crotalaria) para proteger y abonar la tierra.'**
  String get scheduleFallowBody;

  /// No description provided for @scheduleWhyTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué te lo recomendamos?'**
  String get scheduleWhyTitle;

  /// No description provided for @scheduleReasonSoilRestores.
  ///
  /// In es, this message translates to:
  /// **'Tu tierra lleva {count} campañas de {crop}; esta rotación la recupera.'**
  String scheduleReasonSoilRestores(int count, String crop);

  /// No description provided for @scheduleReasonSoilHelps.
  ///
  /// In es, this message translates to:
  /// **'Tu tierra lleva {count} campañas de {crop}; esta rotación la ayuda a recuperar.'**
  String scheduleReasonSoilHelps(int count, String crop);

  /// No description provided for @scheduleReasonWater.
  ///
  /// In es, this message translates to:
  /// **'Gastas menos agua de {source} que con {crop}.'**
  String scheduleReasonWater(String source, String crop);

  /// No description provided for @scheduleNarration.
  ///
  /// In es, this message translates to:
  /// **'{rotation}. Decide antes del {date}. {instructions}'**
  String scheduleNarration(String rotation, String date, String instructions);

  /// No description provided for @feedbackQuestion.
  ///
  /// In es, this message translates to:
  /// **'Cuando siembres, cuéntanos qué fue'**
  String get feedbackQuestion;

  /// No description provided for @feedbackFollowed.
  ///
  /// In es, this message translates to:
  /// **'Sembré {crop}'**
  String feedbackFollowed(String crop);

  /// No description provided for @feedbackOther.
  ///
  /// In es, this message translates to:
  /// **'Sembré otra cosa'**
  String get feedbackOther;

  /// No description provided for @feedbackThanksTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Gracias!'**
  String get feedbackThanksTitle;

  /// No description provided for @feedbackThanksBody.
  ///
  /// In es, this message translates to:
  /// **'Con tu respuesta las recomendaciones del valle mejoran para todos.'**
  String get feedbackThanksBody;

  /// No description provided for @rotationSoilToday.
  ///
  /// In es, this message translates to:
  /// **'TU TIERRA HOY'**
  String get rotationSoilToday;

  /// No description provided for @rotationSoilGaugeSemantics.
  ///
  /// In es, this message translates to:
  /// **'Estado de tu tierra: {condition}'**
  String rotationSoilGaugeSemantics(String condition);

  /// No description provided for @rotationExplainerGreennessTerm.
  ///
  /// In es, this message translates to:
  /// **'Verdor:'**
  String get rotationExplainerGreennessTerm;

  /// No description provided for @rotationExplainerGreennessBody.
  ///
  /// In es, this message translates to:
  /// **'el satélite Landsat de la NASA mide qué tan verde y fuerte está tu cultivo (índice NDVI). Si baja año tras año, la tierra se está cansando.'**
  String get rotationExplainerGreennessBody;

  /// No description provided for @rotationExplainerOrganicMatterTerm.
  ///
  /// In es, this message translates to:
  /// **'Materia orgánica:'**
  String get rotationExplainerOrganicMatterTerm;

  /// No description provided for @rotationExplainerOrganicMatterBody.
  ///
  /// In es, this message translates to:
  /// **'restos de plantas que alimentan la tierra. Es un dato estimado (SoilGrids); un análisis de suelo lo confirmaría.'**
  String get rotationExplainerOrganicMatterBody;

  /// No description provided for @rotationCompareTitle.
  ///
  /// In es, this message translates to:
  /// **'Compara {count} opciones'**
  String rotationCompareTitle(int count);

  /// No description provided for @rotationCompareSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Pensando en {priority} y en {scenario}.'**
  String rotationCompareSubtitle(String priority, String scenario);

  /// No description provided for @optionCurrent.
  ///
  /// In es, this message translates to:
  /// **'LO QUE SIEMBRAS HOY'**
  String get optionCurrent;

  /// No description provided for @optionCustom.
  ///
  /// In es, this message translates to:
  /// **'LA TUYA'**
  String get optionCustom;

  /// No description provided for @optionRecommended.
  ///
  /// In es, this message translates to:
  /// **'RECOMENDADA'**
  String get optionRecommended;

  /// No description provided for @optionOther.
  ///
  /// In es, this message translates to:
  /// **'OTRA OPCIÓN'**
  String get optionOther;

  /// No description provided for @metricClimateRisk.
  ///
  /// In es, this message translates to:
  /// **'Riesgo de clima'**
  String get metricClimateRisk;

  /// No description provided for @metricWater.
  ///
  /// In es, this message translates to:
  /// **'Agua de riego'**
  String get metricWater;

  /// No description provided for @metricSoilInTwoYears.
  ///
  /// In es, this message translates to:
  /// **'Tierra en 2 años'**
  String get metricSoilInTwoYears;

  /// No description provided for @factsheetToggle.
  ///
  /// In es, this message translates to:
  /// **'Ver por qué, evidencia y riesgos'**
  String get factsheetToggle;

  /// No description provided for @factsheetWhy.
  ///
  /// In es, this message translates to:
  /// **'POR QUÉ SE SUGIERE'**
  String get factsheetWhy;

  /// No description provided for @factsheetEvidence.
  ///
  /// In es, this message translates to:
  /// **'QUÉ DATOS LO RESPALDAN'**
  String get factsheetEvidence;

  /// No description provided for @factsheetBenefits.
  ///
  /// In es, this message translates to:
  /// **'BENEFICIOS'**
  String get factsheetBenefits;

  /// No description provided for @factsheetUnknowns.
  ///
  /// In es, this message translates to:
  /// **'LO QUE NO SABEMOS'**
  String get factsheetUnknowns;

  /// No description provided for @factsheetRisks.
  ///
  /// In es, this message translates to:
  /// **'REVÍSALO CON TU TÉCNICO'**
  String get factsheetRisks;

  /// No description provided for @cropWaterNeedLow.
  ///
  /// In es, this message translates to:
  /// **'Poca agua'**
  String get cropWaterNeedLow;

  /// No description provided for @cropWaterNeedMedium.
  ///
  /// In es, this message translates to:
  /// **'Agua media'**
  String get cropWaterNeedMedium;

  /// No description provided for @cropWaterNeedHigh.
  ///
  /// In es, this message translates to:
  /// **'Mucha agua'**
  String get cropWaterNeedHigh;

  /// No description provided for @cropCycleMonths.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 mes} other{{count} meses}}'**
  String cropCycleMonths(int count);

  /// No description provided for @cropFixesNitrogen.
  ///
  /// In es, this message translates to:
  /// **'Abona tu tierra'**
  String get cropFixesNitrogen;

  /// No description provided for @rotationCustomTitle.
  ///
  /// In es, this message translates to:
  /// **'Arma tu rotación'**
  String get rotationCustomTitle;

  /// No description provided for @rotationCustomHint.
  ///
  /// In es, this message translates to:
  /// **'Toca un cultivo para cambiarlo y mira cómo cambian el agua y tu tierra.'**
  String get rotationCustomHint;

  /// No description provided for @rotationCustomPickTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué cultivo va aquí?'**
  String get rotationCustomPickTitle;

  /// No description provided for @rotationCustomAdd.
  ///
  /// In es, this message translates to:
  /// **'Agregar cultivo'**
  String get rotationCustomAdd;

  /// No description provided for @rotationCustomRemove.
  ///
  /// In es, this message translates to:
  /// **'Quitar de la secuencia'**
  String get rotationCustomRemove;

  /// No description provided for @rotationCustomClear.
  ///
  /// In es, this message translates to:
  /// **'Volver a las rotaciones sugeridas'**
  String get rotationCustomClear;

  /// No description provided for @rotationCustomExcluded.
  ///
  /// In es, this message translates to:
  /// **'Con lo que indicaste en Tu parcela, esta secuencia queda descartada.'**
  String get rotationCustomExcluded;

  /// No description provided for @rotationCustomPositionSemantics.
  ///
  /// In es, this message translates to:
  /// **'Cultivo {position} de {total}'**
  String rotationCustomPositionSemantics(int position, int total);

  /// No description provided for @rotationPlanTitle.
  ///
  /// In es, this message translates to:
  /// **'Plan recomendado: próximas campañas'**
  String get rotationPlanTitle;

  /// No description provided for @rotationPlanName.
  ///
  /// In es, this message translates to:
  /// **'{rotation} y después {next}.'**
  String rotationPlanName(String rotation, String next);

  /// No description provided for @rotationNarration.
  ///
  /// In es, this message translates to:
  /// **'Tu tierra hoy está {soil}, porque lleva {count} campañas seguidas de {crop}. Comparamos {options} opciones. Si sigues con {current}, en dos años tu tierra quedará {currentSoil}. La opción recomendada es {rotation}. Toca cada opción para ver por qué la sugerimos, qué datos la respaldan y qué debes revisar con tu técnico. Recuerda: esta app es una guía, la decisión es tuya.'**
  String rotationNarration(
    String soil,
    int count,
    String crop,
    int options,
    String current,
    String currentSoil,
    String rotation,
  );

  /// No description provided for @alertsFooter.
  ///
  /// In es, this message translates to:
  /// **'Los avisos también llegan como mensaje al celular.'**
  String get alertsFooter;

  /// No description provided for @alertsCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{No tienes avisos.} =1{Tienes un aviso.} other{Tienes {count} avisos.}}'**
  String alertsCount(int count);

  /// No description provided for @alertTimeToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy, {time}'**
  String alertTimeToday(String time);

  /// No description provided for @alertTimeYesterday.
  ///
  /// In es, this message translates to:
  /// **'Ayer'**
  String get alertTimeYesterday;

  /// No description provided for @alertMeta.
  ///
  /// In es, this message translates to:
  /// **'{time} · {source}'**
  String alertMeta(String time, String source);

  /// No description provided for @messageChannel.
  ///
  /// In es, this message translates to:
  /// **'Mensaje por celular'**
  String get messageChannel;

  /// No description provided for @messageSentAt.
  ///
  /// In es, this message translates to:
  /// **'{day}, {time}'**
  String messageSentAt(String day, String time);

  /// No description provided for @messagePlayAudio.
  ///
  /// In es, this message translates to:
  /// **'Reproducir audio'**
  String get messagePlayAudio;

  /// No description provided for @messageInputLabel.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu pregunta'**
  String get messageInputLabel;

  /// No description provided for @messageInputHint.
  ///
  /// In es, this message translates to:
  /// **'Pregunta lo que quieras…'**
  String get messageInputHint;

  /// No description provided for @messageSendAudio.
  ///
  /// In es, this message translates to:
  /// **'Mandar audio'**
  String get messageSendAudio;

  /// No description provided for @messageChatComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Podrás hacer preguntas próximamente.'**
  String get messageChatComingSoon;
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
