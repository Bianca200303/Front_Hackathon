// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Siembra Segura';

  @override
  String get tabClimate => 'Clima';

  @override
  String get tabWhatToPlant => 'Qué sembrar';

  @override
  String get tabRotation => 'Rotación';

  @override
  String get tabAlerts => 'Avisos';

  @override
  String get tabAlertsUnreadSemantics => 'Avisos, hay avisos nuevos';

  @override
  String get actionStart => 'Empezar';

  @override
  String get actionBack => 'Volver';

  @override
  String get actionDone => 'Listo';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get actionListen => 'Escuchar';

  @override
  String get actionListenSemantics => 'Escuchar el contenido de esta pantalla';

  @override
  String get actionChange => 'Cambiar';

  @override
  String get actionCompareOptions => 'Comparar con otras opciones';

  @override
  String get actionWhenToPlant => '¿Cuándo siembro?';

  @override
  String get actionSeeMyRecommendation => 'Ver mi recomendación';

  @override
  String get farmTitle => 'Tu parcela';

  @override
  String get climateTitle => 'Cómo viene tu valle';

  @override
  String get recommendationTitle => '¿Qué me conviene sembrar?';

  @override
  String get plantingScheduleTitle => '¿Cuándo siembro?';

  @override
  String get rotationTitle => 'Tu plan de rotación';

  @override
  String get alertsTitle => 'Avisos';

  @override
  String get alertMessageTitle => 'Mensaje';

  @override
  String get loading => 'Cargando…';

  @override
  String get emptyDefault => 'Todavía no hay información.';

  @override
  String get emptyRecommendation =>
      'Con lo que indicaste no encontramos opciones. Revisa lo que no puedes hacer en Tu parcela.';

  @override
  String get emptyAlerts => 'No tienes avisos por ahora.';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get errorNetwork =>
      'No hay conexión. Revisa tu señal e inténtalo de nuevo.';

  @override
  String get errorTimeout =>
      'La respuesta tardó demasiado. Inténtalo de nuevo.';

  @override
  String get errorUnauthorized => 'Tu sesión terminó. Vuelve a ingresar.';

  @override
  String get errorServer => 'Tuvimos un problema. Inténtalo más tarde.';

  @override
  String get errorNotFound => 'No encontramos esta información.';

  @override
  String get errorUnexpected => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get errorSpeechUnavailable =>
      'No se pudo reproducir el audio en este celular.';

  @override
  String get sampleDataDisclaimer => 'Cifras de ejemplo.';

  @override
  String get perHectare => 'Por hectárea.';

  @override
  String get guideDisclaimer =>
      'Esta app es una guía. La decisión final es tuya: conversa estos resultados con tu técnico o la agencia agraria.';

  @override
  String get whatDoesItMean => '¿Qué significa?';

  @override
  String get optionalLabel => '(opcional)';

  @override
  String rotationNameSequence(String first, String second) {
    return '$first y después $second';
  }

  @override
  String rotationNameRepeated(String first, String second) {
    return '$first y $second';
  }

  @override
  String listJoin(String first, String second) {
    return '$first y $second';
  }

  @override
  String get scenarioHeavyRains => 'Lluvias fuertes';

  @override
  String get scenarioNormal => 'Normal';

  @override
  String get scenarioDry => 'Seco';

  @override
  String get scenarioOptionHeavyRains => 'Con lluvias';

  @override
  String get scenarioPhraseHeavyRains => 'un año con lluvias fuertes';

  @override
  String get scenarioPhraseNormal => 'un año normal';

  @override
  String get scenarioPhraseDry => 'un año seco';

  @override
  String get soilVeryTired => 'Muy cansada';

  @override
  String get soilTired => 'Cansada';

  @override
  String get soilRegular => 'Regular';

  @override
  String get soilGood => 'Buena';

  @override
  String soilWithLabel(String condition) {
    return 'Tierra: $condition';
  }

  @override
  String get soilImpactImproves => 'mejora';

  @override
  String get soilImpactImprovesALot => 'mejora mucho';

  @override
  String farmGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get farmSatelliteCaption => 'Foto de satélite (NASA)';

  @override
  String get farmMapSemantics => 'Vista satelital de la parcela marcada';

  @override
  String get farmValley => 'Valle';

  @override
  String get farmArea => 'Área';

  @override
  String get farmIrrigation => 'Riego de';

  @override
  String farmAreaValue(String area) {
    return '$area ha';
  }

  @override
  String get farmLastCropQuestion => '¿Qué sembraste la última campaña?';

  @override
  String farmLastCropHint(String crop) {
    return 'Por el satélite creemos que fue $crop. Si no es así, toca el correcto.';
  }

  @override
  String get farmLastCropGroupSemantics => 'Cultivo de la última campaña';

  @override
  String get farmPriorityQuestion => '¿Qué te importa más esta campaña?';

  @override
  String get farmPriorityGroupSemantics => 'Prioridad';

  @override
  String get farmPriorityNote =>
      'Puedes cambiarlo después desde el botón de ajustes de cada pantalla.';

  @override
  String get farmResetAction => 'Volver a los valores sugeridos';

  @override
  String get farmResetDone => 'Listo: usamos de nuevo los valores sugeridos.';

  @override
  String get farmSettingsTooltip =>
      'Mi parcela: cambiar cultivo, prioridad o restricciones';

  @override
  String get farmRestrictionsQuestion => '¿Hay algo que no puedas hacer?';

  @override
  String farmNarration(String name, String crop) {
    return 'Hola $name. Por el satélite creemos que la última campaña sembraste $crop. Si no es así, toca el cultivo correcto. Luego dinos qué te importa más esta campaña: ganar más, cuidar tu agua o recuperar tu tierra.';
  }

  @override
  String get weatherSunny => 'Sol';

  @override
  String get weatherCloudy => 'Nubes';

  @override
  String get weatherRain => 'Lluvia';

  @override
  String get weatherModerateRain => 'Lluvia moderada';

  @override
  String get weatherHeavyRain => 'Lluvia fuerte';

  @override
  String get weatherHeavyRainShort => 'Fuerte';

  @override
  String climateToday(String weekday) {
    return 'Hoy, $weekday';
  }

  @override
  String climateTodayDetails(
    String probability,
    String rain,
    String temperature,
  ) {
    return '$probability de probabilidad · $rain · $temperature';
  }

  @override
  String get climateThisWeek => 'Esta semana';

  @override
  String climateHeavyRainDay(String weekday) {
    return 'El $weekday se espera lluvia fuerte.';
  }

  @override
  String get climateAdviceLead => 'Qué hacer:';

  @override
  String climateOutlookTitle(
    String month,
    String scenario,
    String probability,
  ) {
    return 'Hasta $month: $scenario ($probability)';
  }

  @override
  String get climateOutlookAction => 'Toca para ver qué te conviene sembrar.';

  @override
  String get climateComparisonTitle => 'Comparado con un año normal';

  @override
  String get climateComparisonNote =>
      'La raya negra marca lo normal para este mes. Datos de satélite NASA (lluvia y humedad del suelo) y pronóstico del día.';

  @override
  String get anomalyRainfall => 'Lluvia del mes';

  @override
  String get anomalyTemperature => 'Calor';

  @override
  String get anomalySoilMoisture => 'Humedad de tu suelo';

  @override
  String anomalyTimesMore(String count) {
    return '$count veces más';
  }

  @override
  String anomalyTimesLess(String count) {
    return '$count veces menos';
  }

  @override
  String anomalyDegreesMore(String degrees) {
    return '$degrees °C más';
  }

  @override
  String anomalyDegreesLess(String degrees) {
    return '$degrees °C menos';
  }

  @override
  String get anomalyAsNormal => 'Como lo normal';

  @override
  String anomalyBarSemantics(String metric, String status) {
    return '$metric: $status';
  }

  @override
  String get moistureVeryWet => 'Muy húmedo';

  @override
  String get moistureWet => 'Húmedo';

  @override
  String get moistureNormal => 'Normal';

  @override
  String get moistureDry => 'Seco';

  @override
  String get climateExplainerSoilMoistureTerm => 'Humedad del suelo:';

  @override
  String get climateExplainerSoilMoistureBody =>
      'cuánta agua tiene tu tierra. La mide el satélite SMAP de la NASA.';

  @override
  String get climateExplainerNormalTerm => 'Lo normal:';

  @override
  String get climateExplainerNormalBody =>
      'el promedio de los últimos 20 años para este mes en tu valle.';

  @override
  String get climateExplainerSatelliteTerm => 'Satélite vs tu chacra:';

  @override
  String get climateExplainerSatelliteBody =>
      'el satélite mide toda la zona desde el espacio, así que puede diferir un poco de lo que ves en tu campo. Por eso te pedimos confirmar lo que sembraste: tu respuesta corrige al satélite.';

  @override
  String climateNarration(String condition, String probability) {
    return 'Hoy en tu valle se espera $condition, con $probability de probabilidad.';
  }

  @override
  String recommendationOutlookOverline(String month) {
    return 'CÓMO VIENE TU VALLE HASTA $month';
  }

  @override
  String recommendationMostLikely(String scenario) {
    return 'Lo más probable: $scenario';
  }

  @override
  String get recommendationOutlookNote =>
      'Calculado con datos de satélite de la NASA (mar, lluvia y suelo). Coincide con el ENFEN.';

  @override
  String recommendationThinkingOf(String priority) {
    return 'Pensando en: $priority';
  }

  @override
  String get recommendationHeadline => 'TE RECOMENDAMOS';

  @override
  String get recommendationIfHeavyRains =>
      'SI EL AÑO VIENE CON LLUVIAS FUERTES, TE CONVIENE';

  @override
  String get recommendationIfNormal => 'SI EL AÑO VIENE NORMAL, TE CONVIENE';

  @override
  String get recommendationIfDry => 'SI EL AÑO VIENE SECO, TE CONVIENE';

  @override
  String get outcomeIfGood => 'Si va bien:';

  @override
  String outcomeIfGoodValue(String amount) {
    return 'ganas unos $amount';
  }

  @override
  String get outcomeIfBad => 'Si va mal:';

  @override
  String outcomeIfBadValue(String amount) {
    return 'pierdes hasta $amount';
  }

  @override
  String get outcomeIfNormal => 'Si al final no llueve tanto:';

  @override
  String outcomeIfNormalValue(String amount) {
    return 'igual ganas unos $amount';
  }

  @override
  String get outcomeWater => 'Agua:';

  @override
  String get outcomeSoil => 'Tu tierra:';

  @override
  String recommendationRepeatOverline(String crop) {
    return 'SI SIEMBRAS $crop OTRA VEZ';
  }

  @override
  String get recommendationExploreScenarios => 'Explorar otros escenarios';

  @override
  String get recommendationExploreQuestion =>
      '¿Y si el año viene distinto a lo más probable?';

  @override
  String get scenarioSelectorSemantics => 'Ver otro escenario';

  @override
  String recommendationNarration(
    String month,
    String scenario,
    String probability,
    String priority,
    String rotation,
    String profit,
    String loss,
    String soil,
    String repeatWarning,
  ) {
    return 'Lo más probable en tu valle hasta $month son $scenario, con $probability de probabilidad. Pensando en $priority, te recomendamos $rotation. Si va bien, ganas unos $profit por hectárea. Si va mal, pierdes hasta $loss. Tu tierra $soil. $repeatWarning';
  }

  @override
  String get scheduleDecideBefore => 'Decide antes del';

  @override
  String get scheduleYourCalendar => 'Tu calendario';

  @override
  String scheduleCalendarSemantics(String crop, int months) {
    return '$crop: $months meses';
  }

  @override
  String scheduleRiskLegend(String months) {
    return '$months: riesgo de lluvia fuerte. Ten la cosecha cerca o protegida.';
  }

  @override
  String get scheduleFallowLead =>
      'De agosto a noviembre tu campo queda sin cultivo.';

  @override
  String get scheduleFallowBody =>
      'Puedes sembrar un cultivo de cobertura (como frejol de palo o crotalaria) para proteger y abonar la tierra.';

  @override
  String get scheduleWhyTitle => '¿Por qué te lo recomendamos?';

  @override
  String scheduleReasonSoilRestores(int count, String crop) {
    return 'Tu tierra lleva $count campañas de $crop; esta rotación la recupera.';
  }

  @override
  String scheduleReasonSoilHelps(int count, String crop) {
    return 'Tu tierra lleva $count campañas de $crop; esta rotación la ayuda a recuperar.';
  }

  @override
  String scheduleReasonWater(String source, String crop) {
    return 'Gastas menos agua de $source que con $crop.';
  }

  @override
  String scheduleNarration(String rotation, String date, String instructions) {
    return '$rotation. Decide antes del $date. $instructions';
  }

  @override
  String get feedbackQuestion => 'Cuando siembres, cuéntanos qué fue';

  @override
  String feedbackFollowed(String crop) {
    return 'Sembré $crop';
  }

  @override
  String get feedbackOther => 'Sembré otra cosa';

  @override
  String get feedbackThanksTitle => '¡Gracias!';

  @override
  String get feedbackThanksBody =>
      'Con tu respuesta las recomendaciones del valle mejoran para todos.';

  @override
  String get rotationSoilToday => 'TU TIERRA HOY';

  @override
  String rotationSoilGaugeSemantics(String condition) {
    return 'Estado de tu tierra: $condition';
  }

  @override
  String get rotationExplainerGreennessTerm => 'Verdor:';

  @override
  String get rotationExplainerGreennessBody =>
      'el satélite Landsat de la NASA mide qué tan verde y fuerte está tu cultivo (índice NDVI). Si baja año tras año, la tierra se está cansando.';

  @override
  String get rotationExplainerOrganicMatterTerm => 'Materia orgánica:';

  @override
  String get rotationExplainerOrganicMatterBody =>
      'restos de plantas que alimentan la tierra. Es un dato estimado (SoilGrids); un análisis de suelo lo confirmaría.';

  @override
  String rotationCompareTitle(int count) {
    return 'Compara $count opciones';
  }

  @override
  String rotationCompareSubtitle(String priority, String scenario) {
    return 'Pensando en $priority y en $scenario. Por hectárea.';
  }

  @override
  String get optionCurrent => 'LO QUE SIEMBRAS HOY';

  @override
  String get optionRecommended => 'RECOMENDADA';

  @override
  String get optionOther => 'OTRA OPCIÓN';

  @override
  String get metricExpectedProfit => 'Ganancia esperada';

  @override
  String get metricWater => 'Agua';

  @override
  String get metricSoilInTwoYears => 'Tierra en 2 años';

  @override
  String get factsheetToggle => 'Ver por qué, evidencia y riesgos';

  @override
  String get factsheetWhy => 'POR QUÉ SE SUGIERE';

  @override
  String get factsheetEvidence => 'QUÉ DATOS LO RESPALDAN';

  @override
  String get factsheetBenefits => 'BENEFICIOS';

  @override
  String get factsheetUnknowns => 'LO QUE NO SABEMOS';

  @override
  String get factsheetRisks => 'REVÍSALO CON TU TÉCNICO';

  @override
  String get rotationPlanTitle => 'Plan recomendado: próximas campañas';

  @override
  String rotationPlanName(String rotation, String next) {
    return '$rotation y después $next.';
  }

  @override
  String rotationNarration(
    String soil,
    int count,
    String crop,
    int options,
    String current,
    String currentSoil,
    String rotation,
  ) {
    return 'Tu tierra hoy está $soil, porque lleva $count campañas seguidas de $crop. Comparamos $options opciones. Si sigues con $current, en dos años tu tierra quedará $currentSoil. La opción recomendada es $rotation. Toca cada opción para ver por qué la sugerimos, qué datos la respaldan y qué debes revisar con tu técnico. Recuerda: esta app es una guía, la decisión es tuya.';
  }

  @override
  String get alertsFooter =>
      'Los avisos también llegan como mensaje al celular.';

  @override
  String alertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tienes $count avisos.',
      one: 'Tienes un aviso.',
      zero: 'No tienes avisos.',
    );
    return '$_temp0';
  }

  @override
  String alertTimeToday(String time) {
    return 'Hoy, $time';
  }

  @override
  String get alertTimeYesterday => 'Ayer';

  @override
  String alertMeta(String time, String source) {
    return '$time · $source';
  }

  @override
  String get messageChannel => 'Mensaje por celular';

  @override
  String messageSentAt(String day, String time) {
    return '$day, $time';
  }

  @override
  String get messagePlayAudio => 'Reproducir audio';

  @override
  String get messageInputLabel => 'Escribe tu pregunta';

  @override
  String get messageInputHint => 'Pregunta lo que quieras…';

  @override
  String get messageSendAudio => 'Mandar audio';

  @override
  String get messageChatComingSoon => 'Podrás hacer preguntas próximamente.';
}
