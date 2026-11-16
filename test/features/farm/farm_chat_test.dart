import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/data/in_memory_campaign_preferences_store.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';

import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> startChat(WidgetTester tester, {Size? size}) async {
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
      screenSize: size ?? const Size(430, 2400),
    );
    await tester.tapText(l10n.welcomeAssistedTitle);
  }

  testWidgets('Semi pregunta una cosa a la vez y guarda las respuestas', (
    tester,
  ) async {
    final store = InMemoryCampaignPreferencesStore();
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
      preferencesStore: store,
    );
    await tester.tapText(l10n.welcomeAssistedTitle);

    expect(find.text(l10n.chatTitle), findsOneWidget);
    expect(find.text(l10n.chatParcelQuestion('Valle del Chira')), findsOne);
    await tester.tapText(l10n.chatParcelYes);

    expect(find.text(l10n.chatLastCropQuestion('arroz')), findsOneWidget);
    // Lo del satélite primero; se puede corregir.
    expect(find.text(l10n.chatLastCropYes('arroz')), findsOneWidget);
    await tester.tapText(l10n.chatLastCropNo('maíz'));
    // Lo que respondió queda a la vista.
    expect(find.text(l10n.chatLastCropNo('maíz')), findsOneWidget);

    await tester.tapText(MockCatalog.saveWater.name);
    await tester.tapText(MockCatalog.lowWater.name);

    expect(find.text(l10n.chatDone), findsOneWidget);
    expect(store.load()?.lastCropId, MockCatalog.maize.id);
    expect(store.load()?.priorityId, MockCatalog.saveWater.id);
    expect(store.load()?.restrictionIds, {MockCatalog.lowWater.id});

    await tester.tapText(l10n.actionSeePlan);
    expect(find.text(l10n.climateTitle), findsOneWidget);
  });

  testWidgets('si la chacra no es la suya, Semi lo agradece y sigue', (
    tester,
  ) async {
    await startChat(tester);

    await tester.tapText(l10n.chatParcelNo);

    expect(find.textContaining(l10n.chatParcelNoReply), findsOneWidget);
    expect(find.textContaining(l10n.chatLastCropQuestion('arroz')), findsOne);
  });

  testWidgets('Semi piensa un momento antes de hablar', (tester) async {
    await tester.pumpSiembraSeguraApp(appModeStore: InMemoryAppModeStore());
    await tester.tap(find.text(l10n.welcomeAssistedTitle));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.bySemanticsLabel(l10n.chatThinkingSemantics), findsOneWidget);
    expect(find.text(l10n.chatParcelYes), findsNothing);

    await tester.pumpAndSettle();
    expect(find.text(l10n.chatParcelYes), findsOneWidget);
  });

  testWidgets('"Escuchar" lee la pregunta y por qué la hace', (tester) async {
    final speech = await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
    );
    await tester.tapText(l10n.welcomeAssistedTitle);
    await tester.tapText(l10n.chatParcelYes);

    await tester.tapText(l10n.actionListen);

    expect(
      speech.spoken.last,
      '${l10n.chatLastCropQuestion('arroz')} ${l10n.chatLastCropWhy}',
    );
  });

  testWidgets('en modo asistido, Ajustes abre la conversación y vuelve', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(AppMode.assisted),
    );
    await tester.tapText(l10n.actionSeePlan);
    await tester.tapTab(l10n.tabRotation);
    await tester.tap(find.byTooltip(l10n.settingsTooltip));
    await tester.pumpAndSettle();
    await tester.tapText(l10n.settingsEditFarm);

    expect(find.text(l10n.chatTitle), findsOneWidget);
    await tester.tapText(l10n.chatParcelYes);
    await tester.tapText(l10n.chatLastCropYes('arroz'));
    await tester.tapText(MockCatalog.lowerClimateRisk.name);
    await tester.tapText(l10n.chatRestrictionNone);
    await tester.tapText(l10n.actionSeePlan);

    expect(find.text(l10n.rotationTitle), findsOneWidget);
  });

  testWidgets('en modo manual, Ajustes abre el formulario', (tester) async {
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(AppMode.manual),
    );
    await tester.tapText(l10n.actionSeePlan);
    await tester.tap(find.byTooltip(l10n.settingsTooltip));
    await tester.pumpAndSettle();
    await tester.tapText(l10n.settingsEditFarm);

    expect(find.text(l10n.farmTitle), findsOneWidget);
    expect(find.text(l10n.chatTitle), findsNothing);
  });

  testWidgets('como en el prototipo, el globo va arriba y Semi debajo', (
    tester,
  ) async {
    await startChat(tester, size: const Size(1280, 800));

    final semi = tester.getCenter(
      find.bySemanticsLabel(l10n.semiAvatarSemantics),
    );
    final question = tester.getCenter(
      find.text(l10n.chatParcelQuestion('Valle del Chira')),
    );
    expect(question.dy, lessThan(semi.dy));
    expect(find.byType(NavigationRail), findsNothing);
  });
}
