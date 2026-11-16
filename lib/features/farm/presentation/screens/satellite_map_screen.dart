import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/services/location/device_location.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/shared/data/pilot_farm_location.dart';
import 'package:siembra_segura/shared/domain/farm_location.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';

/// Si se dibujan las teselas de satélite. Las pruebas lo apagan: no hay red.
final satelliteTilesProvider = Provider<bool>((ref) => true);

/// Imagen de satélite sin nubes de 2024 (Sentinel-2, EOX), libre para uso no
/// comercial citando la fuente (CC BY-NC-SA 4.0).
const _satelliteTiles =
    'https://tiles.maps.eox.at/wmts/1.0.0/s2cloudless-2024_3857/default/g/{z}/{y}/{x}.jpg';

/// Nombres de pueblos, ríos y caminos (OpenStreetMap, servido por EOX).
const _labelTiles =
    'https://tiles.maps.eox.at/wmts/1.0.0/overlay_bright_3857/default/g/{z}/{y}/{x}.png';

/// Atribución que piden las licencias; siempre a la vista.
const satelliteAttribution =
    'Sentinel-2 cloudless 2024 © EOX IT Services GmbH (Copernicus Sentinel '
    'modificado), CC BY-NC-SA 4.0 · Nombres © OpenStreetMap';

/// Abre el mapa satelital y devuelve el punto que confirmó el agricultor, o
/// `null` si volvió sin elegir.
Future<FarmLocation?> pickFarmOnSatelliteMap(
  BuildContext context,
  FarmLocation current,
) => Navigator.of(context).push<FarmLocation>(
  MaterialPageRoute(builder: (_) => SatelliteMapScreen(initial: current)),
);

/// "Marca tu chacra": imagen de satélite real del valle, con zoom, para
/// reconocer la chacra y tocarla. "Estoy en mi chacra" centra el mapa con
/// el GPS; "Es aquí" confirma el punto marcado.
class SatelliteMapScreen extends ConsumerStatefulWidget {
  /// Crea la pantalla con el marcador en [initial].
  const SatelliteMapScreen({required this.initial, super.key});

  /// Dónde está marcada la chacra hoy.
  final FarmLocation initial;

  @override
  ConsumerState<SatelliteMapScreen> createState() => _SatelliteMapScreenState();
}

class _SatelliteMapScreenState extends ConsumerState<SatelliteMapScreen> {
  static const _bounds = pilotValleyBounds;
  static const _farmZoom = 15.0;

  final _map = MapController();
  late LatLng _picked = LatLng(
    widget.initial.latitude,
    widget.initial.longitude,
  );
  bool _locating = false;
  String? _note;

  void _pick(LatLng point) {
    if (!_bounds.contains(point.latitude, point.longitude)) {
      setState(() => _note = AppLocalizations.of(context).mapOutsideValley);
      return;
    }
    setState(() {
      _picked = point;
      _note = null;
    });
  }

  Future<void> _useMyLocation() async {
    if (_locating) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _locating = true);
    final result = await ref.read(deviceLocationServiceProvider).current();
    if (!mounted) return;
    setState(() {
      _locating = false;
      _note = switch (result) {
        LocationFound(:final latitude, :final longitude)
            when _bounds.contains(latitude, longitude) =>
          () {
            _picked = LatLng(latitude, longitude);
            _map.move(_picked, _farmZoom);
            return l10n.chatLocationFound;
          }(),
        LocationFound() => l10n.chatLocationOutside,
        LocationDenied() => l10n.chatLocationDenied,
        LocationUnavailable() => l10n.chatLocationUnavailable,
      };
    });
  }

  void _confirm() => Navigator.of(context).pop(
    FarmLocation(
      valleyName: widget.initial.valleyName,
      latitude: _picked.latitude,
      longitude: _picked.longitude,
    ),
  );

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final note = _note;

    return ScreenLayout(
      wide: true,
      header: ScreenHeader(
        leading: Row(
          spacing: AppSpacing.xs,
          children: [
            const AppBackButton(fallbackLocation: AppRoutes.farm),
            Expanded(child: ScreenTitle(title: l10n.mapScreenTitle)),
          ],
        ),
        showListen: false,
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          AppButton(
            label: _locating ? l10n.chatLocating : l10n.chatUseMyLocation,
            icon: Icons.my_location_rounded,
            variant: AppButtonVariant.outline,
            onPressed: _locating ? null : _useMyLocation,
          ),
          AppButton(
            label: l10n.chatMapConfirm,
            icon: Icons.check_rounded,
            onPressed: _confirm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenGutter,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            Text(note ?? l10n.mapScreenHint, style: context.text.muted),
            Expanded(
              child: ClipRRect(
                borderRadius: AppRadii.card,
                child: Semantics(
                  label: l10n.mapSemantics,
                  child: ColoredBox(
                    color: colors.surfaceMuted,
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _map,
                          options: MapOptions(
                            initialCenter: _picked,
                            initialZoom: _farmZoom - 2,
                            minZoom: 10,
                            maxZoom: 18,
                            backgroundColor: colors.surfaceMuted,
                            cameraConstraint: CameraConstraint.containCenter(
                              bounds: LatLngBounds(
                                LatLng(_bounds.south, _bounds.west),
                                LatLng(_bounds.north, _bounds.east),
                              ),
                            ),
                            onTap: (_, point) => _pick(point),
                          ),
                          children: [
                            if (ref.watch(satelliteTilesProvider)) ...[
                              TileLayer(
                                urlTemplate: _satelliteTiles,
                                maxNativeZoom: 16,
                                userAgentPackageName:
                                    'pe.siembrasegura.siembra_segura',
                              ),
                              TileLayer(
                                urlTemplate: _labelTiles,
                                maxNativeZoom: 16,
                                userAgentPackageName:
                                    'pe.siembrasegura.siembra_segura',
                              ),
                            ],
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _picked,
                                  width: 48,
                                  height: 48,
                                  alignment: Alignment.topCenter,
                                  child: Icon(
                                    Icons.place,
                                    size: 48,
                                    color: colors.primary,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: ColoredBox(
                            color: Colors.black54,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              child: Text(
                                satelliteAttribution,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
