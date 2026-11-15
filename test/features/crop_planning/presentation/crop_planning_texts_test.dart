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
    catalog: referenceCatalog,
    context: context,
  );

  setUpAll(initTestLocale);

  test('nombres de rotaciones como en la referencia', () async {
    final recommendation = await recommendationFor();

    expect(recommendation.best.name(l10n), 'Frejol y después maíz');
    expect(recommendation.currentPractice.name(l10n), 'Arroz y arroz');
    expect(
      recommendation.longTermPlanName(l10n),
      'Frejol y después maíz y después menestra y algodón.',
    );
  });

  test('el titular depende del escenario que se está viendo', () async {
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
      'En un año normal, son los cultivos que menos riego necesitan, y el '
          'frejol prepara la tierra para el maíz.',
      'Tu tierra lleva 3 campañas de arroz; esta rotación la ayuda a '
          'recuperar.',
      'Gastas menos agua de Poechos que con arroz.',
    ]);
  });

  test('la narración incluye el agua y el riesgo de clima', () async {
    final narration = (await recommendationFor()).recommendationNarration(l10n);

    expect(narration, contains('te recomendamos Frejol y después maíz'));
    expect(narration, contains('13,800 m³'));
    expect(narration, contains('el riesgo de clima es bajo'));
  });

  test('compara lo actual con hasta dos rotaciones', () async {
    final recommendation = await recommendationFor();

    expect(recommendation.comparedRotations.ids, ['r3', 'r1']);
    expect(recommendation.comparedOptionsCount, 3);
  });
}
