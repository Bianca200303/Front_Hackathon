import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/features/climate/data/mock_climate_repository.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/shared/data/remote_pending.dart';

/// Repositorio del clima según la fuente de datos configurada.
final climateRepositoryProvider = Provider<ClimateRepository>((ref) {
  return switch (ref.watch(appConfigProvider).dataSource) {
    DataSourceMode.mock => MockClimateRepository(
      clock: ref.watch(clockProvider),
      latency: ref.watch(mockLatencyProvider),
      language: ref.watch(appLanguageProvider),
    ),
    DataSourceMode.remote => remoteDataSourcePending('Climate'),
  };
});

/// Resumen climático de la parcela.
final climateOverviewProvider = FutureProvider<ClimateOverview>(
  (ref) => ref.watch(climateRepositoryProvider).getOverview(),
);
