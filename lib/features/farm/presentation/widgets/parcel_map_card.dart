import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
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
                child: Text(coordinates, style: AppTypography.captionMuted),
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
                const Positioned.fill(
                  child: CustomPaint(painter: _ValleyPainter()),
                ),
                Positioned(
                  left: x * constraints.maxWidth - _pinSize / 2,
                  top: y * constraints.maxHeight - _pinSize,
                  child: const Icon(
                    Icons.place,
                    size: _pinSize,
                    color: AppColors.primary,
                    shadows: [Shadow(color: AppColors.surface, blurRadius: 4)],
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
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(AppRadii.sm)),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

/// Ilustración del valle (campos, carretera y canal) en un lienzo de
/// 350 × 130, tomada de la referencia.
class _ValleyPainter extends CustomPainter {
  const _ValleyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 350, size.height / 130);

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 350, 130),
      Paint()..color = AppColors.mapField,
    );
    canvas.drawLine(
      const Offset(0, 35),
      const Offset(350, 60),
      Paint()
        ..color = AppColors.mapRoad
        ..strokeWidth = 10,
    );
    canvas.drawLine(
      const Offset(0, 100),
      const Offset(350, 112),
      Paint()
        ..color = AppColors.mapCanal
        ..strokeWidth = 6,
    );
    final plotPaint = Paint()..color = AppColors.mapPlot;
    canvas
      ..drawRect(const Rect.fromLTWH(20, 68, 70, 26), plotPaint)
      ..drawRect(const Rect.fromLTWH(250, 8, 80, 34), plotPaint)
      ..drawRect(const Rect.fromLTWH(140, 50, 90, 40), plotPaint);
  }

  @override
  bool shouldRepaint(_ValleyPainter oldDelegate) => false;
}
