import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Decisiones del agricultor que condicionan la recomendación.
///
/// Los campos nulos significan "usar el valor sugerido por los datos":
/// - [lastCrop] nulo: se usa el cultivo inferido por satélite.
/// - [selectedScenario] nulo: se usa el escenario más probable.
class CampaignContext extends Equatable {
  const CampaignContext({
    this.lastCrop,
    this.priority = CampaignPriority.maximizeProfit,
    this.restrictions = const {},
    this.selectedScenario,
  });

  final Crop? lastCrop;
  final CampaignPriority priority;
  final Set<CampaignRestriction> restrictions;
  final ClimateScenario? selectedScenario;

  CampaignContext copyWith({
    Crop? lastCrop,
    CampaignPriority? priority,
    Set<CampaignRestriction>? restrictions,
    ClimateScenario? selectedScenario,
  }) {
    return CampaignContext(
      lastCrop: lastCrop ?? this.lastCrop,
      priority: priority ?? this.priority,
      restrictions: restrictions ?? this.restrictions,
      selectedScenario: selectedScenario ?? this.selectedScenario,
    );
  }

  @override
  List<Object?> get props => [
    lastCrop,
    priority,
    restrictions,
    selectedScenario,
  ];
}
