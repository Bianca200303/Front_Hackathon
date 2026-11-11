import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/features/alerts/domain/alert.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Datos de ejemplo de la referencia (mvp.html), con fechas relativas a hoy.
class MockAlertsRepository implements AlertsRepository {
  /// Crea el repositorio; las fechas son relativas a [clock].
  const MockAlertsRepository({
    required this.clock,
    this.latency = Duration.zero,
  });

  /// Hora actual, para fechar los avisos de ejemplo.
  final Clock clock;

  /// Espera simulada antes de responder.
  final Duration latency;

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
    return [
      Alert(
        id: 'lluvia-fuerte',
        type: AlertType.rain,
        title: 'Lluvia fuerte el miércoles',
        body: 'Se esperan 40 mm. No abones ni apliques productos ese día.',
        receivedAt: _today.add(const Duration(hours: 6)),
        source: 'Pronóstico del día',
        destination: AlertDestination.climate,
        isRead: true,
      ),
      Alert(
        id: 'suelo-humedo',
        type: AlertType.soil,
        title: 'Tu suelo está muy húmedo',
        body: 'No riegues esta semana. Espera hasta el jueves para sembrar.',
        receivedAt: _today.subtract(const Duration(hours: 18)),
        source: 'Satélite NASA (humedad del suelo)',
        destination: AlertDestination.climate,
        isRead: true,
      ),
      Alert(
        id: _forecastChangeId,
        type: AlertType.forecastChange,
        title: 'Cambió el pronóstico de El Niño',
        body: 'Tu recomendación cambió de arroz a maíz. Toca para escuchar.',
        receivedAt: _forecastChangeSentAt,
        source: 'Comunicado ENFEN',
        destination: AlertDestination.message,
      ),
    ];
  }

  @override
  Future<AlertMessage> getMessage(String alertId) async {
    await Future<void>.delayed(latency);
    if (alertId != _forecastChangeId) throw NotFoundException(alertId);
    return AlertMessage(
      alertId: alertId,
      sentAt: _forecastChangeSentAt,
      headline: 'CAMBIÓ EL PRONÓSTICO',
      paragraphs: const [
        'Doña Rosa, el ENFEN anunció que El Niño vendría más fuerte.',
        'Para su parcela ya no le recomendamos **arroz**. Ahora le conviene '
            '**maíz y después frejol**.',
        'Tiene hasta el **15 de diciembre** para decidir.',
      ],
      audioDuration: const Duration(seconds: 42),
      relatedScenario: ClimateScenario.heavyRains,
    );
  }
}
