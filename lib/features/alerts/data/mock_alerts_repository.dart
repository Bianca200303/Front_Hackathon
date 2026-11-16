import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/features/alerts/domain/alert.dart';
import 'package:siembra_segura/shared/data/mock_text.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Datos de ejemplo de la referencia (mvp.html), con fechas relativas a hoy.
class MockAlertsRepository implements AlertsRepository {
  /// Crea el repositorio; las fechas son relativas a [clock].
  const MockAlertsRepository({
    required this.clock,
    this.latency = Duration.zero,
    this.language = AppLanguage.spanish,
  });

  /// Hora actual, para fechar los avisos de ejemplo.
  final Clock clock;

  /// Espera simulada antes de responder.
  final Duration latency;

  /// Idioma de los textos de ejemplo.
  final AppLanguage language;

  static const _forecastChangeId = 'enfen-pronostico';

  DateTime get _today {
    final now = clock();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _forecastChangeSentAt =>
      _today.subtract(const Duration(days: 2)).add(const Duration(hours: 7));

  @override
  Future<List<Alert>> getAlerts() async {
    await Future<void>.delayed(latency);
    final t = MockText(language);
    return [
      Alert(
        id: 'lluvia-fuerte',
        type: AlertType.rain,
        title: t('Lluvia fuerte el miércoles'),
        body: t('Se esperan 40 mm. No abones ni apliques productos ese día.'),
        receivedAt: _today.add(const Duration(hours: 6)),
        source: t('Pronóstico del día'),
        destination: AlertDestination.climate,
        isRead: true,
      ),
      Alert(
        id: 'suelo-humedo',
        type: AlertType.soil,
        title: t('Tu suelo está muy húmedo'),
        body: t('No riegues esta semana. Espera hasta el jueves para sembrar.'),
        receivedAt: _today.subtract(const Duration(hours: 18)),
        source: t('Aviso de ejemplo'),
        destination: AlertDestination.climate,
        isRead: true,
      ),
      Alert(
        id: _forecastChangeId,
        type: AlertType.forecastChange,
        title: t('Ejemplo: cambió el pronóstico de El Niño'),
        body: t(
          'Así te avisaremos si cambia tu recomendación. Toca para escuchar.',
        ),
        receivedAt: _forecastChangeSentAt,
        source: t('Aviso de ejemplo'),
        destination: AlertDestination.message,
      ),
    ];
  }

  @override
  Future<AlertMessage> getMessage(String alertId) async {
    await Future<void>.delayed(latency);
    if (alertId != _forecastChangeId) throw NotFoundException(alertId);
    final t = MockText(language);
    return AlertMessage(
      alertId: alertId,
      sentAt: _forecastChangeSentAt,
      headline: t('AVISO DE EJEMPLO'),
      paragraphs: [
        t(
          'Doña Rosa, este es un ejemplo de cómo te avisaremos cuando el ENFEN '
          'cambie su pronóstico de El Niño.',
        ),
        t(
          'Si vienen **lluvias fuertes**, te mostraremos qué te conviene '
          'sembrar en ese caso.',
        ),
        t('Toca el botón para verlo ahora.'),
      ],
      audioDuration: const Duration(seconds: 42),
      relatedScenario: ClimateScenario.heavyRains,
    );
  }
}
