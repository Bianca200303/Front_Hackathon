import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/domain/campaign_preferences_store.dart';

/// Almacén de las preferencias de campaña.
///
/// No tiene valor por defecto: `main.dart` lo abre antes de arrancar y lo
/// inyecta con `overrideWithValue`; los tests inyectan
/// `InMemoryCampaignPreferencesStore`.
final campaignPreferencesStoreProvider = Provider<CampaignPreferencesStore>(
  (ref) => throw UnimplementedError(
    'campaignPreferencesStoreProvider debe inyectarse en el ProviderScope.',
  ),
);

/// Estado de la campaña compartido entre "Mi parcela", "Qué sembrar",
/// "¿Cuándo siembro?", "Rotación" y los avisos.
///
/// Arranca con lo que se guardó en el dispositivo y guarda cada cambio de
/// preferencia al instante, sin botón "Guardar".
class CampaignContextNotifier extends Notifier<CampaignContext> {
  CampaignPreferencesStore get _store =>
      ref.read(campaignPreferencesStoreProvider);

  @override
  CampaignContext build() =>
      ref.watch(campaignPreferencesStoreProvider).load() ??
      const CampaignContext();

  /// Corrige el cultivo de la última campaña.
  void selectLastCrop(String cropId) =>
      _updatePreferences(state.copyWith(lastCropId: cropId));

  /// Cambia lo que más le importa al agricultor.
  void selectPriority(String priorityId) =>
      _updatePreferences(state.copyWith(priorityId: priorityId));

  /// Activa o desactiva una restricción.
  void toggleRestriction(String restrictionId) {
    final updated = {...state.restrictionIds};
    if (!updated.remove(restrictionId)) updated.add(restrictionId);
    _updatePreferences(
      state.copyWith(restrictionIds: Set.unmodifiable(updated)),
    );
  }

  /// Corrige la superficie de la parcela, en hectáreas.
  void selectArea(double hectares) =>
      _updatePreferences(state.copyWith(areaHectares: hectares));

  /// Cambia la fecha en la que quiere sembrar.
  void selectPlantingDate(DateTime date) =>
      _updatePreferences(state.copyWith(plantingDate: date));

  /// Cambia las campañas seguidas con el mismo cultivo.
  void selectConsecutiveCampaigns(int campaigns) =>
      _updatePreferences(state.copyWith(consecutiveCampaigns: campaigns));

  /// Marca dónde está la parcela, en grados decimales.
  void selectFarmLocation({
    required double latitude,
    required double longitude,
  }) => _updatePreferences(
    state.copyWith(farmLatitude: latitude, farmLongitude: longitude),
  );

  /// Guarda la textura que el agricultor reconoció en su tierra; `null`
  /// vuelve a la que estima el satélite.
  void selectSoilTexture(SoilTexture? texture) => _updatePreferences(
    state.copyWith(soilTexture: texture, clearSoilTexture: texture == null),
  );

  /// Guarda la rotación que armó el agricultor; una lista vacía la quita.
  void selectCustomRotation(List<String> cropIds) => _updatePreferences(
    state.copyWith(customRotation: List.unmodifiable(cropIds)),
  );

  /// Explora otro escenario climático. No se guarda en el dispositivo.
  void selectScenario(ClimateScenario scenario) {
    state = state.copyWith(selectedScenario: scenario);
  }

  /// Vuelve a los valores sugeridos por los datos y borra lo guardado.
  ///
  /// Devuelve el estado anterior para poder ofrecer "Deshacer" con
  /// [restore].
  CampaignContext reset() {
    final previous = state;
    state = const CampaignContext();
    unawaited(_guard(_store.clear));
    return previous;
  }

  /// Recupera un estado anterior (p. ej., el que devolvió [reset]).
  void restore(CampaignContext previous) => _updatePreferences(previous);

  void _updatePreferences(CampaignContext next) {
    state = next;
    unawaited(_guard(() => _store.save(next.preferencesOnly)));
  }

  /// Guardar es "mejor esfuerzo": si el almacenamiento falla, la app sigue
  /// funcionando con el estado en memoria.
  static Future<void> _guard(Future<void> Function() operation) async {
    try {
      await operation();
    } on Object catch (error) {
      debugPrint('No se pudieron guardar las preferencias: $error');
    }
  }
}

/// Decisiones vigentes del agricultor para esta campaña.
final campaignContextProvider =
    NotifierProvider<CampaignContextNotifier, CampaignContext>(
      CampaignContextNotifier.new,
    );

/// Hectáreas vigentes: las que indicó el agricultor o las sugeridas.
final selectedAreaHectaresProvider = Provider<double>(
  (ref) =>
      ref.watch(campaignContextProvider.select((c) => c.areaHectares)) ??
      CampaignContext.defaultAreaHectares,
);

/// Fecha de siembra vigente: la que eligió el agricultor o hoy.
final selectedPlantingDateProvider = Provider<DateTime>((ref) {
  final chosen = ref.watch(
    campaignContextProvider.select((c) => c.plantingDate),
  );
  return chosen ?? dateOnly(ref.watch(clockProvider)());
});

/// Campañas seguidas vigentes: las que indicó el agricultor o las
/// sugeridas.
final selectedConsecutiveCampaignsProvider = Provider<int>(
  (ref) =>
      ref.watch(
        campaignContextProvider.select((c) => c.consecutiveCampaigns),
      ) ??
      CampaignContext.defaultConsecutiveCampaigns,
);
