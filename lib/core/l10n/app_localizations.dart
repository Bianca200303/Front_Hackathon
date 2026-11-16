import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_qu.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('qu'),
  ];

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
  /// **'Datos de tu chacra'**
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

  /// No description provided for @farmMapQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Dónde está tu chacra?'**
  String get farmMapQuestion;

  /// No description provided for @farmMapHint.
  ///
  /// In es, this message translates to:
  /// **'Toca el mapa para marcar dónde está tu chacra.'**
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
  /// **'Tenemos anotado {crop}. Si no es así, toca el correcto.'**
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

  /// No description provided for @farmRestrictionsQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Hay algo que no puedas hacer?'**
  String get farmRestrictionsQuestion;

  /// No description provided for @farmSoilTextureHint.
  ///
  /// In es, this message translates to:
  /// **'Agarra un puñado de tierra de tu chacra y toca la que se parezca. Lo que tú ves manda sobre lo que estiman los mapas de suelo.'**
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
  /// **'Usamos la tierra que estiman los mapas de suelo para tu punto.'**
  String get farmSoilTextureUnknownHint;

  /// No description provided for @farmNarration.
  ///
  /// In es, this message translates to:
  /// **'Hola {name}. Tenemos anotado que la última campaña sembraste {crop}. Si no es así, toca el cultivo correcto. Luego dinos cuántas hectáreas vas a sembrar, cuándo quieres sembrar y qué te importa más esta campaña.'**
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
  /// **'La raya negra marca lo normal para este mes. Datos de clima de la NASA (NASA POWER) y pronóstico del día.'**
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
  /// **'cuánta agua tiene tu tierra. La estimamos con datos de clima de la NASA (NASA POWER).'**
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
  /// **'Datos de la NASA vs tu chacra:'**
  String get climateExplainerSatelliteTerm;

  /// No description provided for @climateExplainerSatelliteBody.
  ///
  /// In es, this message translates to:
  /// **'los datos de la NASA cubren toda la zona, así que pueden diferir un poco de lo que ves en tu campo.'**
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
  /// **'los satélites de la NASA miden qué tan verde y fuerte crece lo sembrado. Si baja año tras año, la tierra se está cansando.'**
  String get rotationExplainerGreennessBody;

  /// No description provided for @rotationExplainerOrganicMatterTerm.
  ///
  /// In es, this message translates to:
  /// **'Materia orgánica:'**
  String get rotationExplainerOrganicMatterTerm;

  /// No description provided for @rotationExplainerOrganicMatterBody.
  ///
  /// In es, this message translates to:
  /// **'restos de plantas que alimentan la tierra. Es un dato estimado con mapas de suelo; un análisis de suelo lo confirmaría.'**
  String get rotationExplainerOrganicMatterBody;

  /// No description provided for @rotationCompareTitle.
  ///
  /// In es, this message translates to:
  /// **'Compara {count} opciones'**
  String rotationCompareTitle(int count);

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

  /// No description provided for @semiAvatarSemantics.
  ///
  /// In es, this message translates to:
  /// **'Semi, tu asistente de campo'**
  String get semiAvatarSemantics;

  /// No description provided for @appModeSwitchSemantics.
  ///
  /// In es, this message translates to:
  /// **'Modo de uso'**
  String get appModeSwitchSemantics;

  /// No description provided for @appModeAssistedTitle.
  ///
  /// In es, this message translates to:
  /// **'Asistencia'**
  String get appModeAssistedTitle;

  /// No description provided for @appModeManualTitle.
  ///
  /// In es, this message translates to:
  /// **'Llenado manual'**
  String get appModeManualTitle;

  /// No description provided for @semiFarmGuide.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Soy Semi. Cuéntame qué sembraste la última campaña y qué te importa más. Con eso te ayudo a decidir.'**
  String get semiFarmGuide;

  /// No description provided for @semiClimateGuide.
  ///
  /// In es, this message translates to:
  /// **'Te cuento cómo viene el clima para tu chacra: el pronóstico de la semana y cómo va este mes comparado con lo normal.'**
  String get semiClimateGuide;

  /// No description provided for @semiRecommendationGuide.
  ///
  /// In es, this message translates to:
  /// **'Con tu tierra y el clima, esto es lo que más te conviene sembrar. Toca cada opción para ver por qué.'**
  String get semiRecommendationGuide;

  /// No description provided for @semiPlantingScheduleGuide.
  ///
  /// In es, this message translates to:
  /// **'Sembrar en el momento justo hace la diferencia. Aquí ves cuándo te conviene.'**
  String get semiPlantingScheduleGuide;

  /// No description provided for @semiRotationGuide.
  ///
  /// In es, this message translates to:
  /// **'Cambiar de cultivo cada campaña deja descansar la tierra. Mira cómo quedaría tu suelo con cada opción.'**
  String get semiRotationGuide;

  /// No description provided for @semiAlertsGuide.
  ///
  /// In es, this message translates to:
  /// **'Aquí te aviso si viene lluvia fuerte, calor o plagas. ¡Revísalos seguido!'**
  String get semiAlertsGuide;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In es, this message translates to:
  /// **'Ajustes: modo, idioma y tu parcela'**
  String get settingsTooltip;

  /// No description provided for @settingsModeTitle.
  ///
  /// In es, this message translates to:
  /// **'Cómo quieres usar la app'**
  String get settingsModeTitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsEditFarm.
  ///
  /// In es, this message translates to:
  /// **'Cambiar los datos de mi parcela'**
  String get settingsEditFarm;

  /// Opción que sigue el idioma del celular; language es el idioma que resultó.
  ///
  /// In es, this message translates to:
  /// **'Automático: {language}'**
  String languageAutomatic(String language);

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageQuechua.
  ///
  /// In es, this message translates to:
  /// **'Runasimi (quechua)'**
  String get languageQuechua;

  /// No description provided for @languageQuechuaDraftNote.
  ///
  /// In es, this message translates to:
  /// **'El quechua está en revisión: lo que falta traducir se muestra en español.'**
  String get languageQuechuaDraftNote;

  /// No description provided for @languageButton.
  ///
  /// In es, this message translates to:
  /// **'Idioma: {language}'**
  String languageButton(String language);

  /// No description provided for @welcomeTitle.
  ///
  /// In es, this message translates to:
  /// **'Hola, soy Semi'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In es, this message translates to:
  /// **'Te ayudo a decidir qué sembrar para cuidar tu tierra y tu agua.'**
  String get welcomeBody;

  /// No description provided for @welcomeAiNote.
  ///
  /// In es, this message translates to:
  /// **'Semi es un personaje creado con IA'**
  String get welcomeAiNote;

  /// No description provided for @welcomeQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo prefieres empezar?'**
  String get welcomeQuestion;

  /// No description provided for @welcomeAssistedTitle.
  ///
  /// In es, this message translates to:
  /// **'Que Semi me pregunte'**
  String get welcomeAssistedTitle;

  /// No description provided for @welcomeAssistedBody.
  ///
  /// In es, this message translates to:
  /// **'Modo asistido: te hago preguntas cortitas, una por una, y te explico todo.'**
  String get welcomeAssistedBody;

  /// No description provided for @welcomeManualTitle.
  ///
  /// In es, this message translates to:
  /// **'Llenar yo mismo'**
  String get welcomeManualTitle;

  /// No description provided for @welcomeManualBody.
  ///
  /// In es, this message translates to:
  /// **'Llenado manual: todo en una sola pantalla, más rápido si ya conoces la app.'**
  String get welcomeManualBody;

  /// No description provided for @welcomeChangeLater.
  ///
  /// In es, this message translates to:
  /// **'Puedes cambiarlo cuando quieras en Ajustes.'**
  String get welcomeChangeLater;

  /// No description provided for @themeToDark.
  ///
  /// In es, this message translates to:
  /// **'Cambiar a modo oscuro'**
  String get themeToDark;

  /// No description provided for @themeToLight.
  ///
  /// In es, this message translates to:
  /// **'Cambiar a modo claro'**
  String get themeToLight;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get settingsAppearanceTitle;

  /// No description provided for @themeSystem.
  ///
  /// In es, this message translates to:
  /// **'Automático'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeSwitchSemantics.
  ///
  /// In es, this message translates to:
  /// **'Apariencia de la pantalla'**
  String get themeSwitchSemantics;

  /// No description provided for @chatTitle.
  ///
  /// In es, this message translates to:
  /// **'Conversando con Semi'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Te hago unas preguntas cortitas'**
  String get chatSubtitle;

  /// No description provided for @chatProgressSemantics.
  ///
  /// In es, this message translates to:
  /// **'Pregunta {current} de {total}'**
  String chatProgressSemantics(int current, int total);

  /// No description provided for @chatThinkingSemantics.
  ///
  /// In es, this message translates to:
  /// **'Semi está pensando'**
  String get chatThinkingSemantics;

  /// No description provided for @chatYouSaid.
  ///
  /// In es, this message translates to:
  /// **'Tú: {answer}'**
  String chatYouSaid(String answer);

  /// No description provided for @chatParcelQuestion.
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Encontré tu chacra en {valley}. ¿Es esta?'**
  String chatParcelQuestion(String valley);

  /// No description provided for @chatParcelWhy.
  ///
  /// In es, this message translates to:
  /// **'Es el punto que tengo marcado para tu chacra en el valle. Si no es, dime y lo cambiamos.'**
  String get chatParcelWhy;

  /// No description provided for @chatParcelYes.
  ///
  /// In es, this message translates to:
  /// **'Sí, es mi chacra'**
  String get chatParcelYes;

  /// No description provided for @chatParcelNo.
  ///
  /// In es, this message translates to:
  /// **'No, es otra'**
  String get chatParcelNo;

  /// No description provided for @chatParcelNoReply.
  ///
  /// In es, this message translates to:
  /// **'Gracias por decirme. Pronto podrás marcarla en el mapa. Por ahora seguimos con esta.'**
  String get chatParcelNoReply;

  /// No description provided for @chatLastCropQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué sembraste la última campaña? Tengo anotado {crop}. ¿Es así?'**
  String chatLastCropQuestion(String crop);

  /// No description provided for @chatLastCropWhy.
  ///
  /// In es, this message translates to:
  /// **'Cada cultivo deja la tierra distinta. Con tu respuesta calculo mejor qué te conviene.'**
  String get chatLastCropWhy;

  /// No description provided for @chatLastCropYes.
  ///
  /// In es, this message translates to:
  /// **'Sí, {crop}'**
  String chatLastCropYes(String crop);

  /// No description provided for @chatLastCropNo.
  ///
  /// In es, this message translates to:
  /// **'No, fue {crop}'**
  String chatLastCropNo(String crop);

  /// No description provided for @chatPriorityQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué es lo que más te importa en esta campaña?'**
  String get chatPriorityQuestion;

  /// No description provided for @chatPriorityWhy.
  ///
  /// In es, this message translates to:
  /// **'Con esto ordeno las opciones según lo que tú quieres.'**
  String get chatPriorityWhy;

  /// No description provided for @chatRestrictionQuestion.
  ///
  /// In es, this message translates to:
  /// **'Última pregunta: ¿hay algo que no puedas hacer?'**
  String get chatRestrictionQuestion;

  /// No description provided for @chatRestrictionWhy.
  ///
  /// In es, this message translates to:
  /// **'Así no te recomiendo algo que no te sirve.'**
  String get chatRestrictionWhy;

  /// No description provided for @chatRestrictionNone.
  ///
  /// In es, this message translates to:
  /// **'Nada, todo bien'**
  String get chatRestrictionNone;

  /// No description provided for @chatDone.
  ///
  /// In es, this message translates to:
  /// **'¡Listo! Ya tengo tu plan.'**
  String get chatDone;

  /// No description provided for @actionSeePlan.
  ///
  /// In es, this message translates to:
  /// **'Ver mi plan'**
  String get actionSeePlan;

  /// No description provided for @farmSatelliteBadge.
  ///
  /// In es, this message translates to:
  /// **'Sugerido'**
  String get farmSatelliteBadge;

  /// No description provided for @helpButton.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get helpButton;

  /// No description provided for @helpButtonSemantics.
  ///
  /// In es, this message translates to:
  /// **'Preguntarle a Semi'**
  String get helpButtonSemantics;

  /// No description provided for @helpTitle.
  ///
  /// In es, this message translates to:
  /// **'Pregúntale a Semi'**
  String get helpTitle;

  /// No description provided for @helpClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get helpClose;

  /// No description provided for @helpIntro.
  ///
  /// In es, this message translates to:
  /// **'¿En qué te ayudo? Puedes preguntarme sobre {topic}, cambiar algo de la app o ver cómo se usa.'**
  String helpIntro(String topic);

  /// No description provided for @helpTopicClimate.
  ///
  /// In es, this message translates to:
  /// **'el clima'**
  String get helpTopicClimate;

  /// No description provided for @helpTopicWhatToPlant.
  ///
  /// In es, this message translates to:
  /// **'qué sembrar'**
  String get helpTopicWhatToPlant;

  /// No description provided for @helpTopicRotation.
  ///
  /// In es, this message translates to:
  /// **'la rotación'**
  String get helpTopicRotation;

  /// No description provided for @helpTopicAlerts.
  ///
  /// In es, this message translates to:
  /// **'los avisos'**
  String get helpTopicAlerts;

  /// No description provided for @helpGroupMeaning.
  ///
  /// In es, this message translates to:
  /// **'Qué significa'**
  String get helpGroupMeaning;

  /// No description provided for @helpGroupChange.
  ///
  /// In es, this message translates to:
  /// **'Cambiar algo'**
  String get helpGroupChange;

  /// No description provided for @helpGroupHowTo.
  ///
  /// In es, this message translates to:
  /// **'Cómo se usa'**
  String get helpGroupHowTo;

  /// No description provided for @helpYouAsked.
  ///
  /// In es, this message translates to:
  /// **'Tú preguntaste: {question}'**
  String helpYouAsked(String question);

  /// No description provided for @helpInputHint.
  ///
  /// In es, this message translates to:
  /// **'O escribe, por ejemplo: abono verde'**
  String get helpInputHint;

  /// No description provided for @helpAsk.
  ///
  /// In es, this message translates to:
  /// **'Preguntar'**
  String get helpAsk;

  /// No description provided for @helpUnknown.
  ///
  /// In es, this message translates to:
  /// **'Uy, eso no lo sé todavía. Toca una de estas preguntas y te explico.'**
  String get helpUnknown;

  /// No description provided for @helpProbableQ.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué hay varios escenarios de clima?'**
  String get helpProbableQ;

  /// No description provided for @helpProbableA.
  ///
  /// In es, this message translates to:
  /// **'Nadie sabe seguro cómo vendrá el año. Por eso calculamos cada opción para tres casos: año normal, lluvias fuertes y año seco. Empezamos por el año normal y tú puedes ver los otros en \"Explorar otros escenarios\".'**
  String get helpProbableA;

  /// No description provided for @helpProbableK.
  ///
  /// In es, this message translates to:
  /// **'probable,seguro,escenario,escenarios,lluvias,seco,normal,niño,posibilidad'**
  String get helpProbableK;

  /// No description provided for @helpSourceQ.
  ///
  /// In es, this message translates to:
  /// **'¿De dónde sale el pronóstico?'**
  String get helpSourceQ;

  /// No description provided for @helpSourceA.
  ///
  /// In es, this message translates to:
  /// **'La lluvia de esta semana viene del pronóstico del día. Para comparar este mes con lo normal y calcular el riego usamos NASA POWER: datos de clima de la NASA para tu punto.'**
  String get helpSourceA;

  /// No description provided for @helpSourceK.
  ///
  /// In es, this message translates to:
  /// **'nasa,satelite,fuente,sale,pronostico,datos,enfen,niño'**
  String get helpSourceK;

  /// No description provided for @helpRainMmQ.
  ///
  /// In es, this message translates to:
  /// **'¿Qué son los mm de lluvia?'**
  String get helpRainMmQ;

  /// No description provided for @helpRainMmA.
  ///
  /// In es, this message translates to:
  /// **'Es cuánta agua cae. 1 mm es como si se juntara una capa de agua de 1 milímetro sobre tu chacra. Con 40 mm en un día ya es lluvia fuerte: mejor no abonar ni fumigar ese día.'**
  String get helpRainMmA;

  /// No description provided for @helpRainMmK.
  ///
  /// In es, this message translates to:
  /// **'mm,milimetro,cuanta lluvia,cuanto llueve'**
  String get helpRainMmK;

  /// No description provided for @helpMoistureQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo sé si mi tierra está mojada?'**
  String get helpMoistureQ;

  /// No description provided for @helpMoistureA.
  ///
  /// In es, this message translates to:
  /// **'La estimamos con NASA POWER, datos de clima de la NASA que combinan satélites y modelos. Cubre toda la zona, así que puede ser un poco distinto a lo que ves en tu chacra.'**
  String get helpMoistureA;

  /// No description provided for @helpMoistureK.
  ///
  /// In es, this message translates to:
  /// **'humedad,mojada,humeda,seca,smap'**
  String get helpMoistureK;

  /// No description provided for @helpWaterQ.
  ///
  /// In es, this message translates to:
  /// **'¿Qué significa el agua?'**
  String get helpWaterQ;

  /// No description provided for @helpWaterA.
  ///
  /// In es, this message translates to:
  /// **'Es el agua que necesitan los cultivos en una campaña, por cada hectárea. Se mide en metros cúbicos: 1 m³ es como un tanque de mil litros. Usar menos agua ayuda cuando el reservorio está bajo.'**
  String get helpWaterA;

  /// No description provided for @helpWaterK.
  ///
  /// In es, this message translates to:
  /// **'agua,riego,m3,m³,metros cubicos,regar'**
  String get helpWaterK;

  /// No description provided for @helpSoilQ.
  ///
  /// In es, this message translates to:
  /// **'¿Qué quiere decir \"tu tierra: buena\"?'**
  String get helpSoilQ;

  /// No description provided for @helpSoilA.
  ///
  /// In es, this message translates to:
  /// **'Es cómo quedaría tu tierra después de 2 años. Si siembras lo mismo una y otra vez, la tierra se cansa y llegan más plagas. Si cambias de cultivo y pones frejol o menestra, la tierra descansa y mejora.'**
  String get helpSoilA;

  /// No description provided for @helpSoilK.
  ///
  /// In es, this message translates to:
  /// **'tierra,suelo,cansada,buena,regular'**
  String get helpSoilK;

  /// No description provided for @helpDeadlineQ.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué tengo que decidir antes de una fecha?'**
  String get helpDeadlineQ;

  /// No description provided for @helpDeadlineA.
  ///
  /// In es, this message translates to:
  /// **'Porque hay que preparar la tierra y conseguir la semilla antes de que empiece la siembra. Si esperas más, se te puede pasar la mejor época para ese cultivo.'**
  String get helpDeadlineA;

  /// No description provided for @helpDeadlineK.
  ///
  /// In es, this message translates to:
  /// **'fecha,cuando,decidir,diciembre,antes'**
  String get helpDeadlineK;

  /// No description provided for @helpBlocksQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo leo los bloques de colores?'**
  String get helpBlocksQ;

  /// No description provided for @helpBlocksA.
  ///
  /// In es, this message translates to:
  /// **'Cada bloque es una campaña. Se lee de arriba hacia abajo: el primero es lo que siembras ahora y el último es dentro de 2 años. Cada cultivo tiene su color, así ves rápido si repites lo mismo.'**
  String get helpBlocksA;

  /// No description provided for @helpBlocksK.
  ///
  /// In es, this message translates to:
  /// **'color,colores,bloque,leo,leer,plan'**
  String get helpBlocksK;

  /// No description provided for @helpRotateQ.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué cambiar de cultivo?'**
  String get helpRotateQ;

  /// No description provided for @helpRotateA.
  ///
  /// In es, this message translates to:
  /// **'Cada cultivo saca de la tierra cosas distintas y atrae plagas distintas. Si cambias, la tierra se recupera y las plagas no se acumulan. Así tu cosecha aguanta mejor los años difíciles.'**
  String get helpRotateA;

  /// No description provided for @helpRotateK.
  ///
  /// In es, this message translates to:
  /// **'rotacion,rotar,cambiar de cultivo,plagas,por que cambiar'**
  String get helpRotateK;

  /// No description provided for @helpGreenManureQ.
  ///
  /// In es, this message translates to:
  /// **'¿Qué es el abono verde?'**
  String get helpGreenManureQ;

  /// No description provided for @helpGreenManureA.
  ///
  /// In es, this message translates to:
  /// **'Es una planta que se siembra para no cosecharla: se deja en la tierra para que se descomponga y la alimente. Es como darle descanso y comida a tu chacra al mismo tiempo.'**
  String get helpGreenManureA;

  /// No description provided for @helpGreenManureK.
  ///
  /// In es, this message translates to:
  /// **'abono,verde,cobertura,descanso'**
  String get helpGreenManureK;

  /// No description provided for @helpAlertsQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo me llegan los avisos?'**
  String get helpAlertsQ;

  /// No description provided for @helpAlertsA.
  ///
  /// In es, this message translates to:
  /// **'Te aviso cuando viene lluvia fuerte, cuando tu tierra está muy mojada o muy seca, y cuando cambia el pronóstico de los próximos meses. Si nada cambia, no te molesto.'**
  String get helpAlertsA;

  /// No description provided for @helpAlertsK.
  ///
  /// In es, this message translates to:
  /// **'aviso,alerta,notificacion,llegan,mensaje'**
  String get helpAlertsK;

  /// No description provided for @helpListenQ.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo escucho lo que dice Semi?'**
  String get helpListenQ;

  /// No description provided for @helpListenA.
  ///
  /// In es, this message translates to:
  /// **'Toca \"Escuchar\" debajo de lo que digo y te lo leo en voz alta. Sube el volumen de tu celular.'**
  String get helpListenA;

  /// No description provided for @helpListenK.
  ///
  /// In es, this message translates to:
  /// **'escuchar,oir,voz,leer,audio,no veo,sonido'**
  String get helpListenK;

  /// No description provided for @helpToDarkQ.
  ///
  /// In es, this message translates to:
  /// **'Poner la pantalla oscura'**
  String get helpToDarkQ;

  /// No description provided for @helpToDarkA.
  ///
  /// In es, this message translates to:
  /// **'Listo, puse la pantalla oscura. Cansa menos la vista de noche.'**
  String get helpToDarkA;

  /// No description provided for @helpToLightQ.
  ///
  /// In es, this message translates to:
  /// **'Poner la pantalla clara'**
  String get helpToLightQ;

  /// No description provided for @helpToLightA.
  ///
  /// In es, this message translates to:
  /// **'Listo, puse la pantalla clara. Se ve mejor con sol.'**
  String get helpToLightA;

  /// No description provided for @helpThemeK.
  ///
  /// In es, this message translates to:
  /// **'oscuro,oscura,claro,clara,noche,brillo,pantalla'**
  String get helpThemeK;

  /// No description provided for @helpToManualQ.
  ///
  /// In es, this message translates to:
  /// **'Llenar yo mismo, sin preguntas'**
  String get helpToManualQ;

  /// No description provided for @helpToManualA.
  ///
  /// In es, this message translates to:
  /// **'Listo. Desde ahora llenas los datos en una sola pantalla. Si me necesitas, toca mi botón.'**
  String get helpToManualA;

  /// No description provided for @helpToAssistedQ.
  ///
  /// In es, this message translates to:
  /// **'Que Semi me pregunte'**
  String get helpToAssistedQ;

  /// No description provided for @helpToAssistedA.
  ///
  /// In es, this message translates to:
  /// **'Listo. Desde ahora te acompaño en cada pantalla y te pregunto una cosa a la vez.'**
  String get helpToAssistedA;

  /// No description provided for @helpModeK.
  ///
  /// In es, this message translates to:
  /// **'modo,manual,asistido,asistencia,formulario,preguntas'**
  String get helpModeK;

  /// No description provided for @helpFarmQ.
  ///
  /// In es, this message translates to:
  /// **'Cambiar los datos de mi chacra'**
  String get helpFarmQ;

  /// No description provided for @helpFarmA.
  ///
  /// In es, this message translates to:
  /// **'Te vuelvo a preguntar por tu chacra. Lo demás se queda igual.'**
  String get helpFarmA;

  /// No description provided for @helpFarmK.
  ///
  /// In es, this message translates to:
  /// **'datos,corregir,me equivoque,editar,chacra,parcela'**
  String get helpFarmK;

  /// No description provided for @helpLanguageQ.
  ///
  /// In es, this message translates to:
  /// **'Cambiar el idioma'**
  String get helpLanguageQ;

  /// No description provided for @helpLanguageA.
  ///
  /// In es, this message translates to:
  /// **'Elige el idioma en el que quieres que te hable.'**
  String get helpLanguageA;

  /// No description provided for @helpLanguageK.
  ///
  /// In es, this message translates to:
  /// **'idioma,lengua,ingles,quechua,español,runasimi'**
  String get helpLanguageK;

  /// No description provided for @helpLanguageAction.
  ///
  /// In es, this message translates to:
  /// **'Elegir idioma'**
  String get helpLanguageAction;

  /// No description provided for @simTitle.
  ///
  /// In es, this message translates to:
  /// **'Prueba tu propio plan'**
  String get simTitle;

  /// No description provided for @recoOverline.
  ///
  /// In es, this message translates to:
  /// **'Te recomiendo'**
  String get recoOverline;

  /// No description provided for @stripNext.
  ///
  /// In es, this message translates to:
  /// **'Próxima siembra'**
  String get stripNext;

  /// No description provided for @stripLater.
  ///
  /// In es, this message translates to:
  /// **'En 2 años'**
  String get stripLater;

  /// No description provided for @recoSoil.
  ///
  /// In es, this message translates to:
  /// **'Tu tierra'**
  String get recoSoil;

  /// No description provided for @waterLess.
  ///
  /// In es, this message translates to:
  /// **'{percent} menos'**
  String waterLess(String percent);

  /// No description provided for @waterSimilar.
  ///
  /// In es, this message translates to:
  /// **'Parecida'**
  String get waterSimilar;

  /// No description provided for @recoNote.
  ///
  /// In es, this message translates to:
  /// **'Pensando en: {priority}. Comparado con seguir con {crop}.'**
  String recoNote(String priority, String crop);

  /// No description provided for @whyTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué?'**
  String get whyTitle;

  /// No description provided for @whyConfidence.
  ///
  /// In es, this message translates to:
  /// **'Es lo que más veces funciona en años así, pero el clima puede cambiar.'**
  String get whyConfidence;

  /// No description provided for @semiPlantSay.
  ///
  /// In es, this message translates to:
  /// **'Pensando en {priority}, te recomiendo {rotation}. Abajo te explico por qué.'**
  String semiPlantSay(String priority, String rotation);

  /// No description provided for @semiRotationSay.
  ///
  /// In es, this message translates to:
  /// **'Aquí comparas lo que siembras hoy con otras dos opciones. Toca \"Ver por qué\" en cada una. Y si quieres, arma tu propio plan.'**
  String get semiRotationSay;

  /// No description provided for @soilTodayOverline.
  ///
  /// In es, this message translates to:
  /// **'Tu tierra hoy'**
  String get soilTodayOverline;

  /// No description provided for @soilReason.
  ///
  /// In es, this message translates to:
  /// **'Lleva {count} siembras seguidas de {crop}.'**
  String soilReason(int count, String crop);

  /// No description provided for @howDoIKnow.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo lo sé?'**
  String get howDoIKnow;

  /// No description provided for @compareSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Para las próximas 4 siembras (2 años), en el escenario de clima que estás viendo.'**
  String get compareSubtitle;

  /// No description provided for @optionCurrentLabel.
  ///
  /// In es, this message translates to:
  /// **'Si sigues como ahora'**
  String get optionCurrentLabel;

  /// No description provided for @optionRecommendedLabel.
  ///
  /// In es, this message translates to:
  /// **'La que te recomiendo'**
  String get optionRecommendedLabel;

  /// No description provided for @optionOtherLabel.
  ///
  /// In es, this message translates to:
  /// **'Otra opción'**
  String get optionOtherLabel;

  /// No description provided for @optionMineLabel.
  ///
  /// In es, this message translates to:
  /// **'La que tú armaste'**
  String get optionMineLabel;

  /// No description provided for @seeWhy.
  ///
  /// In es, this message translates to:
  /// **'Ver por qué'**
  String get seeWhy;

  /// No description provided for @fichaWhy.
  ///
  /// In es, this message translates to:
  /// **'Por qué se sugiere'**
  String get fichaWhy;

  /// No description provided for @fichaEvidence.
  ///
  /// In es, this message translates to:
  /// **'Qué lo respalda'**
  String get fichaEvidence;

  /// No description provided for @fichaUnknowns.
  ///
  /// In es, this message translates to:
  /// **'Lo que no sabemos'**
  String get fichaUnknowns;

  /// No description provided for @fichaCheck.
  ///
  /// In es, this message translates to:
  /// **'Revísalo con tu técnico'**
  String get fichaCheck;

  /// No description provided for @rotationGuideNote.
  ///
  /// In es, this message translates to:
  /// **'Esto es una guía, no una orden. Revisa las opciones con tu técnico.'**
  String get rotationGuideNote;

  /// No description provided for @deleteAll.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo y empezar de nuevo'**
  String get deleteAll;

  /// No description provided for @deleteAllConfirm.
  ///
  /// In es, this message translates to:
  /// **'Toca otra vez para borrar tus datos'**
  String get deleteAllConfirm;

  /// No description provided for @settingsModeAssistedNote.
  ///
  /// In es, this message translates to:
  /// **'Semi te explica cada pantalla y te hace las preguntas una por una.'**
  String get settingsModeAssistedNote;

  /// No description provided for @settingsModeManualNote.
  ///
  /// In es, this message translates to:
  /// **'Tú llenas tus datos en una pantalla. Semi solo aparece si le preguntas.'**
  String get settingsModeManualNote;

  /// No description provided for @semiAlertsImportant.
  ///
  /// In es, this message translates to:
  /// **'El más importante: {title}.'**
  String semiAlertsImportant(String title);

  /// No description provided for @climateMore.
  ///
  /// In es, this message translates to:
  /// **'Ver más del clima'**
  String get climateMore;

  /// No description provided for @whyMore.
  ///
  /// In es, this message translates to:
  /// **'¿Por qué te lo recomiendo?'**
  String get whyMore;

  /// No description provided for @otherOptionsMore.
  ///
  /// In es, this message translates to:
  /// **'Ver las otras opciones'**
  String get otherOptionsMore;

  /// No description provided for @sampleDataBanner.
  ///
  /// In es, this message translates to:
  /// **'Datos de ejemplo: no son mediciones reales de tu chacra'**
  String get sampleDataBanner;
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
      <String>['en', 'es', 'qu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'qu':
      return AppLocalizationsQu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
