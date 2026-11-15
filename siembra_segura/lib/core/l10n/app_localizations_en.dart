// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Siembra Segura';

  @override
  String get tabClimate => 'Weather';

  @override
  String get tabWhatToPlant => 'What to plant';

  @override
  String get tabRotation => 'Rotation';

  @override
  String get tabAlerts => 'Alerts';

  @override
  String get tabAlertsUnreadSemantics => 'Alerts, there are new alerts';

  @override
  String get actionBack => 'Back';

  @override
  String get actionDone => 'Done';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionListen => 'Listen';

  @override
  String get actionListenSemantics => 'Listen to this screen';

  @override
  String get actionChange => 'Change';

  @override
  String get actionCompareOptions => 'Compare with other options';

  @override
  String get actionWhenToPlant => 'When do I plant?';

  @override
  String get actionSeeMyRecommendation => 'See my recommendation';

  @override
  String get farmTitle => 'Your field details';

  @override
  String get climateTitle => 'Your valley\'s outlook';

  @override
  String get recommendationTitle => 'What should I plant?';

  @override
  String get plantingScheduleTitle => 'When do I plant?';

  @override
  String get rotationTitle => 'Your rotation plan';

  @override
  String get alertsTitle => 'Alerts';

  @override
  String get alertMessageTitle => 'Message';

  @override
  String get loading => 'Loading…';

  @override
  String get emptyDefault => 'No information yet.';

  @override
  String get emptyRecommendation =>
      'We found no options with what you told us. Check what you can\'t do in Your plot.';

  @override
  String get emptyAlerts => 'You have no alerts right now.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get errorNetwork => 'No connection. Check your signal and try again.';

  @override
  String get errorTimeout => 'The answer took too long. Try again.';

  @override
  String get errorUnauthorized => 'Your session ended. Please sign in again.';

  @override
  String get errorServer => 'We had a problem. Try again later.';

  @override
  String get errorNotFound => 'We couldn\'t find this information.';

  @override
  String get errorUnexpected => 'Something went wrong. Try again.';

  @override
  String get errorSpeechUnavailable => 'Audio can\'t be played on this phone.';

  @override
  String get sampleDataDisclaimer => 'Sample figures.';

  @override
  String get perHectare => 'Per hectare.';

  @override
  String get guideDisclaimer =>
      'This app is a guide. The final decision is yours: talk these results over with your extension agent or the local agriculture office.';

  @override
  String get whatDoesItMean => 'What does it mean?';

  @override
  String get optionalLabel => '(optional)';

  @override
  String rotationNameSequence(String first, String second) {
    return '$first, then $second';
  }

  @override
  String rotationNameRepeated(String first, String second) {
    return '$first and $second';
  }

  @override
  String listJoin(String first, String second) {
    return '$first and $second';
  }

  @override
  String get scenarioHeavyRains => 'Heavy rains';

  @override
  String get scenarioNormal => 'Normal';

  @override
  String get scenarioDry => 'Dry';

  @override
  String get scenarioOptionHeavyRains => 'Rainy';

  @override
  String get scenarioPhraseHeavyRains => 'a year with heavy rains';

  @override
  String get scenarioPhraseNormal => 'a normal year';

  @override
  String get scenarioPhraseDry => 'a dry year';

  @override
  String get soilVeryTired => 'Very tired';

  @override
  String get soilTired => 'Tired';

  @override
  String get soilRegular => 'Fair';

  @override
  String get soilGood => 'Good';

  @override
  String soilWithLabel(String condition) {
    return 'Soil: $condition';
  }

  @override
  String get soilImpactImproves => 'improves';

  @override
  String get soilImpactImprovesALot => 'improves a lot';

  @override
  String farmGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get farmSatelliteCaption => 'Satellite image (NASA)';

  @override
  String get farmMapSemantics => 'Satellite view of the marked plot';

  @override
  String get farmValley => 'Valley';

  @override
  String get farmArea => 'Area';

  @override
  String get farmIrrigation => 'Irrigation from';

  @override
  String farmAreaValue(String area) {
    return '$area ha';
  }

  @override
  String get farmLastCropQuestion => 'What did you plant last season?';

  @override
  String farmLastCropHint(String crop) {
    return 'From the satellite we think it was $crop. If not, tap the right one.';
  }

  @override
  String get farmLastCropGroupSemantics => 'Last season\'s crop';

  @override
  String get farmPriorityQuestion => 'What matters most to you this season?';

  @override
  String get farmPriorityGroupSemantics => 'Priority';

  @override
  String get farmPriorityNote =>
      'You can change it later with the settings button on any screen.';

  @override
  String get farmResetAction => 'Go back to the suggested values';

  @override
  String get farmResetDone => 'Done: we\'re using the suggested values again.';

  @override
  String get farmRestrictionsQuestion => 'Is there anything you can\'t do?';

  @override
  String farmNarration(String name, String crop) {
    return 'Hello $name. From the satellite we think you planted $crop last season. If not, tap the right crop. Then tell us what matters most to you this season: keeping the weather from ruining your harvest, saving water or restoring your soil.';
  }

  @override
  String get weatherSunny => 'Sunny';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherModerateRain => 'Moderate rain';

  @override
  String get weatherHeavyRain => 'Heavy rain';

  @override
  String get weatherHeavyRainShort => 'Heavy';

  @override
  String climateToday(String weekday) {
    return 'Today, $weekday';
  }

  @override
  String climateTodayDetails(
    String probability,
    String rain,
    String temperature,
  ) {
    return '$probability chance · $rain · $temperature';
  }

  @override
  String get climateThisWeek => 'This week';

  @override
  String climateHeavyRainDay(String weekday) {
    return 'Heavy rain is expected on $weekday.';
  }

  @override
  String get climateAdviceLead => 'What to do:';

  @override
  String climateOutlookTitle(
    String month,
    String scenario,
    String probability,
  ) {
    return 'Until $month: $scenario ($probability)';
  }

  @override
  String get climateOutlookAction => 'Tap to see what you should plant.';

  @override
  String get climateComparisonTitle => 'Compared with a normal year';

  @override
  String get climateComparisonNote =>
      'The black line marks what is normal for this month. NASA satellite data (rain and soil moisture) and today\'s forecast.';

  @override
  String get anomalyRainfall => 'Rain this month';

  @override
  String get anomalyTemperature => 'Heat';

  @override
  String get anomalySoilMoisture => 'Your soil moisture';

  @override
  String anomalyTimesMore(String count) {
    return '$count times more';
  }

  @override
  String anomalyTimesLess(String count) {
    return '$count times less';
  }

  @override
  String anomalyDegreesMore(String degrees) {
    return '$degrees °C more';
  }

  @override
  String anomalyDegreesLess(String degrees) {
    return '$degrees °C less';
  }

  @override
  String get anomalyAsNormal => 'As usual';

  @override
  String anomalyBarSemantics(String metric, String status) {
    return '$metric: $status';
  }

  @override
  String get moistureVeryWet => 'Very wet';

  @override
  String get moistureWet => 'Wet';

  @override
  String get moistureNormal => 'Normal';

  @override
  String get moistureDry => 'Dry';

  @override
  String get climateExplainerSoilMoistureTerm => 'Soil moisture:';

  @override
  String get climateExplainerSoilMoistureBody =>
      'how much water your soil holds. NASA\'s SMAP satellite measures it.';

  @override
  String get climateExplainerNormalTerm => 'Normal:';

  @override
  String get climateExplainerNormalBody =>
      'the average of the last 20 years for this month in your valley.';

  @override
  String get climateExplainerSatelliteTerm => 'Satellite vs. your field:';

  @override
  String get climateExplainerSatelliteBody =>
      'the satellite measures the whole area from space, so it may differ a little from what you see in your field. That\'s why we ask you to confirm what you planted: your answer corrects the satellite.';

  @override
  String climateNarration(String condition, String probability) {
    return 'Today in your valley $condition is expected, with a $probability chance.';
  }

  @override
  String recommendationOutlookOverline(String month) {
    return 'YOUR VALLEY\'S OUTLOOK UNTIL $month';
  }

  @override
  String recommendationMostLikely(String scenario) {
    return 'Most likely: $scenario';
  }

  @override
  String get recommendationOutlookNote =>
      'Calculated with NASA satellite data (ocean, rain and soil). It matches ENFEN, Peru\'s El Niño committee.';

  @override
  String recommendationThinkingOf(String priority) {
    return 'With your goal in mind: $priority';
  }

  @override
  String get recommendationHeadline => 'WE RECOMMEND';

  @override
  String get recommendationIfHeavyRains =>
      'IF THE YEAR BRINGS HEAVY RAINS, YOUR BEST OPTION IS';

  @override
  String get recommendationIfNormal =>
      'IF THE YEAR IS NORMAL, YOUR BEST OPTION IS';

  @override
  String get recommendationIfDry => 'IF THE YEAR IS DRY, YOUR BEST OPTION IS';

  @override
  String get outcomeExpected => 'Expected harvest:';

  @override
  String outcomeExpectedValue(String percent) {
    return '$percent of a good season';
  }

  @override
  String get outcomeWorst => 'In a bad year:';

  @override
  String outcomeWorstValue(String percent) {
    return 'drops to $percent';
  }

  @override
  String get outcomeIfNormal => 'If it doesn\'t rain that much after all:';

  @override
  String outcomeIfNormalValue(String percent) {
    return 'you still harvest $percent';
  }

  @override
  String get outcomeWater => 'Water:';

  @override
  String get outcomeSoil => 'Your soil:';

  @override
  String recommendationRepeatOverline(String crop) {
    return 'IF YOU PLANT $crop AGAIN';
  }

  @override
  String get recommendationExploreScenarios => 'Explore other scenarios';

  @override
  String get recommendationExploreQuestion =>
      'What if the year turns out different from the most likely one?';

  @override
  String get scenarioSelectorSemantics => 'See another scenario';

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
    return 'The most likely outlook for your valley until $month is $scenario, with a $probability chance. With $priority in mind, we recommend $rotation. You can expect to harvest $harvest of a good season; in a bad year, $worst. Your soil $soil. $repeatWarning';
  }

  @override
  String get scheduleDecideBefore => 'Decide before';

  @override
  String get scheduleYourCalendar => 'Your calendar';

  @override
  String scheduleCalendarSemantics(String crop, int months) {
    return '$crop: $months months';
  }

  @override
  String scheduleRiskLegend(String months) {
    return '$months: risk of heavy rain. Keep your harvest close or protected.';
  }

  @override
  String get scheduleFallowLead =>
      'From August to November your field has no crop.';

  @override
  String get scheduleFallowBody =>
      'You can plant a cover crop (such as pigeon pea or sunn hemp) to protect and fertilize the soil.';

  @override
  String get scheduleWhyTitle => 'Why do we recommend it?';

  @override
  String scheduleReasonSoilRestores(int count, String crop) {
    return 'Your soil has had $count seasons of $crop; this rotation restores it.';
  }

  @override
  String scheduleReasonSoilHelps(int count, String crop) {
    return 'Your soil has had $count seasons of $crop; this rotation helps it recover.';
  }

  @override
  String scheduleReasonWater(String source, String crop) {
    return 'You use less water from $source than with $crop.';
  }

  @override
  String scheduleNarration(String rotation, String date, String instructions) {
    return '$rotation. Decide before $date. $instructions';
  }

  @override
  String get feedbackQuestion => 'When you plant, tell us what it was';

  @override
  String feedbackFollowed(String crop) {
    return 'I planted $crop';
  }

  @override
  String get feedbackOther => 'I planted something else';

  @override
  String get feedbackThanksTitle => 'Thank you!';

  @override
  String get feedbackThanksBody =>
      'Your answer makes the valley\'s recommendations better for everyone.';

  @override
  String get rotationSoilToday => 'YOUR SOIL TODAY';

  @override
  String rotationSoilGaugeSemantics(String condition) {
    return 'Condition of your soil: $condition';
  }

  @override
  String get rotationExplainerGreennessTerm => 'Greenness:';

  @override
  String get rotationExplainerGreennessBody =>
      'NASA\'s Landsat satellite measures how green and strong your crop is (NDVI index). If it drops year after year, the soil is getting tired.';

  @override
  String get rotationExplainerOrganicMatterTerm => 'Organic matter:';

  @override
  String get rotationExplainerOrganicMatterBody =>
      'plant remains that feed the soil. It\'s an estimate (SoilGrids); a soil test would confirm it.';

  @override
  String rotationCompareTitle(int count) {
    return 'Compare $count options';
  }

  @override
  String rotationCompareSubtitle(String priority, String scenario) {
    return 'With $priority and $scenario in mind. Per hectare.';
  }

  @override
  String get optionCurrent => 'WHAT YOU PLANT TODAY';

  @override
  String get optionRecommended => 'RECOMMENDED';

  @override
  String get optionOther => 'ANOTHER OPTION';

  @override
  String get metricExpectedHarvest => 'Expected harvest';

  @override
  String get metricWater => 'Water';

  @override
  String get metricSoilInTwoYears => 'Soil in 2 years';

  @override
  String get factsheetToggle => 'See why, evidence and risks';

  @override
  String get factsheetWhy => 'WHY IT\'S SUGGESTED';

  @override
  String get factsheetEvidence => 'WHAT DATA SUPPORTS IT';

  @override
  String get factsheetBenefits => 'BENEFITS';

  @override
  String get factsheetUnknowns => 'WHAT WE DON\'T KNOW';

  @override
  String get factsheetRisks => 'CHECK WITH YOUR EXTENSION AGENT';

  @override
  String get rotationPlanTitle => 'Recommended plan: next seasons';

  @override
  String rotationPlanName(String rotation, String next) {
    return '$rotation, then $next.';
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
    return 'Your soil today is $soil, because it has had $count seasons of $crop in a row. We compared $options options. If you keep planting $current, in two years your soil will be $currentSoil. The recommended option is $rotation. Tap each option to see why we suggest it, what data supports it and what to check with your extension agent. Remember: this app is a guide, the decision is yours.';
  }

  @override
  String get alertsFooter =>
      'Alerts also arrive as text messages on your phone.';

  @override
  String alertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You have $count alerts.',
      one: 'You have one alert.',
      zero: 'You have no alerts.',
    );
    return '$_temp0';
  }

  @override
  String alertTimeToday(String time) {
    return 'Today, $time';
  }

  @override
  String get alertTimeYesterday => 'Yesterday';

  @override
  String alertMeta(String time, String source) {
    return '$time · $source';
  }

  @override
  String get messageChannel => 'Text message';

  @override
  String messageSentAt(String day, String time) {
    return '$day, $time';
  }

  @override
  String get messagePlayAudio => 'Play audio';

  @override
  String get messageInputLabel => 'Write your question';

  @override
  String get messageInputHint => 'Ask anything…';

  @override
  String get messageSendAudio => 'Send audio';

  @override
  String get messageChatComingSoon => 'You\'ll be able to ask questions soon.';

  @override
  String get semiAvatarSemantics => 'Semi, your field assistant';

  @override
  String get appModeSwitchSemantics => 'How to use the app';

  @override
  String get appModeAssistedTitle => 'Assisted';

  @override
  String get appModeManualTitle => 'Manual entry';

  @override
  String get semiFarmGuide =>
      'Hi! I\'m Semi. Tell me what you planted last season and what matters most to you. With that, I\'ll help you decide.';

  @override
  String get semiClimateGuide =>
      'I looked at the sky with NASA satellites. Here\'s how the weather is coming for your field.';

  @override
  String get semiRecommendationGuide =>
      'Given your soil and the weather, this is what suits you best. Tap each option to see why.';

  @override
  String get semiPlantingScheduleGuide =>
      'Planting at the right time makes a difference. Here you see when it suits you.';

  @override
  String get semiRotationGuide =>
      'Changing crops each season lets the soil rest. See how your soil would end up with each option.';

  @override
  String get semiAlertsGuide =>
      'Here I warn you about heavy rain, heat or pests. Check them often!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTooltip => 'Settings: mode, language and your plot';

  @override
  String get settingsModeTitle => 'How you want to use the app';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsEditFarm => 'Change my plot details';

  @override
  String languageAutomatic(String language) {
    return 'Automatic: $language';
  }

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageQuechua => 'Runasimi (Quechua)';

  @override
  String get languageQuechuaDraftNote =>
      'Quechua is under review: anything not yet translated is shown in Spanish.';

  @override
  String languageButton(String language) {
    return 'Language: $language';
  }

  @override
  String get welcomeTitle => 'Hi, I\'m Semi';

  @override
  String get welcomeBody =>
      'I help you decide what to plant to look after your soil and your water.';

  @override
  String get welcomeAiNote => 'Semi is a character created with AI';

  @override
  String get welcomeQuestion => 'How would you like to start?';

  @override
  String get welcomeAssistedTitle => 'Let Semi ask me';

  @override
  String get welcomeAssistedBody =>
      'Assisted mode: I ask you short questions, one at a time, and explain everything.';

  @override
  String get welcomeManualTitle => 'I\'ll fill it in myself';

  @override
  String get welcomeManualBody =>
      'Manual entry: everything on one screen, faster if you already know the app.';

  @override
  String get welcomeChangeLater => 'You can change this anytime in Settings.';

  @override
  String get themeToDark => 'Switch to dark mode';

  @override
  String get themeToLight => 'Switch to light mode';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get themeSystem => 'Automatic';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSwitchSemantics => 'Screen appearance';

  @override
  String get chatTitle => 'Talking with Semi';

  @override
  String get chatSubtitle => 'I\'ll ask you a few short questions';

  @override
  String chatProgressSemantics(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get chatThinkingSemantics => 'Semi is thinking';

  @override
  String chatYouSaid(String answer) {
    return 'You: $answer';
  }

  @override
  String chatParcelQuestion(String valley, String area) {
    return 'Hi! I found your field in $valley. It\'s $area hectares. Is this it?';
  }

  @override
  String get chatParcelWhy =>
      'I can see it in satellite images: its edges, furrows and paths.';

  @override
  String get chatParcelYes => 'Yes, that\'s my field';

  @override
  String get chatParcelNo => 'No, it\'s another one';

  @override
  String get chatParcelNoReply =>
      'Thanks for telling me. Soon you\'ll be able to mark it on the map. For now, let\'s go on with this one.';

  @override
  String chatLastCropQuestion(String crop) {
    return 'I looked at how the green grew in your field last time. It looks like you planted $crop. Is that right?';
  }

  @override
  String get chatLastCropWhy =>
      'Each crop grows differently. If you correct me, I learn and can help you and your neighbors better.';

  @override
  String chatLastCropYes(String crop) {
    return 'Yes, $crop';
  }

  @override
  String chatLastCropNo(String crop) {
    return 'No, it was $crop';
  }

  @override
  String get chatPriorityQuestion => 'What matters most to you this season?';

  @override
  String get chatPriorityWhy =>
      'With this, I sort the options by what you want.';

  @override
  String get chatRestrictionQuestion =>
      'Last question: is there anything you can\'t do?';

  @override
  String get chatRestrictionWhy =>
      'That way I won\'t recommend something that doesn\'t work for you.';

  @override
  String get chatRestrictionNone => 'Nothing, all good';

  @override
  String get chatDone => 'Done! I have your plan.';

  @override
  String get actionSeePlan => 'See my plan';

  @override
  String get farmParcelLabel => 'Your field';

  @override
  String farmParcelSummary(String area, String valley, String source) {
    return '$area ha in $valley, irrigated from $source';
  }

  @override
  String get farmParcelSource => 'Marked with NASA satellite images';

  @override
  String get farmSatelliteBadge => 'Satellite';

  @override
  String get helpButton => 'Help';

  @override
  String get helpButtonSemantics => 'Ask Semi';

  @override
  String get helpTitle => 'Ask Semi';

  @override
  String get helpClose => 'Close';

  @override
  String helpIntro(String topic) {
    return 'How can I help? You can ask me about $topic, change something in the app or see how it works.';
  }

  @override
  String get helpTopicClimate => 'the weather';

  @override
  String get helpTopicWhatToPlant => 'what to plant';

  @override
  String get helpTopicRotation => 'rotation';

  @override
  String get helpTopicAlerts => 'alerts';

  @override
  String get helpGroupMeaning => 'What it means';

  @override
  String get helpGroupChange => 'Change something';

  @override
  String get helpGroupHowTo => 'How it works';

  @override
  String helpYouAsked(String question) {
    return 'You asked: $question';
  }

  @override
  String get helpInputHint => 'Or type, for example: green manure';

  @override
  String get helpAsk => 'Ask';

  @override
  String get helpUnknown =>
      'Oops, I don\'t know that yet. Tap one of these questions and I\'ll explain.';

  @override
  String get helpProbableQ => 'What does \"most likely\" mean?';

  @override
  String get helpProbableA =>
      'We looked at how the rain came in your valley in years like this one. \"Most likely\" is what happened most often. It isn\'t certain: that\'s why I also show you the other possibilities.';

  @override
  String get helpProbableK => 'likely,sure,certain,percent,chance,probability';

  @override
  String get helpSourceQ => 'Where does the forecast come from?';

  @override
  String get helpSourceA =>
      'This week\'s rain comes from the daily forecast. For the coming months we use NASA satellites: rain (GPM), heat (NASA POWER) and soil moisture (SMAP) in your valley. We also check ENFEN\'s bulletins about El Niño.';

  @override
  String get helpSourceK => 'nasa,satellite,source,forecast,data,enfen,nino';

  @override
  String get helpRainMmQ => 'What are mm of rain?';

  @override
  String get helpRainMmA =>
      'It\'s how much water falls. 1 mm is like a layer of water 1 millimeter deep over your field. 40 mm in one day is already heavy rain: better not to fertilize or spray that day.';

  @override
  String get helpRainMmK => 'mm,millimeter,how much rain';

  @override
  String get helpMoistureQ => 'How does the satellite know if my soil is wet?';

  @override
  String get helpMoistureA =>
      'NASA\'s SMAP satellite measures soil moisture from space every few days. It measures the whole area, so it may differ a little from what you see in your field.';

  @override
  String get helpMoistureK => 'moisture,wet,dry,smap,humidity';

  @override
  String get helpHarvestQ => 'What is the expected harvest?';

  @override
  String get helpHarvestA =>
      'It\'s how much you can expect to harvest compared with a good season of that crop in your valley. 100% would be a full harvest. If it\'s less, it\'s because the weather or the soil may take some away. We estimate it from the greenness satellites saw in similar years.';

  @override
  String get helpHarvestK => 'harvest,yield,production,expected';

  @override
  String get helpWaterQ => 'What does the water mean?';

  @override
  String get helpWaterA =>
      'It\'s the water the crops need in a season, per hectare. It\'s measured in cubic meters: 1 m³ is like a 1,000-liter tank. Using less water helps when the reservoir is low.';

  @override
  String get helpWaterK => 'water,irrigation,m3,m³,cubic';

  @override
  String get helpSoilQ => 'What does \"your soil: good\" mean?';

  @override
  String get helpSoilA =>
      'It\'s how your soil would end up after 2 years. If you plant the same thing again and again, the soil gets tired and more pests come. If you change crops and add beans or pulses, the soil rests and gets better.';

  @override
  String get helpSoilK => 'soil,land,tired,good,fair';

  @override
  String get helpDeadlineQ => 'Why do I have to decide before a date?';

  @override
  String get helpDeadlineA =>
      'Because you need to prepare the soil and get the seed before planting starts. If you wait longer, you may miss the best time for that crop.';

  @override
  String get helpDeadlineK => 'date,when,decide,december,before,deadline';

  @override
  String get helpBlocksQ => 'How do I read the colored blocks?';

  @override
  String get helpBlocksA =>
      'Each block is a season. Read from top to bottom: the first is what you plant now and the last is 2 years from now. Each crop has its own color, so you can quickly see if you repeat the same one.';

  @override
  String get helpBlocksK => 'color,colors,block,read,plan';

  @override
  String get helpRotateQ => 'Why change crops?';

  @override
  String get helpRotateA =>
      'Each crop takes different things from the soil and attracts different pests. If you change, the soil recovers and pests don\'t build up. That way your harvest holds up better in hard years.';

  @override
  String get helpRotateK => 'rotation,rotate,change crops,pests,why change';

  @override
  String get helpGreenManureQ => 'What is green manure?';

  @override
  String get helpGreenManureA =>
      'It\'s a plant you sow but don\'t harvest: you leave it in the soil so it breaks down and feeds it. It\'s like giving your field rest and food at the same time.';

  @override
  String get helpGreenManureK => 'manure,green,cover crop,rest';

  @override
  String get helpAlertsQ => 'When do I get alerts?';

  @override
  String get helpAlertsA =>
      'I let you know when heavy rain is coming, when your soil is very wet or very dry, and when the forecast for the coming months changes. If nothing changes, I won\'t bother you.';

  @override
  String get helpAlertsK => 'alert,notification,message,warning';

  @override
  String get helpListenQ => 'How do I hear what Semi says?';

  @override
  String get helpListenA =>
      'Tap \"Listen\" under what I say and I\'ll read it aloud. Turn up your phone\'s volume.';

  @override
  String get helpListenK => 'listen,hear,voice,read,audio,sound';

  @override
  String get helpToDarkQ => 'Make the screen dark';

  @override
  String get helpToDarkA =>
      'Done, I made the screen dark. It\'s easier on the eyes at night.';

  @override
  String get helpToLightQ => 'Make the screen light';

  @override
  String get helpToLightA =>
      'Done, I made the screen light. It\'s easier to see in the sun.';

  @override
  String get helpThemeK => 'dark,light,night,brightness,screen';

  @override
  String get helpToManualQ => 'I\'ll fill it in myself';

  @override
  String get helpToManualA =>
      'Done. From now on you fill in your details on one screen. If you need me, tap my button.';

  @override
  String get helpToAssistedQ => 'Let Semi ask me';

  @override
  String get helpToAssistedA =>
      'Done. From now on I\'m with you on every screen and ask one thing at a time.';

  @override
  String get helpModeK => 'mode,manual,assisted,form,questions';

  @override
  String get helpFarmQ => 'Change my field details';

  @override
  String get helpFarmA =>
      'I\'ll ask you about your field again. Everything else stays the same.';

  @override
  String get helpFarmK => 'details,correct,mistake,edit,field,plot';

  @override
  String get helpLanguageQ => 'Change the language';

  @override
  String get helpLanguageA => 'Choose the language you want me to speak.';

  @override
  String get helpLanguageK => 'language,english,spanish,quechua,runasimi';

  @override
  String get helpLanguageAction => 'Choose language';

  @override
  String get simTitle => 'Try your own plan';

  @override
  String get simIntro =>
      'Tap a season to choose what to plant. Then see how it would go.';

  @override
  String simClimateNote(String scenario) {
    return 'First season: $scenario. After that, normal years.';
  }

  @override
  String simSlotSemantics(String period, String crop) {
    return '$period: $crop. Tap to change';
  }

  @override
  String simPickTitle(String period) {
    return 'What do you plant in $period?';
  }

  @override
  String simCropUnavailable(String reason) {
    return 'Not available: $reason';
  }

  @override
  String get simRun => 'See how it would go';

  @override
  String simHarvestStep(String percent) {
    return 'Harvest $percent';
  }

  @override
  String get simGreenManureStep => 'Feeds the soil';

  @override
  String get simResultTitle => 'This is how your plan would go';

  @override
  String simCompare(String harvest, String water, String soil) {
    return 'With the recommended plan: harvest $harvest, water $water and soil $soil.';
  }

  @override
  String simNarration(String soil, String harvest, String water) {
    return 'With your plan, your soil ends up $soil and you would harvest $harvest of a good season, on average. You would use $water of water per hectare.';
  }

  @override
  String get simReset => 'Back to the recommended plan';

  @override
  String get simWaterTotal => 'Water in 2 years';

  @override
  String get recoOverline => 'I recommend';

  @override
  String get stripNext => 'Next planting';

  @override
  String get stripLater => 'In 2 years';

  @override
  String get recoSoil => 'Your soil';

  @override
  String waterLess(String percent) {
    return '$percent less';
  }

  @override
  String get waterSimilar => 'About the same';

  @override
  String recoNote(String priority, String crop) {
    return 'With $priority in mind. Compared with keeping $crop.';
  }

  @override
  String get whyTitle => 'Why?';

  @override
  String get whyConfidence =>
      'It\'s what works most often in years like this, but the weather can change.';

  @override
  String semiPlantSay(String priority, String rotation) {
    return 'With $priority in mind, I recommend $rotation. I explain why below.';
  }

  @override
  String get semiRotationSay =>
      'Here you compare what you plant today with two other options. Tap \"See why\" on each one. And if you like, build your own plan.';

  @override
  String get soilTodayOverline => 'Your soil today';

  @override
  String soilReason(int count, String crop) {
    return '$count plantings of $crop in a row.';
  }

  @override
  String get howDoIKnow => 'How do I know?';

  @override
  String get compareSubtitle =>
      'For the next 4 plantings (2 years), with the most likely weather.';

  @override
  String get optionCurrentLabel => 'If you keep going as now';

  @override
  String get optionRecommendedLabel => 'The one I recommend';

  @override
  String get optionOtherLabel => 'Another option';

  @override
  String get optionMineLabel => 'The one you built';

  @override
  String get metricHarvestShort => 'Harvest';

  @override
  String get seeWhy => 'See why';

  @override
  String get fichaWhy => 'Why it\'s suggested';

  @override
  String get fichaEvidence => 'What supports it';

  @override
  String get fichaUnknowns => 'What we don\'t know';

  @override
  String get fichaCheck => 'Check it with your extension agent';

  @override
  String get simPickHint => 'Tap a crop, then the planting where you want it.';

  @override
  String get rotationGuideNote =>
      'This is a guide, not an order. Review the options with your extension agent.';

  @override
  String get deleteAll => 'Delete everything and start over';

  @override
  String get deleteAllConfirm => 'Tap again to delete your data';

  @override
  String get settingsModeAssistedNote =>
      'Semi explains each screen and asks you one question at a time.';

  @override
  String get settingsModeManualNote =>
      'You fill in your details on one screen. Semi only shows up if you ask.';

  @override
  String semiAlertsImportant(String title) {
    return 'The most important one: $title.';
  }

  @override
  String get climateMore => 'See more about the weather';

  @override
  String get whyMore => 'Why do I recommend it?';

  @override
  String get otherOptionsMore => 'See the other options';
}
