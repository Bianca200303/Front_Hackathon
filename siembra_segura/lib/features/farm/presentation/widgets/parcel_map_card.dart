import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';

/// Mapa de la parcela con sus datos principales (valle, área y riego).
class ParcelMapCard extends StatelessWidget {
  /// Crea la tarjeta.
  const ParcelMapCard({required this.farm, super.key});

  /// Parcela a mostrar.
  final Farm farm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      variant: AppCardVariant.flush,
      children: [
        _ParcelMap(caption: l10n.farmSatelliteCaption),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            spacing: AppSpacing.sm,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FarmFact(label: l10n.farmValley, value: farm.valleyName),
              _FarmFact(
                label: l10n.farmArea,
                value: l10n.farmAreaValue(
                  AppFormatters.decimal(farm.areaHectares),
                ),
              ),
              _FarmFact(
                label: l10n.farmIrrigation,
                value: farm.irrigationSource,
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

/// Ilustración de la parcela. Se reemplaza por la imagen satelital real
/// cuando el backend la entregue (decisión B4).
class _ParcelMap extends StatelessWidget {
  const _ParcelMap({required this.caption});

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: AppLocalizations.of(context).farmMapSemantics,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 350 / 130,
            child: CustomPaint(painter: _ParcelMapPainter(context.colors)),
          ),
          Positioned(
            left: AppSpacing.md,
            bottom: 10,
            child: ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppRadii.sm),
                  ),
                ),
                child: Text(
                  caption,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reproduce el SVG de la referencia en un lienzo de 350 × 130.
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
