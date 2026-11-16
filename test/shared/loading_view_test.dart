import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_avatar.dart';

import '../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> pumpLoading(WidgetTester tester, AppConfig config) =>
      tester.pumpWidget(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(config)],
          child: const MaterialApp(
            locale: Locale('es'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: LoadingView()),
          ),
        ),
      );

  testWidgets('con datos reales, Semi avisa que mira los satélites', (
    tester,
  ) async {
    await pumpLoading(
      tester,
      AppConfig(
        environment: Environment.dev,
        dataSource: DataSourceMode.remote,
        apiBaseUrl: Uri.parse('http://localhost:8000/'),
      ),
    );

    expect(find.byType(SemiAvatar), findsOneWidget);
    expect(find.text(l10n.loadingSatellite), findsOneWidget);
  });

  testWidgets('con datos de ejemplo no dice que mira satélites', (
    tester,
  ) async {
    await pumpLoading(tester, testConfig);

    expect(find.text(l10n.loadingSatellite), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
