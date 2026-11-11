import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/shared/data/mock_seasonal_outlook_repository.dart';
import 'package:siembra_segura/shared/data/remote_pending.dart';
import 'package:siembra_segura/shared/domain/seasonal_outlook.dart';

/// Repositorio del pronóstico según la fuente de datos configurada.
final seasonalOutlookRepositoryProvider = Provider<SeasonalOutlookRepository>((
  ref,
) {
  return switch (ref.watch(appConfigProvider).dataSource) {
    DataSourceMode.mock => MockSeasonalOutlookRepository(
      latency: ref.watch(mockLatencyProvider),
    ),
    DataSourceMode.remote => remoteDataSourcePending('SeasonalOutlook'),
  };
});

/// Pronóstico estacional; lo comparten Clima y Qué sembrar.
final seasonalOutlookProvider = FutureProvider<SeasonalOutlook>(
  (ref) => ref.watch(seasonalOutlookRepositoryProvider).getOutlook(),
);
