import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';

/// Compara dos opciones: negativo si [a] va antes que [b].
typedef RotationComparator = int Function(RotationOption a, RotationOption b);

/// Criterio para ordenar las rotaciones según la prioridad del agricultor.
///
/// La app no conoce las prioridades (son datos del catálogo), así que no
/// puede decidir por sí misma qué significa cada una. Quién define el
/// criterio está pendiente (decisión B3):
/// - Hoy: `MockRotationRankingPolicy`, con las reglas de la referencia.
/// - Si el backend devuelve las opciones ya ordenadas, la política devuelve
///   `null` siempre y se respeta su orden.
abstract interface class RotationRankingPolicy {
  /// Comparador para [priority] en [scenario], o `null` si no hay criterio
  /// para esa prioridad (se conserva el orden en que llegaron los datos).
  RotationComparator? comparatorFor(
    CampaignPriority priority,
    ClimateScenario scenario,
  );
}

/// Ordena las rotaciones para un agricultor concreto.
///
/// 1. Descarta las opciones que alguna restricción activa excluye.
/// 2. Ordena con el criterio de la [policy] para la prioridad elegida.
/// 3. Los empates conservan el orden original (orden estable).
class RotationRanker {
  /// Crea el ordenador con el criterio indicado.
  const RotationRanker(this.policy);

  /// Criterio de orden por prioridad.
  final RotationRankingPolicy policy;

  /// Opciones permitidas, de mejor a peor.
  List<RotationOption> rank({
    required List<RotationOption> options,
    required ClimateScenario scenario,
    required CampaignPriority priority,
    required Set<String> restrictionIds,
  }) {
    final compare = policy.comparatorFor(priority, scenario);
    final allowed = options
        .where((option) => option.isAllowedWith(restrictionIds))
        .indexed
        .toList();
    if (compare != null) {
      // `List.sort` no es estable: el índice original desempata.
      allowed.sort((left, right) {
        final byPriority = compare(left.$2, right.$2);
        return byPriority != 0 ? byPriority : left.$1.compareTo(right.$1);
      });
    }
    return [for (final (_, option) in allowed) option];
  }
}
