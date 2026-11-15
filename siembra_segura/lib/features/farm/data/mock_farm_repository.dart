import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/data/mock_text.dart';

/// Datos de ejemplo de la referencia (mvp.html).
class MockFarmRepository implements FarmRepository {
  /// Crea el repositorio; [latency] simula la espera de la red y
  /// [language] es el idioma de los textos.
  const MockFarmRepository({
    this.latency = Duration.zero,
    this.language = AppLanguage.spanish,
  });

  /// Espera simulada antes de responder.
  final Duration latency;

  /// Idioma de los textos de ejemplo.
  final AppLanguage language;

  @override
  Future<Farm> getFarm() async {
    await Future<void>.delayed(latency);
    final t = MockText(language);
    return Farm(
      farmerName: 'Doña Rosa',
      valleyName: 'Medio Piura',
      areaHectares: 3.2,
      irrigationSource: 'Poechos',
      inferredLastCrop: t.crop(MockCatalog.rice),
      lastCropOptions: [
        for (final crop in const [
          MockCatalog.rice,
          MockCatalog.maize,
          MockCatalog.cotton,
          MockCatalog.bean,
          MockCatalog.otherCrop,
        ])
          t.crop(crop),
      ],
    );
  }
}
