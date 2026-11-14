import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/config/mock_latency.dart';
import 'package:siembra_segura/core/network/http_api_client.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/features/climate/data/mock_climate_repository.dart';
import 'package:siembra_segura/features/climate/data/remote_climate_repository.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/shared/state/farm_location_provider.dart';

/// Repositorio del clima según la fuente de datos configurada.
final climateRepositoryProvider = Provider<ClimateRepository>((ref) {
  return switch (ref.watch(appConfigProvider).dataSource) {
    DataSourceMode.mock => MockClimateRepository(
      clock: ref.watch(clockProvider),
      latency: ref.watch(mockLatencyProvider),
    ),
    DataSourceMode.remote => RemoteClimateRepository(
      apiClient: ref.watch(apiClientProvider),
      location: ref.watch(farmLocationProvider),
    ),
  };
});

/// Resumen climático de la parcela.
final climateOverviewProvider = FutureProvider<ClimateOverview>(
  (ref) => ref.watch(climateRepositoryProvider).getOverview(),
);
