import 'package:siembra_segura/core/error/app_exception.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';

class FailingClimateRepository implements ClimateRepository {
  @override
  Future<ClimateOverview> getOverview() async =>
      throw const ServerException(500);
}

class FailingCropPlanningRepository implements CropPlanningRepository {
  @override
  Future<CropPlanningData> getPlanningData(CropPlanningQuery query) async =>
      throw const NetworkException();

  @override
  Future<void> submitPlantingFeedback(PlantingFeedback feedback) async =>
      throw const NetworkException();
}

/// Devuelve los datos indicados y falla al enviar la respuesta.
class FixedCropPlanningRepository implements CropPlanningRepository {
  FixedCropPlanningRepository(this.data, {this.failOnSubmit = false});

  final CropPlanningData data;
  final bool failOnSubmit;

  @override
  Future<CropPlanningData> getPlanningData(CropPlanningQuery query) async =>
      data;

  @override
  Future<void> submitPlantingFeedback(PlantingFeedback feedback) async {
    if (failOnSubmit) throw const ServerException(503);
  }
}
