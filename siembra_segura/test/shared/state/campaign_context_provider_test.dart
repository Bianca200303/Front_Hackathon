import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

void main() {
  late ProviderContainer container;
  CampaignContextNotifier notifier() =>
      container.read(campaignContextProvider.notifier);

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('arranca con los valores por defecto de la referencia', () {
    final state = container.read(campaignContextProvider);
    expect(state, const CampaignContext());
    expect(state.priority, CampaignPriority.maximizeProfit);
    expect(state.lastCrop, isNull);
    expect(state.selectedScenario, isNull);
  });

  test('actualiza prioridad, cultivo y escenario', () {
    notifier()
      ..selectPriority(CampaignPriority.saveWater)
      ..selectLastCrop(Crop.maize)
      ..selectScenario(ClimateScenario.dry);

    final state = container.read(campaignContextProvider);
    expect(state.priority, CampaignPriority.saveWater);
    expect(state.lastCrop, Crop.maize);
    expect(state.selectedScenario, ClimateScenario.dry);
  });

  test('alterna restricciones', () {
    notifier().toggleRestriction(CampaignRestriction.lowWater);
    expect(container.read(campaignContextProvider).restrictions, {
      CampaignRestriction.lowWater,
    });

    notifier().toggleRestriction(CampaignRestriction.lowWater);
    expect(container.read(campaignContextProvider).restrictions, isEmpty);
  });
}
