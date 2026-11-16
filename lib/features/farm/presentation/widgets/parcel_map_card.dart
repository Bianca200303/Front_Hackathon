import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/shared/data/pilot_farm_location.dart';
import 'package:siembra_segura/shared/domain/farm_location.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/state/farm_location_provider.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "¿Dónde está tu chacra?": el agricultor la marca en el mapa del valle y
/// con ese punto se piden los datos de la NASA, el suelo y el verdor.
///
/// El fondo es una ilustración del valle, no una imagen satelital: pintar
/// teselas reales necesitaría una dependencia nueva (decisión B4).
class ParcelMapCard extends ConsumerWidget {
  /// Crea la tarjeta.
  const ParcelMapCard({required this.farm, super.key});

  /// Parcela a mostrar.
  final Farm farm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final location = ref.watch(farmLocationProvider);
    final coordinates = l10n.farmMapCoordinates(
      AppFormatters.coordinate(location.latitude),
      AppFormatters.coordinate(location.longitude),
    );

    return AppCard(
      variant: AppCardVariant.flush,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xxs,
            children: [
              SectionTitle(l10n.farmMapQuestion),
              MutedText(l10n.farmMapHint),
            ],
          ),
        ),
        _ValleyMap(
          location: location,
          coordinates: coordinates,
          onPicked: (latitude, longitude) => ref
              .read(campaignContextProvider.notifier)
              .selectFarmLocation(latitude: latitude, longitude: longitude),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              Row(
                spacing: AppSpacing.sm,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FarmFact(label: l10n.farmValley, value: farm.valleyName),
                  _FarmFact(
                    label: l10n.farmIrrigation,
                    value: farm.irrigationSource,
                  ),
                ],
              ),
              ExcludeSemantics(
                child: Text(coordinates, style: context.text.captionMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FarmFact extends StatelessWidget {
  const _FarmFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}

/// Mapa del valle: se toca para mover el marcador de la chacra.
class _ValleyMap extends StatelessWidget {
  const _ValleyMap({
    required this.location,
    required this.coordinates,
    required this.onPicked,
  });

  final FarmLocation location;
  final String coordinates;
  final void Function(double latitude, double longitude) onPicked;

  static const _bounds = pilotValleyBounds;
  static const _aspectRatio = 350 / 130;
  static const _pinSize = 34.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (x, y) = _bounds.fractionOf(location);

    return Semantics(
      button: true,
      label: l10n.farmMapPinSemantics(
        AppFormatters.coordinate(location.latitude),
        AppFormatters.coordinate(location.longitude),
      ),
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: _aspectRatio,
        child: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final (latitude, longitude) = _bounds.locationAt(
                details.localPosition.dx / constraints.maxWidth,
                details.localPosition.dy / constraints.maxHeight,
              );
              onPicked(latitude, longitude);
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _ValleyPainter(context.colors)),
                ),
                Positioned(
                  left: x * constraints.maxWidth - _pinSize / 2,
                  top: y * constraints.maxHeight - _pinSize,
                  child: Icon(
                    Icons.place,
                    size: _pinSize,
                    color: context.colors.primary,
                    shadows: [
                      Shadow(color: context.colors.surface, blurRadius: 4),
                    ],
                  ),
                ),
                Positioned(
                  left: AppSpacing.md,
                  bottom: 10,
                  child: _MapCaption(text: l10n.farmSatelliteCaption),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapCaption extends StatelessWidget {
  const _MapCaption({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm)),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: context.colors.textPrimary),
      ),
    );
  }
}

/// Ilustración del valle (campos, carretera y canal) en un lienzo de
/// 350 × 130, tomada de la referencia.
class _ValleyPainter extends CustomPainter {
  const _ValleyPainter(this.colors);

  final AppPalette colors;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 350, size.height / 130);

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 350, 130),
      Paint()..color = colors.mapField,
    );
    canvas.drawLine(
      const Offset(0, 35),
      const Offset(350, 60),
      Paint()
        ..color = colors.mapRoad
        ..strokeWidth = 10,
    );
    canvas.drawLine(
      const Offset(0, 100),
      const Offset(350, 112),
      Paint()
        ..color = colors.mapCanal
        ..strokeWidth = 6,
    );
    final plotPaint = Paint()..color = colors.mapPlot;
    canvas
      ..drawRect(const Rect.fromLTWH(20, 68, 70, 26), plotPaint)
      ..drawRect(const Rect.fromLTWH(250, 8, 80, 34), plotPaint)
      ..drawRect(const Rect.fromLTWH(140, 50, 90, 40), plotPaint);
  }

  @override
  bool shouldRepaint(_ValleyPainter oldDelegate) =>
      oldDelegate.colors != colors;
}

/// La chacra marcada sobre el valle (350 × 130), para la miniatura.
class _ParcelMapPainter extends CustomPainter {
  _ParcelMapPainter(this.colors);

  final AppPalette colors;

  Color get _field => colors.mapField;
  Color get _road => colors.mapRoad;
  Color get _canal => colors.mapCanal;
  Color get _plot => colors.mapPlot;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 350, size.height / 130);

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 350, 130),
      Paint()..color = _field,
    );
    canvas.drawLine(
      const Offset(0, 35),
      const Offset(350, 60),
      Paint()
        ..color = _road
        ..strokeWidth = 10,
    );
    canvas.drawLine(
      const Offset(0, 100),
      const Offset(350, 112),
      Paint()
        ..color = _canal
        ..strokeWidth = 6,
    );
    final plotPaint = Paint()..color = _plot;
    canvas
      ..drawRect(const Rect.fromLTWH(20, 68, 70, 26), plotPaint)
      ..drawRect(const Rect.fromLTWH(250, 8, 80, 34), plotPaint);

    final parcel = Path()
      ..moveTo(120, 50)
      ..lineTo(230, 62)
      ..lineTo(220, 102)
      ..lineTo(112, 94)
      ..close();
    canvas
      ..drawPath(
        parcel,
        Paint()..color = colors.primary.withValues(alpha: 0.22),
      )
      ..drawPath(
        parcel,
        Paint()
          ..color = colors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeJoin = StrokeJoin.round,
      );
  }

  @override
  bool shouldRepaint(_ParcelMapPainter oldDelegate) =>
      oldDelegate.colors != colors;
}

/// Mapa pequeño de la chacra (`.mapa-btn` de `semi_app.html`), decorativo:
/// los datos van en el texto de al lado.
class ParcelMapThumbnail extends StatelessWidget {
  /// Crea la miniatura.
  const ParcelMapThumbnail({this.width = 96, super.key});

  /// Ancho, en dp; el alto guarda la proporción del mapa.
  final double width;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: SizedBox(
          width: width,
          height: width * 130 / 350,
          child: CustomPaint(painter: _ParcelMapPainter(context.colors)),
        ),
      ),
    );
  }
}
