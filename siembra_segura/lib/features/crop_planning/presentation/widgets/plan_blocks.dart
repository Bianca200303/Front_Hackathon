import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/crop_planning/domain/crop_planning_models.dart';
import 'package:siembra_segura/features/crop_planning/domain/recommendation.dart';
import 'package:siembra_segura/features/crop_planning/presentation/crop_planning_texts.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/presentation/vocabulary_labels.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';

// Bloques de `semi_app.html` (v4) para "Qué sembrar" y "Rotación".

/// Texto pequeño de sección (`.sobre`).
class Overline extends StatelessWidget {
  /// Crea el texto.
  const Overline(this.text, {this.color, super.key});

  /// Texto.
  final String text;

  /// Color; por defecto, el secundario.
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: color ?? context.colors.textMuted,
    ),
  );
}

/// La franja (`.tira`): cada siembra es un surco de color, de izquierda a
/// derecha, de la próxima siembra a dentro de 2 años.
class CropStrip extends StatelessWidget {
  /// Crea la franja con [crops] (una por siembra).
  const CropStrip({required this.crops, super.key});

  /// Cultivos, en orden.
  final List<Crop> crops;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final small = TextStyle(fontSize: 12, color: colors.textMuted);
    return Semantics(
      label: crops.map((c) => c.name).join(', '),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              spacing: 3,
              children: [
                for (final crop in crops)
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 46),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 4,
                      ),
                      color: crop.tone(colors).background,
                      child: CustomPaint(
                        painter: _FurrowLines(),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            crop.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: crop.tone(colors).foreground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(l10n.stripNext, style: small)),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  l10n.stripLater,
                  style: small,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Rayas verticales suaves, como surcos.
class _FurrowLines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x0F000000);
    for (var x = 0.0; x < size.width + 40; x += 9) {
      canvas.drawRect(Rect.fromLTWH(x - 20, -20, 2, size.height + 40), paint);
    }
  }

  @override
  bool shouldRepaint(_FurrowLines oldDelegate) => false;
}

/// "Te recomiendo" (`.tarjeta.reco`): nombre, franja, tres indicadores y
/// para qué se pensó.
class RecommendationBlock extends StatelessWidget {
  /// Crea el bloque.
  const RecommendationBlock({required this.recommendation, super.key});

  /// Recomendación.
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final r = recommendation;
    final best = r.best;
    final current = r.currentPractice;
    final saved = 1 - best.waterUseM3 / current.waterUseM3;
    return Semantics(
      container: true,
      liveRegion: true,
      child: AppCard(
        variant: AppCardVariant.highlighted,
        children: [
          Overline(l10n.recoOverline),
          Text(
            best.name(l10n),
            style: TextStyle(
              fontSize: 24,
              height: 1.15,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          CropStrip(crops: [for (final s in best.longTermPlan) s.crop]),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.sm,
              children: [
                _Indicator(
                  label: l10n.metricExpectedHarvest,
                  value: AppFormatters.percent(r.bestOutcome.expectedHarvest),
                ),
                _Indicator(
                  label: l10n.metricWater,
                  value: saved >= 0.1
                      ? l10n.waterLess(AppFormatters.percent(saved))
                      : l10n.waterSimilar,
                ),
                _Indicator(
                  label: l10n.recoSoil,
                  value: best.soilInTwoYears.label(l10n),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 12, color: colors.textMuted),
              text: l10n.recoNote(
                r.priority.phrase,
                current.mainCrop.name.toLowerCase(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsetsDirectional.only(start: 10, top: 2, bottom: 2),
        decoration: BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(color: colors.borderStrong, width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: colors.textMuted),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Decide antes del 15 de diciembre" (`.fecha`). Tocarlo abre el
/// calendario de siembra.
class DeadlineBox extends StatelessWidget {
  /// Crea el recuadro.
  const DeadlineBox({required this.deadline, required this.onTap, super.key});

  /// Fecha límite.
  final DateTime deadline;

  /// Abre el calendario.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
    return Semantics(
      button: true,
      child: Material(
        color: colors.primary,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              spacing: AppSpacing.md,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 30,
                  color: colors.onPrimary,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.scheduleDecideBefore,
                        style: TextStyle(fontSize: 14, color: colors.onPrimary),
                      ),
                      Text(
                        AppFormatters.dayAndMonth(deadline),
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: colors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "¿Por qué?" con viñetas y la confianza en cursiva.
class ReasonsSection extends StatelessWidget {
  /// Crea la sección.
  const ReasonsSection({required this.recommendation, super.key});

  /// Recomendación.
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final style = TextStyle(fontSize: 15, height: 1.4, color: colors.textBody);
    return AppCard(
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.whyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        for (final reason in recommendation.reasons(l10n))
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              Text('•', style: style),
              Expanded(child: Text(reason, style: style)),
            ],
          ),
        Text(
          l10n.whyConfidence,
          style: style.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

/// Texto que se despliega al tocar el título (`details.significa`).
class Expandable extends StatefulWidget {
  /// Crea el desplegable.
  const Expandable({required this.title, required this.child, super.key});

  /// Título (verde, tocable).
  final String title;

  /// Lo que se muestra al abrir.
  final Widget child;

  @override
  State<Expandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _open,
          child: InkWell(
            onTap: () => setState(() => _open = !_open),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_open) widget.child,
      ],
    );
  }
}

/// Qué tipo de fila es: define el color de la etiqueta y el fondo.
enum OptionRowKind {
  /// Lo que se siembra hoy.
  current,

  /// La recomendada (franja verde clara).
  recommended,

  /// Otra opción.
  other,

  /// La que armó el agricultor.
  mine,
}

/// Una opción como fila (`.opcion`): etiqueta, franja, cosecha, agua y
/// tierra, y "Ver por qué".
class OptionRow extends StatelessWidget {
  /// Crea la fila.
  const OptionRow({
    required this.kind,
    required this.crops,
    required this.harvest,
    required this.waterM3,
    required this.soil,
    this.factsheet,
    super.key,
  });

  /// Tipo de opción.
  final OptionRowKind kind;

  /// Cultivos de las 4 siembras.
  final List<Crop> crops;

  /// Cosecha esperada (1 = una buena campaña).
  final double harvest;

  /// Agua por hectárea, en m³.
  final int waterM3;

  /// Tierra en 2 años.
  final SoilCondition soil;

  /// Ficha con el porqué (no hay para la que armó el agricultor).
  final OptionFactsheet? factsheet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final (label, labelColor) = switch (kind) {
      OptionRowKind.current => (l10n.optionCurrentLabel, colors.textMuted),
      OptionRowKind.recommended => (
        l10n.optionRecommendedLabel,
        colors.primary,
      ),
      OptionRowKind.other => (l10n.optionOtherLabel, colors.textMuted),
      OptionRowKind.mine => (l10n.optionMineLabel, colors.amber),
    };
    final sheet = factsheet;
    final small = TextStyle(fontSize: 12, color: colors.textMuted);
    final value = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: colors.textPrimary,
    );
    Widget metric(String name, Widget child) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(name, style: small),
          child,
        ],
      ),
    );
    final tone = soil.tone(colors);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: kind == OptionRowKind.recommended
          ? BoxDecoration(color: colors.primarySoft)
          : BoxDecoration(
              border: Border(top: BorderSide(color: colors.borderStrong)),
            ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kind == OptionRowKind.recommended ? 12 : 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: labelColor,
              ),
            ),
            CropStrip(crops: crops),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                metric(
                  l10n.metricHarvestShort,
                  Text(AppFormatters.percent(harvest), style: value),
                ),
                metric(
                  l10n.metricWater,
                  Text(AppFormatters.cubicMeters(waterM3), style: value),
                ),
                metric(
                  l10n.metricSoilInTwoYears,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: tone.background,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      soil.label(l10n),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: tone.foreground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (sheet != null)
              Expandable(
                title: l10n.seeWhy,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.sm,
                  children: [
                    _FichaItem(l10n.fichaWhy, sheet.rationale),
                    _FichaItem(l10n.fichaEvidence, sheet.evidence),
                    _FichaItem(l10n.fichaUnknowns, sheet.unknowns),
                    _FichaItem(l10n.fichaCheck, sheet.risks),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FichaItem extends StatelessWidget {
  const _FichaItem(this.title, this.text);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: colors.textMuted,
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 14, height: 1.45, color: colors.textBody),
        ),
      ],
    );
  }
}

/// "Tu tierra hoy" con el medidor de 3 partes (`.salud`).
class SoilTodaySection extends StatelessWidget {
  /// Crea la sección.
  const SoilTodaySection({required this.recommendation, super.key});

  /// Recomendación (tierra de hoy y lo que se sembró).
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final condition = recommendation.data.soilHealth.condition;
    final current = recommendation.currentPractice;
    final (filled, color) = switch (condition) {
      SoilCondition.good => (3, colors.soilGaugeHigh),
      SoilCondition.regular => (2, colors.soilGaugeMid),
      SoilCondition.tired ||
      SoilCondition.veryTired => (1, colors.soilGaugeLow),
    };
    return AppCard(
      children: [
        Overline(l10n.soilTodayOverline),
        Semantics(
          label: l10n.rotationSoilGaugeSemantics(condition.label(l10n)),
          excludeSemantics: true,
          child: Row(
            spacing: 14,
            children: [
              Text(
                condition.label(l10n),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: condition.tone(colors).foreground,
                ),
              ),
              Expanded(
                child: Row(
                  spacing: 4,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Expanded(
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: i < filled ? color : colors.surfaceMuted,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          l10n.soilReason(
            current.consecutiveCampaigns,
            current.mainCrop.name.toLowerCase(),
          ),
          style: TextStyle(fontSize: 15, color: colors.textBody),
        ),
        Expandable(
          title: l10n.howDoIKnow,
          child: Text(
            l10n.rotationExplainerGreennessBody,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: colors.textBody,
            ),
          ),
        ),
      ],
    );
  }
}
