import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/shared/data/mock_seasonal_outlook_repository.dart';
import 'package:siembra_segura/shared/domain/seasonal_outlook.dart';

/// Repositorio del pronóstico estacional. Usa datos de ejemplo también con
/// `DATA_SOURCE=remote`: las probabilidades vienen del ENFEN y el backend
/// todavía no las publica.
final seasonalOutlookRepositoryProvider = Provider<SeasonalOutlookRepository>(
  (ref) =>
      MockSeasonalOutlookRepository(latency: ref.watch(mockLatencyProvider)),
);

/// Pronóstico estacional; lo comparten Clima y Qué sembrar.
final seasonalOutlookProvider = FutureProvider<SeasonalOutlook>(
  (ref) => ref.watch(seasonalOutlookRepositoryProvider).getOutlook(),
);
