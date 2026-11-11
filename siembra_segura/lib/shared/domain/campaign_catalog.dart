import 'package:equatable/equatable.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Opciones entre las que el agricultor configura su campaña.
///
/// Viene de la fuente de datos (decisión B12): la app solo muestra lo que
/// recibe.
class CampaignCatalog extends Equatable {
  /// Crea el catálogo. Debe haber al menos una prioridad.
  CampaignCatalog({
    required List<CampaignPriority> priorities,
    required List<CampaignRestriction> restrictions,
  }) : assert(priorities.isNotEmpty, 'El catálogo necesita prioridades.'),
       priorities = List.unmodifiable(priorities),
       restrictions = List.unmodifiable(restrictions);

  /// Prioridades en el orden en que se muestran. La primera es la sugerida
  /// cuando el agricultor no eligió ninguna.
  final List<CampaignPriority> priorities;

  /// Restricciones opcionales, en el orden en que se muestran.
  final List<CampaignRestriction> restrictions;

  /// Prioridad que se usa si el agricultor no eligió ninguna.
  CampaignPriority get defaultPriority => priorities.first;

  /// La prioridad con [id] o, si no existe (nula o retirada del catálogo),
  /// la sugerida.
  CampaignPriority priorityOrDefault(String? id) =>
      priorities.where((priority) => priority.id == id).firstOrNull ??
      defaultPriority;

  @override
  List<Object?> get props => [priorities, restrictions];
}

/// Fuente del catálogo de campaña.
abstract interface class CampaignCatalogRepository {
  /// Devuelve el catálogo vigente.
  Future<CampaignCatalog> getCatalog();
}
