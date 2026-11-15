import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// Deja exactamente las restricciones [restrictionIds] (la conversación
  /// con Semi pregunta una sola vez y reemplaza lo anterior).
  void setRestrictions(Set<String> restrictionIds) => _updatePreferences(
    state.copyWith(restrictionIds: Set.unmodifiable(restrictionIds)),
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
