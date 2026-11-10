import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';

/// Estado de la campaña compartido entre "Mi parcela", "Qué sembrar",
/// "¿Cuándo siembro?", "Rotación" y los avisos.
///
/// Hoy vive en memoria. Si debe persistirse en el dispositivo o en el
/// perfil del servidor (decisión B5), se inyecta un repositorio aquí sin
/// cambiar a quienes lo consumen.
class CampaignContextNotifier extends Notifier<CampaignContext> {
  @override
  CampaignContext build() => const CampaignContext();

  void selectLastCrop(Crop crop) {
    state = state.copyWith(lastCrop: crop);
  }

  void selectPriority(CampaignPriority priority) {
    state = state.copyWith(priority: priority);
  }

  void toggleRestriction(CampaignRestriction restriction) {
    final updated = {...state.restrictions};
    if (!updated.remove(restriction)) updated.add(restriction);
    state = state.copyWith(restrictions: Set.unmodifiable(updated));
  }

  void selectScenario(ClimateScenario scenario) {
    state = state.copyWith(selectedScenario: scenario);
  }
}

final campaignContextProvider =
    NotifierProvider<CampaignContextNotifier, CampaignContext>(
      CampaignContextNotifier.new,
    );
