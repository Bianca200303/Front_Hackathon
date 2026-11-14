import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/features/alerts/data/mock_alerts_repository.dart';
import 'package:siembra_segura/features/alerts/domain/alert.dart';

/// Repositorio de avisos. Usa datos de ejemplo también con
/// `DATA_SOURCE=remote` hasta que el backend publique avisos (B7).
final alertsRepositoryProvider = Provider<AlertsRepository>(
  (ref) => MockAlertsRepository(
    clock: ref.watch(clockProvider),
    latency: ref.watch(mockLatencyProvider),
  ),
);

/// Avisos del agricultor.
final alertsProvider = FutureProvider<List<Alert>>(
  (ref) => ref.watch(alertsRepositoryProvider).getAlerts(),
);

/// Indicador de avisos nuevos en la pestaña.
final hasUnreadAlertsProvider = Provider<bool>((ref) {
  final alerts = ref.watch(alertsProvider).value;
  return alerts?.any((alert) => !alert.isRead) ?? false;
});

/// Mensaje completo de un aviso, por identificador.
final alertMessageProvider = FutureProvider.family<AlertMessage, String>(
  (ref, alertId) => ref.watch(alertsRepositoryProvider).getMessage(alertId),
);
