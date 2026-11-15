import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/features/climate/domain/climate_overview.dart';
import 'package:siembra_segura/features/climate/presentation/climate_labels.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/explainer_tile.dart';
import 'package:siembra_segura/shared/widgets/status_pill.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "Comparado con un año normal".
class AnomalyComparisonCard extends StatelessWidget {
  /// Crea la tarjeta.
  const AnomalyComparisonCard({required this.anomalies, super.key});

  /// Indicadores a comparar.
  final List<ClimateAnomaly> anomalies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      children: [
        SectionTitle(l10n.climateComparisonTitle),
        Column(
          spacing: AppSpacing.md,
          children: [
            for (final anomaly in anomalies) _AnomalyRow(anomaly: anomaly),
          ],
        ),
        SourceNote(l10n.climateComparisonNote),
        ExplainerTile(
          title: l10n.whatDoesItMean,
          framed: false,
          children: [
            TermDefinition(
              term: l10n.climateExplainerSoilMoistureTerm,
              definition: l10n.climateExplainerSoilMoistureBody,
            ),
            TermDefinition(
              term: l10n.climateExplainerNormalTerm,
              definition: l10n.climateExplainerNormalBody,
            ),
            TermDefinition(
              term: l10n.climateExplainerSatelliteTerm,
              definition: l10n.climateExplainerSatelliteBody,
            ),
          ],
        ),
      ],
    );
  }
}

class _AnomalyRow extends StatelessWidget {
  const _AnomalyRow({required this.anomaly});

  final ClimateAnomaly anomaly;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final metric = anomaly.metricLabel(l10n);
    final status = anomaly.statusLabel(l10n);
    return Semantics(
      label: l10n.anomalyBarSemantics(metric, status),
      excludeSemantics: true,
      child: Column(
        spacing: 6,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Text(
                  metric,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              StatusPill(
                label: status,
                tone: anomaly.statusTone(context.colors),
              ),
            ],
          ),
          ComparisonBar(
            value: anomaly.observedLevel,
            marker: anomaly.normalLevel,
            color: anomaly.barColor(context.colors),
          ),
        ],
      ),
    );
  }
}

/// Barra con valor observado y una raya que marca lo normal.
class ComparisonBar extends StatelessWidget {
  /// Crea la barra.
  const ComparisonBar({
    required this.value,
    required this.marker,
    required this.color,
    super.key,
  });

  /// Entre 0 y 1.
  final double value;

  /// Posición de la marca de "lo normal", entre 0 y 1.
  final double marker;

  /// Color del relleno.
  final Color color;

  static const _height = 10.0;
  static const _radius = BorderRadius.all(Radius.circular(5));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceMuted,
                    borderRadius: _radius,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: width * value.clamp(0, 1),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: _radius,
                  ),
                ),
              ),
              Positioned(
                left: width * marker.clamp(0, 1) - 1,
                top: -4,
                bottom: -4,
                width: 2,
                child: ColoredBox(color: context.colors.textPrimary),
              ),
            ],
          );
        },
      ),
    );
  }
}
