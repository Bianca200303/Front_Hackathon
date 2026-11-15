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
    List<SoilTextureAnswer> soilTextures = const [],
    this.soilTextureQuestion = '',
    this.maxRotationCrops = defaultMaxRotationCrops,
  }) : assert(priorities.isNotEmpty, 'El catálogo necesita prioridades.'),
       priorities = List.unmodifiable(priorities),
       restrictions = List.unmodifiable(restrictions),
       soilTextures = List.unmodifiable(soilTextures);

  /// Cultivos que se pueden encadenar si la fuente no dice otra cosa.
  static const defaultMaxRotationCrops = 4;

  /// Prioridades en el orden en que se muestran. La primera es la sugerida
  /// cuando el agricultor no eligió ninguna.
  final List<CampaignPriority> priorities;

  /// Restricciones opcionales, en el orden en que se muestran.
  final List<CampaignRestriction> restrictions;

  /// Texturas entre las que el agricultor reconoce su tierra, en el orden
  /// en que se muestran. Vacía = la fuente no ofrece la pregunta.
  final List<SoilTextureAnswer> soilTextures;

  /// Pregunta con la que se ofrecen las [soilTextures] (p. ej., "¿A cuál de
  /// estas se parece tu tierra?").
  final String soilTextureQuestion;

  /// Cuántos cultivos puede encadenar el agricultor en su propia rotación.
  final int maxRotationCrops;

  /// `true` si se puede preguntar por la textura de la tierra.
  bool get asksForSoilTexture =>
      soilTextures.isNotEmpty && soilTextureQuestion.isNotEmpty;

  /// Prioridad que se usa si el agricultor no eligió ninguna.
  CampaignPriority get defaultPriority => priorities.first;

  /// La prioridad con [id] o, si no existe (nula o retirada del catálogo),
  /// la sugerida.
  CampaignPriority priorityOrDefault(String? id) =>
      priorities.where((priority) => priority.id == id).firstOrNull ??
      defaultPriority;

  @override
  List<Object?> get props => [
    priorities,
    restrictions,
    soilTextures,
    soilTextureQuestion,
    maxRotationCrops,
  ];
}

/// Fuente del catálogo de campaña.
abstract interface class CampaignCatalogRepository {
  /// Devuelve el catálogo vigente.
  Future<CampaignCatalog> getCatalog();
}
