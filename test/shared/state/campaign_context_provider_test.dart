import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';

void main() {
  late InMemoryCampaignPreferencesStore store;
  late ProviderContainer container;
  CampaignContextNotifier notifier() =>
      container.read(campaignContextProvider.notifier);
  CampaignContext state() => container.read(campaignContextProvider);

  ProviderContainer createContainer() => ProviderContainer(
    overrides: [campaignPreferencesStoreProvider.overrideWithValue(store)],
  );

  setUp(() {
    store = InMemoryCampaignPreferencesStore();
    container = createContainer();
  });
  tearDown(() => container.dispose());

  test('sin nada guardado arranca con todo sugerido', () {
    expect(state(), const CampaignContext());
    expect(state().hasNoPreferences, isTrue);
  });

  test('actualiza prioridad, cultivo y escenario', () {
    notifier()
      ..selectPriority('save-water')
      ..selectLastCrop('maize')
      ..selectScenario(ClimateScenario.dry);

    expect(state().priorityId, 'save-water');
    expect(state().lastCropId, 'maize');
    expect(state().selectedScenario, ClimateScenario.dry);
  });

  test('alterna restricciones', () {
    notifier().toggleRestriction('low-water');
    expect(state().restrictionIds, {'low-water'});

    notifier().toggleRestriction('low-water');
    expect(state().restrictionIds, isEmpty);
  });

  group('persistencia', () {
    test('guarda las preferencias pero no el escenario explorado', () {
      notifier()
        ..selectPriority('save-water')
        ..toggleRestriction('low-water')
        ..selectScenario(ClimateScenario.dry);

      expect(
        store.load(),
        const CampaignContext(
          priorityId: 'save-water',
          restrictionIds: {'low-water'},
        ),
      );
    });

    test('una nueva sesión arranca con lo guardado', () {
      notifier().selectLastCrop('cotton');
      container.dispose();

      container = createContainer();

      expect(state().lastCropId, 'cotton');
    });
  });

  group('restablecer', () {
    test('vuelve a los valores sugeridos y borra lo guardado', () {
      notifier()
        ..selectPriority('save-water')
        ..selectLastCrop('maize');

      notifier().reset();

      expect(state(), const CampaignContext());
      expect(store.load(), isNull);
    });

    test('"Deshacer" recupera lo anterior y lo vuelve a guardar', () {
      notifier().selectPriority('save-water');
      final previous = notifier().reset();

      notifier().restore(previous);

      expect(state().priorityId, 'save-water');
      expect(store.load()?.priorityId, 'save-water');
    });
  });
}
