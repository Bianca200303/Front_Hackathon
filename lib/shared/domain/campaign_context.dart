import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Decisiones del agricultor que condicionan la recomendación.
///
/// Guarda **identificadores y valores simples**, no objetos del catálogo:
/// así se puede persistir y sobrevive a cambios de nombre en el backend. Un
/// campo nulo significa "usar el valor sugerido":
/// - [lastCropId] nulo: el cultivo inferido por satélite.
/// - [priorityId] nulo: la prioridad sugerida del catálogo.
/// - [selectedScenario] nulo: el escenario normal.
/// - [areaHectares] nulo: [defaultAreaHectares].
/// - [plantingDate] nula: hoy.
/// - [consecutiveCampaigns] nulo: [defaultConsecutiveCampaigns].
/// - [farmLatitude] / [farmLongitude] nulas: la zona piloto.
/// - [customRotation] vacía: solo las rotaciones que propone la fuente.
/// - [soilTexture] nula: la textura que estima SoilGrids.
///
/// Un identificador que ya no existe en los datos se trata como nulo.
class CampaignContext extends Equatable {
  /// Crea el contexto. Sin argumentos equivale a "todo sugerido".
  const CampaignContext({
    this.lastCropId,
    this.priorityId,
    this.restrictionIds = const {},
    this.selectedScenario,
    this.areaHectares,
    this.plantingDate,
    this.consecutiveCampaigns,
    this.farmLatitude,
    this.farmLongitude,
    this.customRotation = const [],
    this.soilTexture,
  });

  /// Hectáreas que se asumen si el agricultor no las indicó.
  static const defaultAreaHectares = 1.0;

  /// Campañas seguidas que se asumen si el agricultor no las indicó.
  static const defaultConsecutiveCampaigns = 1;

  /// Cultivo de la última campaña que eligió el agricultor.
  final String? lastCropId;

  /// Prioridad que eligió el agricultor.
  final String? priorityId;

  /// Restricciones activas.
  final Set<String> restrictionIds;

  /// Escenario que el agricultor está explorando. No se persiste: es una
  /// exploración puntual, no una preferencia.
  final ClimateScenario? selectedScenario;

  /// Superficie de la parcela que indicó el agricultor, en hectáreas.
  final double? areaHectares;

  /// Fecha en la que quiere sembrar.
  final DateTime? plantingDate;

  /// Campañas seguidas con el mismo cultivo.
  final int? consecutiveCampaigns;

  /// Latitud de la parcela que marcó el agricultor en el mapa.
  final double? farmLatitude;

  /// Longitud de la parcela que marcó el agricultor en el mapa.
  final double? farmLongitude;

  /// Cultivos que el agricultor encadenó por su cuenta, en orden de siembra.
  final List<String> customRotation;

  /// Textura que el agricultor reconoció en su chacra. Manda sobre la que
  /// estima el satélite.
  final SoilTexture? soilTexture;

  /// `true` si no hay ninguna preferencia guardable elegida.
  bool get hasNoPreferences =>
      lastCropId == null &&
      priorityId == null &&
      restrictionIds.isEmpty &&
      areaHectares == null &&
      plantingDate == null &&
      consecutiveCampaigns == null &&
      farmLatitude == null &&
      farmLongitude == null &&
      customRotation.isEmpty &&
      soilTexture == null;

  /// Copia con los campos indicados reemplazados. Un campo nulo deja el
  /// valor actual; [clearSoilTexture] es la única forma de volver a "no
  /// contestada".
  CampaignContext copyWith({
    String? lastCropId,
    String? priorityId,
    Set<String>? restrictionIds,
    ClimateScenario? selectedScenario,
    double? areaHectares,
    DateTime? plantingDate,
    int? consecutiveCampaigns,
    double? farmLatitude,
    double? farmLongitude,
    List<String>? customRotation,
    SoilTexture? soilTexture,
    bool clearSoilTexture = false,
  }) {
    return CampaignContext(
      lastCropId: lastCropId ?? this.lastCropId,
      priorityId: priorityId ?? this.priorityId,
      restrictionIds: restrictionIds ?? this.restrictionIds,
      selectedScenario: selectedScenario ?? this.selectedScenario,
      areaHectares: areaHectares ?? this.areaHectares,
      plantingDate: plantingDate ?? this.plantingDate,
      consecutiveCampaigns: consecutiveCampaigns ?? this.consecutiveCampaigns,
      farmLatitude: farmLatitude ?? this.farmLatitude,
      farmLongitude: farmLongitude ?? this.farmLongitude,
      customRotation: customRotation ?? this.customRotation,
      soilTexture: clearSoilTexture ? null : soilTexture ?? this.soilTexture,
    );
  }

  /// Copia solo con las preferencias que se guardan en el dispositivo.
  CampaignContext get preferencesOnly => CampaignContext(
    lastCropId: lastCropId,
    priorityId: priorityId,
    restrictionIds: restrictionIds,
    areaHectares: areaHectares,
    plantingDate: plantingDate,
    consecutiveCampaigns: consecutiveCampaigns,
    farmLatitude: farmLatitude,
    farmLongitude: farmLongitude,
    customRotation: customRotation,
    soilTexture: soilTexture,
  );

  @override
  List<Object?> get props => [
    lastCropId,
    priorityId,
    restrictionIds,
    selectedScenario,
    areaHectares,
    plantingDate,
    consecutiveCampaigns,
    farmLatitude,
    farmLongitude,
    customRotation,
    soilTexture,
  ];
}
