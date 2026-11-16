import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';

import '../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  testWidgets('con datos de ejemplo se ve el rótulo en toda la app', (
    tester,
  ) async {
    await tester.pumpSiembraSeguraApp();
    expect(find.text(l10n.sampleDataBanner), findsOneWidget);

    await tester.tapText(l10n.actionSeePlan);
    expect(find.text(l10n.sampleDataBanner), findsOneWidget);
  });

  testWidgets('con datos reales no aparece', (tester) async {
    await tester.pumpSiembraSeguraApp(
      config: AppConfig(
        environment: Environment.dev,
        dataSource: DataSourceMode.remote,
        apiBaseUrl: Uri.parse('http://localhost:8000/'),
      ),
    );
    expect(find.text(l10n.sampleDataBanner), findsNothing);
  });
}
