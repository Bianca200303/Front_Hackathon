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
  String get farmTitle => 'Datos de tu chacra';

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
  String get climateRiskLow => 'Bajo';

  @override
  String get climateRiskMedium => 'Medio';

  @override
  String get climateRiskHigh => 'Alto';

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
  String get soilImpactDegrades => 'se cansa más';

  @override
  String get soilImpactNeutral => 'queda igual';

  @override
  String get soilImpactImproves => 'mejora';

  @override
  String get soilImpactImprovesALot => 'mejora mucho';

  @override
  String farmGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get farmSatelliteCaption => 'Tu chacra en el valle';

  @override
  String get farmMapQuestion => '¿Dónde está tu chacra?';

  @override
  String get farmMapHint => 'Toca el mapa para marcar dónde está tu chacra.';

  @override
  String farmMapCoordinates(String lat, String lon) {
    return '$lat, $lon';
  }

  @override
  String farmMapPinSemantics(String lat, String lon) {
    return 'Tu chacra está en $lat, $lon. Toca el mapa para moverla.';
  }

  @override
  String get farmValley => 'Valle';

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
    return 'Tenemos anotado $crop. Si no es así, toca el correcto.';
  }

  @override
  String get farmLastCropGroupSemantics => 'Cultivo de la última campaña';

  @override
  String get farmCampaignTitle => 'Tu campaña';

  @override
  String get farmAreaQuestion => '¿Cuántas hectáreas vas a sembrar?';

  @override
  String get farmAreaDecrease => 'Quitar media hectárea';

  @override
  String get farmAreaIncrease => 'Agregar media hectárea';

  @override
  String get farmPlantingDateQuestion => '¿Cuándo quieres sembrar?';

  @override
  String get farmPlantingDateHint => 'Puedes cambiarla cuando quieras.';

  @override
  String get farmPlantingDatePickerTitle => 'Fecha de siembra';

  @override
  String farmCampaignsQuestion(String crop) {
    return '¿Cuántas campañas seguidas sembraste $crop?';
  }

  @override
  String farmCampaignsValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count campañas',
      one: '1 campaña',
    );
    return '$_temp0';
  }

  @override
  String get farmCampaignsDecrease => 'Quitar una campaña';

  @override
  String get farmCampaignsIncrease => 'Agregar una campaña';

  @override
  String get farmPriorityQuestion => '¿Qué te importa más esta campaña?';

  @override
  String get farmPriorityGroupSemantics => 'Prioridad';

  @override
  String get farmResetAction => 'Volver a los valores sugeridos';

  @override
  String get farmResetDone => 'Listo: usamos de nuevo los valores sugeridos.';

  @override
  String get farmRestrictionsQuestion => '¿Hay algo que no puedas hacer?';

  @override
  String get farmSoilTextureHint =>
      'Agarra un puñado de tierra de tu chacra y toca la que se parezca. Lo que tú ves manda sobre lo que estiman los mapas de suelo.';

  @override
  String get farmSoilTextureGroupSemantics => 'Cómo es tu tierra';

  @override
  String get farmSoilTextureUnknown => 'No estoy seguro';

  @override
  String get farmSoilTextureUnknownHint =>
      'Usamos la tierra que estiman los mapas de suelo para tu punto.';

  @override
  String farmNarration(String name, String crop) {
    return 'Hola $name. Tenemos anotado que la última campaña sembraste $crop. Si no es así, toca el cultivo correcto. Luego dinos cuántas hectáreas vas a sembrar, cuándo quieres sembrar y qué te importa más esta campaña.';
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
  String get climatePlanTitle => '¿Qué te conviene sembrar?';

  @override
  String get climatePlanAction =>
      'Toca para ver tu recomendación y cuándo sembrar.';

  @override
  String get climateComparisonTitle => 'Comparado con un año normal';

  @override
  String get climateComparisonNote =>
      'La raya negra marca lo normal para este mes. Datos de clima de la NASA (NASA POWER) y pronóstico del día.';

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
      'cuánta agua tiene tu tierra. La estimamos con datos de clima de la NASA (NASA POWER).';

  @override
  String get climateExplainerNormalTerm => 'Lo normal:';

  @override
  String get climateExplainerNormalBody =>
      'el promedio de los últimos 20 años para este mes en tu valle.';

  @override
  String get climateExplainerSatelliteTerm => 'Datos de la NASA vs tu chacra:';

  @override
  String get climateExplainerSatelliteBody =>
      'los datos de la NASA cubren toda la zona, así que pueden diferir un poco de lo que ves en tu campo.';

  @override
  String climateNarration(String condition, String probability) {
    return 'Hoy en tu valle se espera $condition, con $probability de probabilidad.';
  }

  @override
  String recommendationThinkingOf(String priority) {
    return 'Pensando en: $priority';
  }

  @override
  String get recommendationHeadline => 'TE RECOMENDAMOS';

  @override
  String get recommendationScenarioNote =>
      'Calculado con el clima de los años de referencia de cada escenario (NASA POWER).';

  @override
  String get recommendationIfHeavyRains =>
      'SI EL AÑO VIENE CON LLUVIAS FUERTES, TE CONVIENE';

  @override
  String get recommendationIfDry => 'SI EL AÑO VIENE SECO, TE CONVIENE';

  @override
  String get outcomeWater => 'Agua de riego:';

  @override
  String get outcomeClimateRisk => 'Riesgo de clima:';

  @override
  String get outcomeSoil => 'Tu tierra:';

  @override
  String forArea(String area) {
    return 'Para $area ha.';
  }

  @override
  String recommendationRepeatOverline(String crop) {
    return 'SI SIEMBRAS $crop OTRA VEZ';
  }

  @override
  String get recommendationExploreScenarios => 'Explorar otros escenarios';

  @override
  String get recommendationExploreQuestion => '¿Y si el año viene distinto?';

  @override
  String get scenarioSelectorSemantics => 'Ver otro escenario';

  @override
  String recommendationNarration(
    String priority,
    String scenario,
    String rotation,
    String water,
    String risk,
    String soil,
    String repeatWarning,
  ) {
    return 'Pensando en $priority, para $scenario te recomendamos $rotation. Necesitarías $water de agua de riego y el riesgo de clima es $risk. Tu tierra $soil. $repeatWarning';
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
      'los satélites de la NASA miden qué tan verde y fuerte crece lo sembrado. Si baja año tras año, la tierra se está cansando.';

  @override
  String get rotationExplainerOrganicMatterTerm => 'Materia orgánica:';

  @override
  String get rotationExplainerOrganicMatterBody =>
      'restos de plantas que alimentan la tierra. Es un dato estimado con mapas de suelo; un análisis de suelo lo confirmaría.';

  @override
  String rotationCompareTitle(int count) {
    return 'Compara $count opciones';
  }

  @override
  String get optionCurrent => 'LO QUE SIEMBRAS HOY';

  @override
  String get optionCustom => 'LA TUYA';

  @override
  String get optionRecommended => 'RECOMENDADA';

  @override
  String get optionOther => 'OTRA OPCIÓN';

  @override
  String get metricClimateRisk => 'Riesgo de clima';

  @override
  String get metricWater => 'Agua de riego';

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
  String get cropWaterNeedLow => 'Poca agua';

  @override
  String get cropWaterNeedMedium => 'Agua media';

  @override
  String get cropWaterNeedHigh => 'Mucha agua';

  @override
  String cropCycleMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '1 mes',
    );
    return '$_temp0';
  }

  @override
  String get cropFixesNitrogen => 'Abona tu tierra';

  @override
  String get rotationCustomTitle => 'Arma tu rotación';

  @override
  String get rotationCustomHint =>
      'Toca un cultivo para cambiarlo y mira cómo cambian el agua y tu tierra.';

  @override
  String get rotationCustomPickTitle => '¿Qué cultivo va aquí?';

  @override
  String get rotationCustomAdd => 'Agregar cultivo';

  @override
  String get rotationCustomRemove => 'Quitar de la secuencia';

  @override
  String get rotationCustomClear => 'Volver a las rotaciones sugeridas';

  @override
  String get rotationCustomExcluded =>
      'Con lo que indicaste en Tu parcela, esta secuencia queda descartada.';

  @override
  String rotationCustomPositionSemantics(int position, int total) {
    return 'Cultivo $position de $total';
  }

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

  @override
  String get semiAvatarSemantics => 'Semi, tu asistente de campo';

  @override
  String get appModeSwitchSemantics => 'Modo de uso';

  @override
  String get appModeAssistedTitle => 'Asistencia';

  @override
  String get appModeManualTitle => 'Llenado manual';

  @override
  String get semiFarmGuide =>
      '¡Hola! Soy Semi. Cuéntame qué sembraste la última campaña y qué te importa más. Con eso te ayudo a decidir.';

  @override
  String get semiClimateGuide =>
      'Te cuento cómo viene el clima para tu chacra: el pronóstico de la semana y cómo va este mes comparado con lo normal.';

  @override
  String get semiRecommendationGuide =>
      'Con tu tierra y el clima, esto es lo que más te conviene sembrar. Toca cada opción para ver por qué.';

  @override
  String get semiPlantingScheduleGuide =>
      'Sembrar en el momento justo hace la diferencia. Aquí ves cuándo te conviene.';

  @override
  String get semiRotationGuide =>
      'Cambiar de cultivo cada campaña deja descansar la tierra. Mira cómo quedaría tu suelo con cada opción.';

  @override
  String get semiAlertsGuide =>
      'Aquí te aviso si viene lluvia fuerte, calor o plagas. ¡Revísalos seguido!';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsTooltip => 'Ajustes: modo, idioma y tu parcela';

  @override
  String get settingsModeTitle => 'Cómo quieres usar la app';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsEditFarm => 'Cambiar los datos de mi parcela';

  @override
  String languageAutomatic(String language) {
    return 'Automático: $language';
  }

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageQuechua => 'Runasimi (quechua)';

  @override
  String get languageQuechuaDraftNote =>
      'El quechua está en revisión: lo que falta traducir se muestra en español.';

  @override
  String languageButton(String language) {
    return 'Idioma: $language';
  }

  @override
  String get welcomeTitle => 'Hola, soy Semi';

  @override
  String get welcomeBody =>
      'Te ayudo a decidir qué sembrar para cuidar tu tierra y tu agua.';

  @override
  String get welcomeAiNote => 'Semi es un personaje creado con IA';

  @override
  String get welcomeQuestion => '¿Cómo prefieres empezar?';

  @override
  String get welcomeAssistedTitle => 'Que Semi me pregunte';

  @override
  String get welcomeAssistedBody =>
      'Modo asistido: te hago preguntas cortitas, una por una, y te explico todo.';

  @override
  String get welcomeManualTitle => 'Llenar yo mismo';

  @override
  String get welcomeManualBody =>
      'Llenado manual: todo en una sola pantalla, más rápido si ya conoces la app.';

  @override
  String get welcomeChangeLater =>
      'Puedes cambiarlo cuando quieras en Ajustes.';

  @override
  String get themeToDark => 'Cambiar a modo oscuro';

  @override
  String get themeToLight => 'Cambiar a modo claro';

  @override
  String get settingsAppearanceTitle => 'Apariencia';

  @override
  String get themeSystem => 'Automático';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSwitchSemantics => 'Apariencia de la pantalla';

  @override
  String get chatTitle => 'Conversando con Semi';

  @override
  String get chatSubtitle => 'Te hago unas preguntas cortitas';

  @override
  String chatProgressSemantics(int current, int total) {
    return 'Pregunta $current de $total';
  }

  @override
  String get chatThinkingSemantics => 'Semi está pensando';

  @override
  String chatYouSaid(String answer) {
    return 'Tú: $answer';
  }

  @override
  String chatParcelQuestion(String valley) {
    return '¡Hola! Encontré tu chacra en $valley. ¿Es esta?';
  }

  @override
  String get chatParcelWhy =>
      'Es el punto que tengo marcado para tu chacra en el valle. Si no es, dime y lo cambiamos.';

  @override
  String get chatParcelYes => 'Sí, es mi chacra';

  @override
  String get chatParcelNo => 'No, es otra';

  @override
  String get chatParcelNoReply =>
      'Gracias por decirme. Pronto podrás marcarla en el mapa. Por ahora seguimos con esta.';

  @override
  String chatLastCropQuestion(String crop) {
    return '¿Qué sembraste la última campaña? Tengo anotado $crop. ¿Es así?';
  }

  @override
  String get chatLastCropWhy =>
      'Cada cultivo deja la tierra distinta. Con tu respuesta calculo mejor qué te conviene.';

  @override
  String chatLastCropYes(String crop) {
    return 'Sí, $crop';
  }

  @override
  String chatLastCropNo(String crop) {
    return 'No, fue $crop';
  }

  @override
  String get chatPriorityQuestion =>
      '¿Qué es lo que más te importa en esta campaña?';

  @override
  String get chatPriorityWhy =>
      'Con esto ordeno las opciones según lo que tú quieres.';

  @override
  String get chatRestrictionQuestion =>
      'Última pregunta: ¿hay algo que no puedas hacer?';

  @override
  String get chatRestrictionWhy => 'Así no te recomiendo algo que no te sirve.';

  @override
  String get chatRestrictionNone => 'Nada, todo bien';

  @override
  String get chatDone => '¡Listo! Ya tengo tu plan.';

  @override
  String get actionSeePlan => 'Ver mi plan';

  @override
  String get farmSatelliteBadge => 'Sugerido';

  @override
  String get helpButton => 'Ayuda';

  @override
  String get helpButtonSemantics => 'Preguntarle a Semi';

  @override
  String get helpTitle => 'Pregúntale a Semi';

  @override
  String get helpClose => 'Cerrar';

  @override
  String helpIntro(String topic) {
    return '¿En qué te ayudo? Puedes preguntarme sobre $topic, cambiar algo de la app o ver cómo se usa.';
  }

  @override
  String get helpTopicClimate => 'el clima';

  @override
  String get helpTopicWhatToPlant => 'qué sembrar';

  @override
  String get helpTopicRotation => 'la rotación';

  @override
  String get helpTopicAlerts => 'los avisos';

  @override
  String get helpGroupMeaning => 'Qué significa';

  @override
  String get helpGroupChange => 'Cambiar algo';

  @override
  String get helpGroupHowTo => 'Cómo se usa';

  @override
  String helpYouAsked(String question) {
    return 'Tú preguntaste: $question';
  }

  @override
  String get helpInputHint => 'O escribe, por ejemplo: abono verde';

  @override
  String get helpAsk => 'Preguntar';

  @override
  String get helpUnknown =>
      'Uy, eso no lo sé todavía. Toca una de estas preguntas y te explico.';

  @override
  String get helpProbableQ => '¿Por qué hay varios escenarios de clima?';

  @override
  String get helpProbableA =>
      'Nadie sabe seguro cómo vendrá el año. Por eso calculamos cada opción para tres casos: año normal, lluvias fuertes y año seco. Empezamos por el año normal y tú puedes ver los otros en \"Explorar otros escenarios\".';

  @override
  String get helpProbableK =>
      'probable,seguro,escenario,escenarios,lluvias,seco,normal,niño,posibilidad';

  @override
  String get helpSourceQ => '¿De dónde sale el pronóstico?';

  @override
  String get helpSourceA =>
      'La lluvia de esta semana viene del pronóstico del día. Para comparar este mes con lo normal y calcular el riego usamos NASA POWER: datos de clima de la NASA para tu punto.';

  @override
  String get helpSourceK =>
      'nasa,satelite,fuente,sale,pronostico,datos,enfen,niño';

  @override
  String get helpRainMmQ => '¿Qué son los mm de lluvia?';

  @override
  String get helpRainMmA =>
      'Es cuánta agua cae. 1 mm es como si se juntara una capa de agua de 1 milímetro sobre tu chacra. Con 40 mm en un día ya es lluvia fuerte: mejor no abonar ni fumigar ese día.';

  @override
  String get helpRainMmK => 'mm,milimetro,cuanta lluvia,cuanto llueve';

  @override
  String get helpMoistureQ => '¿Cómo sé si mi tierra está mojada?';

  @override
  String get helpMoistureA =>
      'La estimamos con NASA POWER, datos de clima de la NASA que combinan satélites y modelos. Cubre toda la zona, así que puede ser un poco distinto a lo que ves en tu chacra.';

  @override
  String get helpMoistureK => 'humedad,mojada,humeda,seca,smap';

  @override
  String get helpWaterQ => '¿Qué significa el agua?';

  @override
  String get helpWaterA =>
      'Es el agua que necesitan los cultivos en una campaña, por cada hectárea. Se mide en metros cúbicos: 1 m³ es como un tanque de mil litros. Usar menos agua ayuda cuando el reservorio está bajo.';

  @override
  String get helpWaterK => 'agua,riego,m3,m³,metros cubicos,regar';

  @override
  String get helpSoilQ => '¿Qué quiere decir \"tu tierra: buena\"?';

  @override
  String get helpSoilA =>
      'Es cómo quedaría tu tierra después de 2 años. Si siembras lo mismo una y otra vez, la tierra se cansa y llegan más plagas. Si cambias de cultivo y pones frejol o menestra, la tierra descansa y mejora.';

  @override
  String get helpSoilK => 'tierra,suelo,cansada,buena,regular';

  @override
  String get helpDeadlineQ => '¿Por qué tengo que decidir antes de una fecha?';

  @override
  String get helpDeadlineA =>
      'Porque hay que preparar la tierra y conseguir la semilla antes de que empiece la siembra. Si esperas más, se te puede pasar la mejor época para ese cultivo.';

  @override
  String get helpDeadlineK => 'fecha,cuando,decidir,diciembre,antes';

  @override
  String get helpBlocksQ => '¿Cómo leo los bloques de colores?';

  @override
  String get helpBlocksA =>
      'Cada bloque es una campaña. Se lee de arriba hacia abajo: el primero es lo que siembras ahora y el último es dentro de 2 años. Cada cultivo tiene su color, así ves rápido si repites lo mismo.';

  @override
  String get helpBlocksK => 'color,colores,bloque,leo,leer,plan';

  @override
  String get helpRotateQ => '¿Por qué cambiar de cultivo?';

  @override
  String get helpRotateA =>
      'Cada cultivo saca de la tierra cosas distintas y atrae plagas distintas. Si cambias, la tierra se recupera y las plagas no se acumulan. Así tu cosecha aguanta mejor los años difíciles.';

  @override
  String get helpRotateK =>
      'rotacion,rotar,cambiar de cultivo,plagas,por que cambiar';

  @override
  String get helpGreenManureQ => '¿Qué es el abono verde?';

  @override
  String get helpGreenManureA =>
      'Es una planta que se siembra para no cosecharla: se deja en la tierra para que se descomponga y la alimente. Es como darle descanso y comida a tu chacra al mismo tiempo.';

  @override
  String get helpGreenManureK => 'abono,verde,cobertura,descanso';

  @override
  String get helpAlertsQ => '¿Cuándo me llegan los avisos?';

  @override
  String get helpAlertsA =>
      'Te aviso cuando viene lluvia fuerte, cuando tu tierra está muy mojada o muy seca, y cuando cambia el pronóstico de los próximos meses. Si nada cambia, no te molesto.';

  @override
  String get helpAlertsK => 'aviso,alerta,notificacion,llegan,mensaje';

  @override
  String get helpListenQ => '¿Cómo escucho lo que dice Semi?';

  @override
  String get helpListenA =>
      'Toca \"Escuchar\" debajo de lo que digo y te lo leo en voz alta. Sube el volumen de tu celular.';

  @override
  String get helpListenK => 'escuchar,oir,voz,leer,audio,no veo,sonido';

  @override
  String get helpToDarkQ => 'Poner la pantalla oscura';

  @override
  String get helpToDarkA =>
      'Listo, puse la pantalla oscura. Cansa menos la vista de noche.';

  @override
  String get helpToLightQ => 'Poner la pantalla clara';

  @override
  String get helpToLightA =>
      'Listo, puse la pantalla clara. Se ve mejor con sol.';

  @override
  String get helpThemeK => 'oscuro,oscura,claro,clara,noche,brillo,pantalla';

  @override
  String get helpToManualQ => 'Llenar yo mismo, sin preguntas';

  @override
  String get helpToManualA =>
      'Listo. Desde ahora llenas los datos en una sola pantalla. Si me necesitas, toca mi botón.';

  @override
  String get helpToAssistedQ => 'Que Semi me pregunte';

  @override
  String get helpToAssistedA =>
      'Listo. Desde ahora te acompaño en cada pantalla y te pregunto una cosa a la vez.';

  @override
  String get helpModeK =>
      'modo,manual,asistido,asistencia,formulario,preguntas';

  @override
  String get helpFarmQ => 'Cambiar los datos de mi chacra';

  @override
  String get helpFarmA =>
      'Te vuelvo a preguntar por tu chacra. Lo demás se queda igual.';

  @override
  String get helpFarmK => 'datos,corregir,me equivoque,editar,chacra,parcela';

  @override
  String get helpLanguageQ => 'Cambiar el idioma';

  @override
  String get helpLanguageA => 'Elige el idioma en el que quieres que te hable.';

  @override
  String get helpLanguageK => 'idioma,lengua,ingles,quechua,español,runasimi';

  @override
  String get helpLanguageAction => 'Elegir idioma';

  @override
  String get simTitle => 'Prueba tu propio plan';

  @override
  String get recoOverline => 'Te recomiendo';

  @override
  String get stripNext => 'Próxima siembra';

  @override
  String get stripLater => 'En 2 años';

  @override
  String get recoSoil => 'Tu tierra';

  @override
  String waterLess(String percent) {
    return '$percent menos';
  }

  @override
  String get waterSimilar => 'Parecida';

  @override
  String recoNote(String priority, String crop) {
    return 'Pensando en: $priority. Comparado con seguir con $crop.';
  }

  @override
  String get whyTitle => '¿Por qué?';

  @override
  String get whyConfidence =>
      'Es lo que más veces funciona en años así, pero el clima puede cambiar.';

  @override
  String semiPlantSay(String priority, String rotation) {
    return 'Pensando en $priority, te recomiendo $rotation. Abajo te explico por qué.';
  }

  @override
  String get semiRotationSay =>
      'Aquí comparas lo que siembras hoy con otras dos opciones. Toca \"Ver por qué\" en cada una. Y si quieres, arma tu propio plan.';

  @override
  String get soilTodayOverline => 'Tu tierra hoy';

  @override
  String soilReason(int count, String crop) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lleva $count siembras seguidas de $crop.',
      one: 'La última siembra fue de $crop.',
    );
    return '$_temp0';
  }

  @override
  String get howDoIKnow => '¿Cómo lo sé?';

  @override
  String compareSubtitle(int count, String years) {
    return 'Para las próximas $count siembras ($years), en el escenario de clima que estás viendo.';
  }

  @override
  String get optionCurrentLabel => 'Si sigues como ahora';

  @override
  String get optionRecommendedLabel => 'La que te recomiendo';

  @override
  String get optionOtherLabel => 'Otra opción';

  @override
  String get optionMineLabel => 'La que tú armaste';

  @override
  String get seeWhy => 'Ver por qué';

  @override
  String get fichaWhy => 'Por qué se sugiere';

  @override
  String get fichaEvidence => 'Qué lo respalda';

  @override
  String get fichaUnknowns => 'Lo que no sabemos';

  @override
  String get fichaCheck => 'Revísalo con tu técnico';

  @override
  String get rotationGuideNote =>
      'Esto es una guía, no una orden. Revisa las opciones con tu técnico.';

  @override
  String get deleteAll => 'Borrar todo y empezar de nuevo';

  @override
  String get deleteAllConfirm => 'Toca otra vez para borrar tus datos';

  @override
  String get settingsModeAssistedNote =>
      'Semi te explica cada pantalla y te hace las preguntas una por una.';

  @override
  String get settingsModeManualNote =>
      'Tú llenas tus datos en una pantalla. Semi solo aparece si le preguntas.';

  @override
  String semiAlertsImportant(String title) {
    return 'El más importante: $title.';
  }

  @override
  String get climateMore => 'Ver más del clima';

  @override
  String get whyMore => '¿Por qué te lo recomiendo?';

  @override
  String get otherOptionsMore => 'Ver las otras opciones';

  @override
  String get sampleDataBanner =>
      'Datos de ejemplo: no son mediciones reales de tu chacra';

  @override
  String get waterTitle => 'Agua en tu zona';

  @override
  String get waterLevelLow => 'Poca agua';

  @override
  String get waterLevelMedium => 'Agua como en un año común';

  @override
  String get waterLevelHigh => 'Más agua que de costumbre';

  @override
  String waterSemantics(String level) {
    return 'Agua en tu zona: $level';
  }

  @override
  String waterSource(String start, String end) {
    return 'Lluvia y humedad de la tierra de $start a $end, comparadas con los mismos meses de los 10 años anteriores. Datos de la NASA (NASA POWER).';
  }

  @override
  String get loadingSatellite =>
      'Estoy mirando tu chacra con los datos de los satélites de la NASA. La primera vez puede tardar hasta un minuto.';

  @override
  String yearsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count años',
      one: '1 año',
    );
    return '$_temp0';
  }
}
