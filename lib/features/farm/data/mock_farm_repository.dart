import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';

/// Datos de ejemplo de la referencia (mvp.html).
class MockFarmRepository implements FarmRepository {
  /// Crea el repositorio; [latency] simula la espera de la red.
  const MockFarmRepository({this.latency = Duration.zero});

  /// Espera simulada antes de responder.
  final Duration latency;

  @override
  Future<Farm> getFarm() async {
    await Future<void>.delayed(latency);
    return const Farm(
      farmerName: 'Doña Rosa',
      valleyName: 'Medio Piura',
      irrigationSource: 'Poechos',
      inferredLastCrop: MockCatalog.rice,
      lastCropOptions: [
        MockCatalog.rice,
        MockCatalog.maize,
        MockCatalog.cotton,
        MockCatalog.bean,
        MockCatalog.otherCrop,
      ],
    );
  }
}
