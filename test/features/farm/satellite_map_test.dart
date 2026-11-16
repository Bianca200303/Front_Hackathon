import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/core/services/location/device_location.dart';
import 'package:siembra_segura/features/farm/presentation/screens/satellite_map_screen.dart';
import 'package:siembra_segura/shared/data/app_mode_stores.dart';
import 'package:siembra_segura/shared/data/pilot_farm_location.dart';
import 'package:siembra_segura/shared/state/farm_location_provider.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';

import '../../helpers/fake_location_service.dart';
import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  Future<void> openFromChat(
    WidgetTester tester, {
    FakeLocationService? gps,
  }) async {
    await tester.pumpSiembraSeguraApp(
      appModeStore: InMemoryAppModeStore(),
      deviceLocation: gps,
    );
    await tester.tapText(l10n.welcomeAssistedTitle);
    await tester.tapText(l10n.mapOpenSatellite);
  }

  testWidgets('el chat abre el mapa satelital con su atribución', (
    tester,
  ) async {
    await openFromChat(tester);

    expect(find.text(l10n.mapScreenTitle), findsOneWidget);
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.text(satelliteAttribution), findsOneWidget);
  });

  testWidgets('tocar el mapa y "Es aquí" guarda la chacra', (tester) async {
    await openFromChat(tester);
    final before = tester.container.read(farmLocationProvider);

    final map = tester.getRect(find.byType(FlutterMap));
    await tester.tapAt(map.center + const Offset(40, 30));
    // flutter_map espera por si es un doble toque antes de aceptar el toque.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    await tester.tapText(l10n.chatMapConfirm);

    final after = tester.container.read(farmLocationProvider);
    expect(after, isNot(before));
    expect(pilotValleyBounds.contains(after.latitude, after.longitude), isTrue);
    // Volvió a la conversación.
    expect(find.text(l10n.mapScreenTitle), findsNothing);
    expect(find.text(l10n.chatMapQuestion('Valle del Chira')), findsOneWidget);
  });

  testWidgets('"Estoy en mi chacra" mueve el marcador con el GPS', (
    tester,
  ) async {
    await openFromChat(
      tester,
      gps: FakeLocationService(
        const LocationFound(latitude: -4.88, longitude: -81.02),
      ),
    );

    await tester.tapText(l10n.chatUseMyLocation);
    expect(find.text(l10n.chatLocationFound), findsOneWidget);
    await tester.tapText(l10n.chatMapConfirm);

    final after = tester.container.read(farmLocationProvider);
    expect((after.latitude, after.longitude), (-4.88, -81.02));
  });

  testWidgets('volver sin confirmar no cambia la chacra', (tester) async {
    await openFromChat(tester);
    final before = tester.container.read(farmLocationProvider);

    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();

    expect(tester.container.read(farmLocationProvider), before);
  });
}
