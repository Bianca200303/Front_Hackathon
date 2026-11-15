import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/features/crop_planning/data/mock_plan_simulator.dart';
import 'package:siembra_segura/features/crop_planning/domain/plan_simulation.dart';
import 'package:siembra_segura/shared/data/mock_catalog.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

void main() {
  const simulator = MockPlanSimulator();
  const rice = MockCatalog.rice;
  const maize = MockCatalog.maize;
  const bean = MockCatalog.bean;
  const greenManure = MockCatalog.greenManure;

  Future<PlanSimulation> simulate(
    List<Crop> plan, {
    ClimateScenario firstSeason = ClimateScenario.heavyRains,
  }) => simulator.simulate(
    plan: plan,
    previousCrop: rice,
    soilToday: SoilCondition.tired,
    firstSeason: firstSeason,
  );

  test('seguir con arroz cansa la tierra y baja la cosecha', () async {
    final sameCrop = await simulate([rice, rice, rice, rice]);
    final rotation = await simulate([maize, bean, maize, bean]);

    expect(sameCrop.soilAfter, SoilCondition.veryTired);
    expect(rotation.soilAfter.index, greaterThan(sameCrop.soilAfter.index));
    expect(rotation.averageHarvest, greaterThan(sameCrop.averageHarvest));
    expect(rotation.waterUseM3, lessThan(sameCrop.waterUseM3));
  });

  test('el abono verde no se cosecha pero mejora la tierra', () async {
    final result = await simulate([maize, greenManure, maize, bean]);

    expect(result.campaigns[1].harvest, isNull);
    expect(
      result.campaigns[1].soilAfter.index,
      greaterThan(result.campaigns[0].soilAfter.index),
    );
    // El promedio solo cuenta lo que se cosecha.
    expect(result.averageHarvest, greaterThan(0));
  });

  test('el arroz sufre más con lluvias fuertes que en un año normal', () async {
    final rainy = await simulate([rice, maize, bean, maize]);
    final normal = await simulate([
      rice,
      maize,
      bean,
      maize,
    ], firstSeason: ClimateScenario.normal);

    expect(
      rainy.campaigns.first.harvest,
      lessThan(normal.campaigns.first.harvest!),
    );
  });

  test('el algodón se descarta si no hay comprador', () async {
    final crops = await simulator.availableCrops();
    final cotton = crops.singleWhere((c) => c.crop.id == MockCatalog.cotton.id);

    expect(cotton.excludedBy, contains(MockCatalog.noCottonBuyer.id));
    expect(crops.last.harvested, isFalse);
  });
}
