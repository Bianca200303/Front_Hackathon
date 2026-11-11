import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/seasonal_outlook.dart';

/// Datos de ejemplo de la referencia (mvp.html).
class MockSeasonalOutlookRepository implements SeasonalOutlookRepository {
  /// Crea el repositorio; [latency] simula la espera de la red.
  const MockSeasonalOutlookRepository({this.latency = Duration.zero});

  /// Espera simulada antes de responder.
  final Duration latency;

  @override
  Future<SeasonalOutlook> getOutlook() async {
    await Future<void>.delayed(latency);
    return SeasonalOutlook(
      probabilities: const {
        ClimateScenario.heavyRains: 0.7,
        ClimateScenario.normal: 0.2,
        ClimateScenario.dry: 0.1,
      },
      horizonEnd: DateTime(2027, 3),
    );
  }
}
