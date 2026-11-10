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
  String get actionRetry => 'Reintentar';

  @override
  String get actionListen => 'Escuchar';

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
  String get comingSoon => 'Próximamente';

  @override
  String get placeholderUnderConstruction => 'Pantalla en construcción.';

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
}
