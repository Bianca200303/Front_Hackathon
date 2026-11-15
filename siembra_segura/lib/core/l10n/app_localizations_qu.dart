// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Quechua (`qu`).
class AppLocalizationsQu extends AppLocalizations {
  AppLocalizationsQu([String locale = 'qu']) : super(locale);

  @override
  String get appTitle => 'Siembra Segura';

  @override
  String get tabClimate => 'Pacha';

  @override
  String get tabWhatToPlant => 'Ima tarpuy';

  @override
  String get tabRotation => 'Muyuchiy';

  @override
  String get tabAlerts => 'Willakuy';

  @override
  String get tabAlertsUnreadSemantics => 'Willakuykuna, musuq willakuykuna kan';

  @override
  String get actionBack => 'Kutiy';

  @override
  String get actionDone => 'Chayllam';

  @override
  String get actionUndo => 'Deshacer';

  @override
  String get actionRetry => 'Musuqmanta';

  @override
  String get actionListen => 'Uyariy';

  @override
  String get actionListenSemantics => 'Kay pantallapi kaqta uyariy';

  @override
  String get actionChange => 'Tikray';

  @override
  String get actionCompareOptions => 'Comparar con otras opciones';

  @override
  String get actionWhenToPlant => '¿Cuándo siembro?';

  @override
  String get actionSeeMyRecommendation => 'Ver mi recomendación';

  @override
  String get farmTitle => 'Chakraykimanta';

  @override
  String get climateTitle => 'Wayq\'oykipi pacha';

  @override
  String get recommendationTitle => '¿Imatataq tarpuyman?';

  @override
  String get plantingScheduleTitle => '¿Haykapitaq tarpusaq?';

  @override
  String get rotationTitle => 'Tarpuy muyuchiy';

  @override
  String get alertsTitle => 'Willakuykuna';

  @override
  String get alertMessageTitle => 'Willakuy';

  @override
  String get loading => 'Suyariy…';

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
      'Mana internet kanchu. Señalniykita qhawariy, hinaspa musuqmanta ruray.';

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
  String get scenarioHeavyRains => 'Sinchi para';

  @override
  String get scenarioNormal => 'Normal';

  @override
  String get scenarioDry => 'Ch\'aki';

  @override
  String get scenarioOptionHeavyRains => 'Con lluvias';

  @override
  String get scenarioPhraseHeavyRains => 'un año con lluvias fuertes';

  @override
  String get scenarioPhraseNormal => 'un año normal';

  @override
  String get scenarioPhraseDry => 'un año seco';

  @override
  String get soilVeryTired => 'Ancha sayk\'usqa';

  @override
  String get soilTired => 'Sayk\'usqa';

  @override
  String get soilRegular => 'Chawpi';

  @override
  String get soilGood => 'Allin';

  @override
  String soilWithLabel(String condition) {
    return 'Allpa: $condition';
  }

  @override
  String get soilImpactImproves => 'mejora';

  @override
  String get soilImpactImprovesALot => 'mejora mucho';

  @override
  String farmGreeting(String name) {
    return 'Napaykullayki, $name';
  }

  @override
  String get farmSatelliteCaption => 'Foto de satélite (NASA)';

  @override
  String get farmMapSemantics => 'Vista satelital de la parcela marcada';

  @override
  String get farmValley => 'Wayq\'o';

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
  String get farmRestrictionsQuestion => '¿Hay algo que no puedas hacer?';

  @override
  String farmNarration(String name, String crop) {
    return 'Hola $name. Por el satélite creemos que la última campaña sembraste $crop. Si no es así, toca el cultivo correcto. Luego dinos qué te importa más esta campaña: que el clima no malogre tu cosecha, cuidar tu agua o recuperar tu tierra.';
  }

  @override
  String get weatherSunny => 'Inti';

  @override
  String get weatherCloudy => 'Phuyu';

  @override
  String get weatherRain => 'Para';

  @override
  String get weatherModerateRain => 'Chawpi para';

  @override
  String get weatherHeavyRain => 'Sinchi para';

  @override
  String get weatherHeavyRainShort => 'Sinchi';

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
  String get climateThisWeek => 'Kay semana';

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
  String get outcomeExpected => 'Cosecha esperada:';

  @override
  String outcomeExpectedValue(String percent) {
    return '$percent de una buena campaña';
  }

  @override
  String get outcomeWorst => 'En un mal año:';

  @override
  String outcomeWorstValue(String percent) {
    return 'baja a $percent';
  }

  @override
  String get outcomeIfNormal => 'Si al final no llueve tanto:';

  @override
  String outcomeIfNormalValue(String percent) {
    return 'igual cosechas $percent';
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
    String harvest,
    String worst,
    String soil,
    String repeatWarning,
  ) {
    return 'Lo más probable en tu valle hasta $month son $scenario, con $probability de probabilidad. Pensando en $priority, te recomendamos $rotation. Se espera cosechar $harvest de una buena campaña; en un mal año, $worst. Tu tierra $soil. $repeatWarning';
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
  String get metricExpectedHarvest => 'Cosecha esperada';

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

  @override
  String get semiAvatarSemantics => 'Semi, chakra yanapaqniyki';

  @override
  String get appModeSwitchSemantics => 'Imayna llamk\'achiy';

  @override
  String get appModeAssistedTitle => 'Yanapaywan';

  @override
  String get appModeManualTitle => 'Kikiyki huntay';

  @override
  String get semiFarmGuide =>
      '¡Napaykullayki! Ñuqam Semi kani. Willaway qayna kutipi ima tarpusqaykita, imatataq aswanta munanki. Chaywan yanapasqayki.';

  @override
  String get semiClimateGuide =>
      'NASA-q satelitenkunawan hanaq pachata qhawarqani. Kaypi willasqayki chakraykipaq pacha imayna hamuchkasqanta.';

  @override
  String get semiRecommendationGuide =>
      'Allpaykiwan pachawan qhawaspa, kaymi aswan allin tarpunaykipaq. Sapa akllanata llapiy imarayku kasqanta rikunaykipaq.';

  @override
  String get semiPlantingScheduleGuide =>
      'Allin pachapi tarpuyqa ancham yanapan. Kaypi rikunki haykapi tarpunaykita.';

  @override
  String get semiRotationGuide =>
      'Sapa tarpuypi hukniray tarpuyqa allpatam samachin. Qhaway imaynam allpayki kanman sapa akllanawan.';

  @override
  String get semiAlertsGuide =>
      'Kaypi willasqayki sinchi para, rupay utaq plagakuna hamuptin. ¡Sapa kuti qhawariy!';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsTooltip => 'Ajustes: modo, idioma y tu parcela';

  @override
  String get settingsModeTitle => 'Cómo quieres usar la app';

  @override
  String get settingsLanguageTitle => 'Simi';

  @override
  String get settingsEditFarm => 'Cambiar los datos de mi parcela';

  @override
  String languageAutomatic(String language) {
    return 'Kikinmanta: $language';
  }

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageQuechua => 'Runasimi';

  @override
  String get languageQuechuaDraftNote =>
      'El quechua está en revisión: lo que falta traducir se muestra en español.';

  @override
  String languageButton(String language) {
    return 'Simi: $language';
  }

  @override
  String get welcomeTitle => 'Napaykullayki, Semi kani';

  @override
  String get welcomeBody =>
      'Yanapasqayki ima tarpunaykita akllanaykipaq, allpaykita yakuykitapas waqaychanaykipaq.';

  @override
  String get welcomeAiNote => 'Semi es un personaje creado con IA';

  @override
  String get welcomeQuestion => '¿Imaynatataq qallariyta munanki?';

  @override
  String get welcomeAssistedTitle => 'Semi tapuwachun';

  @override
  String get welcomeAssistedBody =>
      'Yanapaywan: huch\'uy tapukuykunata sapankamanta tapusqayki, tukuytam willasqayki.';

  @override
  String get welcomeManualTitle => 'Kikiy huntasaq';

  @override
  String get welcomeManualBody =>
      'Kikiyki huntay: tukuy huk pantallallapi, utqaylla, app-ta riqsispaqa.';

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
  String get themeSystem => 'Kikinmanta';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSwitchSemantics => 'Apariencia de la pantalla';

  @override
  String get chatTitle => 'Semiwan rimanakuspa';

  @override
  String get chatSubtitle => 'Huch\'uy tapukuykunata tapusqayki';

  @override
  String chatProgressSemantics(int current, int total) {
    return 'Pregunta $current de $total';
  }

  @override
  String get chatThinkingSemantics => 'Semi está pensando';

  @override
  String chatYouSaid(String answer) {
    return 'Qam: $answer';
  }

  @override
  String chatParcelQuestion(String valley, String area) {
    return '¡Hola! Encontré tu chacra en $valley. Mide $area hectáreas. ¿Es esta?';
  }

  @override
  String get chatParcelWhy =>
      'La veo en las fotos del satélite: sus bordes, surcos y caminos.';

  @override
  String get chatParcelYes => 'Arí, chakraymi';

  @override
  String get chatParcelNo => 'Manam, hukmi';

  @override
  String get chatParcelNoReply =>
      'Gracias por decirme. Pronto podrás marcarla en el mapa. Por ahora seguimos con esta.';

  @override
  String chatLastCropQuestion(String crop) {
    return 'Miré cómo creció lo verde en tu chacra la última vez. Parece que sembraste $crop. ¿Es así?';
  }

  @override
  String get chatLastCropWhy =>
      'Cada cultivo crece distinto. Si me corriges, aprendo y te ayudo mejor a ti y a tus vecinos.';

  @override
  String chatLastCropYes(String crop) {
    return 'Arí, $crop';
  }

  @override
  String chatLastCropNo(String crop) {
    return 'Manam, $crop karqan';
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
  String get chatRestrictionNone => 'Manam imapas';

  @override
  String get chatDone => '¡Chayllam! Planniykiqa kachkanñam.';

  @override
  String get actionSeePlan => 'Planniyta qhaway';

  @override
  String get farmParcelLabel => 'Chakrayki';

  @override
  String farmParcelSummary(String area, String valley, String source) {
    return '$area ha en $valley, riego de $source';
  }

  @override
  String get farmParcelSource => 'Marcada con fotos de satélite de la NASA';

  @override
  String get farmSatelliteBadge => 'Satelite';

  @override
  String get helpButton => 'Yanapay';

  @override
  String get helpButtonSemantics => 'Preguntarle a Semi';

  @override
  String get helpTitle => 'Semita tapuy';

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
  String get helpProbableQ => '¿Qué quiere decir \"lo más probable\"?';

  @override
  String get helpProbableA =>
      'Miramos cómo vino la lluvia en tu valle en años parecidos a este. \"Lo más probable\" es lo que pasó más veces. No es seguro: por eso también te muestro las otras posibilidades.';

  @override
  String get helpProbableK => 'probable,seguro,acierta,porcentaje,posibilidad';

  @override
  String get helpSourceQ => '¿De dónde sale el pronóstico?';

  @override
  String get helpSourceA =>
      'La lluvia de esta semana viene del pronóstico del día. Lo de los próximos meses lo calculamos con satélites de la NASA: lluvia (GPM), calor (NASA POWER) y humedad de la tierra (SMAP) en tu valle. También revisamos los comunicados del ENFEN sobre El Niño.';

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
  String get helpMoistureQ =>
      '¿Cómo sabe el satélite si mi tierra está mojada?';

  @override
  String get helpMoistureA =>
      'El satélite SMAP de la NASA mide la humedad de la tierra desde el espacio, cada pocos días. Mide toda la zona, así que puede ser un poco distinto a lo que ves en tu chacra.';

  @override
  String get helpMoistureK => 'humedad,mojada,humeda,seca,smap';

  @override
  String get helpHarvestQ => '¿Qué es la cosecha esperada?';

  @override
  String get helpHarvestA =>
      'Es cuánto se espera cosechar comparado con una buena campaña de ese cultivo en tu valle. 100% sería una cosecha completa. Si sale menos, es porque el clima o la tierra le pueden quitar algo. La calculamos con el verdor que vieron los satélites en años parecidos.';

  @override
  String get helpHarvestK => 'cosecha,rinde,rendimiento,produccion,esperada';

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
  String get helpLanguageQ => 'Simita tikray';

  @override
  String get helpLanguageA => 'Elige el idioma en el que quieres que te hable.';

  @override
  String get helpLanguageK => 'idioma,lengua,ingles,quechua,español,runasimi';

  @override
  String get helpLanguageAction => 'Elegir idioma';

  @override
  String get simTitle => 'Kikiyki planniykita churay';

  @override
  String get simIntro =>
      'Toca una campaña para elegir qué sembrar. Luego mira cómo te iría.';

  @override
  String simClimateNote(String scenario) {
    return 'Primera campaña: $scenario. Después, años normales.';
  }

  @override
  String simSlotSemantics(String period, String crop) {
    return '$period: $crop. Toca para cambiar';
  }

  @override
  String simPickTitle(String period) {
    return '¿Qué siembras en $period?';
  }

  @override
  String simCropUnavailable(String reason) {
    return 'No disponible: $reason';
  }

  @override
  String get simRun => 'Ver cómo te iría';

  @override
  String simHarvestStep(String percent) {
    return 'Cosecha $percent';
  }

  @override
  String get simGreenManureStep => 'Abona la tierra';

  @override
  String get simResultTitle => 'Así te iría con tu plan';

  @override
  String simCompare(String harvest, String water, String soil) {
    return 'Con el plan recomendado: cosecha $harvest, agua $water y tierra $soil.';
  }

  @override
  String simNarration(String soil, String harvest, String water) {
    return 'Con tu plan, tu tierra queda $soil y cosecharías $harvest de una buena campaña, en promedio. Usarías $water de agua por hectárea.';
  }

  @override
  String get simReset => 'Volver al plan recomendado';

  @override
  String get simWaterTotal => 'Agua en 2 años';

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
    return 'Lleva $count siembras seguidas de $crop.';
  }

  @override
  String get howDoIKnow => '¿Cómo lo sé?';

  @override
  String get compareSubtitle =>
      'Para las próximas 4 siembras (2 años), con el clima más probable.';

  @override
  String get optionCurrentLabel => 'Si sigues como ahora';

  @override
  String get optionRecommendedLabel => 'La que te recomiendo';

  @override
  String get optionOtherLabel => 'Otra opción';

  @override
  String get optionMineLabel => 'La que tú armaste';

  @override
  String get metricHarvestShort => 'Cosecha';

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
  String get simPickHint =>
      'Toca un cultivo y luego la siembra donde lo quieres.';

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
}
