import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Decisiones del agricultor que condicionan la recomendación.
///
/// Guarda **identificadores**, no objetos del catálogo: así se puede
/// persistir y sobrevive a cambios de nombre en el backend. Un campo nulo
/// significa "usar el valor sugerido por los datos":
/// - [lastCropId] nulo: el cultivo inferido por satélite.
/// - [priorityId] nulo: la prioridad sugerida del catálogo.
/// - [selectedScenario] nulo: el escenario más probable.
///
/// Un identificador que ya no existe en los datos se trata como nulo.
class CampaignContext extends Equatable {
  /// Crea el contexto. Sin argumentos equivale a "todo sugerido".
  const CampaignContext({
    this.lastCropId,
    this.priorityId,
    this.restrictionIds = const {},
    this.selectedScenario,
  });

  /// Cultivo de la última campaña que eligió el agricultor.
  final String? lastCropId;

  /// Prioridad que eligió el agricultor.
  final String? priorityId;

  /// Restricciones activas.
  final Set<String> restrictionIds;

  /// Escenario que el agricultor está explorando. No se persiste: es una
  /// exploración puntual, no una preferencia.
  final ClimateScenario? selectedScenario;

  /// `true` si no hay ninguna preferencia guardable elegida.
  bool get hasNoPreferences =>
      lastCropId == null && priorityId == null && restrictionIds.isEmpty;

  /// Copia con los campos indicados reemplazados.
  CampaignContext copyWith({
    String? lastCropId,
    String? priorityId,
    Set<String>? restrictionIds,
    ClimateScenario? selectedScenario,
  }) {
    return CampaignContext(
      lastCropId: lastCropId ?? this.lastCropId,
      priorityId: priorityId ?? this.priorityId,
      restrictionIds: restrictionIds ?? this.restrictionIds,
      selectedScenario: selectedScenario ?? this.selectedScenario,
    );
  }

  /// Copia solo con las preferencias que se guardan en el dispositivo.
  CampaignContext get preferencesOnly => CampaignContext(
    lastCropId: lastCropId,
    priorityId: priorityId,
    restrictionIds: restrictionIds,
  );

  @override
  List<Object?> get props => [
    lastCropId,
    priorityId,
    restrictionIds,
    selectedScenario,
  ];
}
