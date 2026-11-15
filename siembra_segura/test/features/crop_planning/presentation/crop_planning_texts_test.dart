import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_context.dart';

import '../../../helpers/planning_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<Recommendation> recommendationFor([
    CampaignContext context = const CampaignContext(),
  ]) async => referenceGetRecommendation(
    data: await referencePlanningData(),
    outlook: await referenceOutlook(),
    catalog: referenceCatalog,
    context: context,
  );

  setUpAll(initTestLocale);

  test('nombres de rotaciones como en la referencia', () async {
    final recommendation = await recommendationFor();

    expect(recommendation.best.name(l10n), 'Maíz y después frejol');
    expect(recommendation.currentPractice.name(l10n), 'Arroz y arroz');
    expect(
      recommendation.longTermPlanName(l10n),
      'Maíz y después frejol y después algodón y menestra.',
    );
  });

  test('el titular depende de si es el escenario más probable', () async {
    expect((await recommendationFor()).headline(l10n), 'TE RECOMENDAMOS');
    expect(
      (await recommendationFor(
        const CampaignContext(selectedScenario: ClimateScenario.dry),
      )).headline(l10n),
      'SI EL AÑO VIENE SECO, TE CONVIENE',
    );
  });

  test('razones de "¿Por qué te lo recomendamos?"', () async {
    final reasons = (await recommendationFor()).reasons(l10n);

    expect(reasons, [
      'Con El Niño llueve más; el frejol le devuelve fuerza a tu tierra y el '
          'maíz aguanta mejor el clima que el arroz.',
      'Tu tierra lleva 3 campañas de arroz; esta rotación la recupera.',
      'Gastas menos agua de Poechos que con arroz.',
    ]);
  });

  test('la narración incluye la recomendación y sus cifras', () async {
    final narration = (await recommendationFor()).recommendationNarration(l10n);

    expect(narration, contains('te recomendamos Maíz y después frejol'));
    expect(narration, contains('cosechar 85% de una buena campaña'));
    expect(narration, isNot(contains('S/')));
    expect(narration, contains('marzo'));
  });

  test('compara lo actual con hasta dos rotaciones', () async {
    final recommendation = await recommendationFor();

    expect(recommendation.comparedRotations.ids, ['r1', 'r2']);
    expect(recommendation.comparedOptionsCount, 3);
  });
}
