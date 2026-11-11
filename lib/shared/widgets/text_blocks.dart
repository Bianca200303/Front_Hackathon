import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';

/// Título de sección dentro de una tarjeta (h2).
class SectionTitle extends StatelessWidget {
  /// Crea el título.
  const SectionTitle(this.text, {this.color, super.key});

  /// Texto del título.
  final String text;

  /// Color; por defecto, el del tema.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
      ),
    );
  }
}

/// Texto en mayúsculas pequeño sobre un bloque (`.sobre`).
class OverlineText extends StatelessWidget {
  /// Crea el texto.
  const OverlineText(this.text, {this.color, super.key});

  /// Texto (se muestra tal cual; suele venir en mayúsculas).
  final String text;

  /// Color; por defecto, el atenuado.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
    );
  }
}

/// Texto secundario (`.suave`).
class MutedText extends StatelessWidget {
  /// Crea el texto.
  const MutedText(this.text, {super.key});

  /// Texto a mostrar.
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: AppTypography.muted);
}

/// Texto con un fragmento resaltado (p. ej., "Pensando en: **ganar más**").
///
/// El fragmento se busca dentro del texto ya traducido, así el orden de las
/// palabras lo decide el ARB y no el código.
class HighlightedText extends StatelessWidget {
  /// Crea el texto con una parte destacada.
  const HighlightedText({
    required this.text,
    required this.highlight,
    this.style,
    this.highlightStyle = const TextStyle(fontWeight: FontWeight.w700),
    super.key,
  });

  /// Texto completo.
  final String text;

  /// Parte de [text] a destacar (la primera aparición).
  final String highlight;

  /// Estilo base.
  final TextStyle? style;

  /// Estilo que se combina sobre la parte destacada.
  final TextStyle highlightStyle;

  @override
  Widget build(BuildContext context) {
    final start = highlight.isEmpty ? -1 : text.indexOf(highlight);
    if (start < 0) return Text(text, style: style);
    final end = start + highlight.length;
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, start)),
          TextSpan(text: highlight, style: highlightStyle),
          TextSpan(text: text.substring(end)),
        ],
      ),
    );
  }
}

/// Término en negrita seguido de su explicación.
class TermDefinition extends StatelessWidget {
  /// Crea la definición.
  const TermDefinition({
    required this.term,
    required this.definition,
    this.termColor,
    this.style,
    super.key,
  });

  /// Término en negrita (p. ej., "Verdor:").
  final String term;

  /// Explicación del término.
  final String definition;

  /// Color del término.
  final Color? termColor;

  /// Estilo del conjunto; por defecto, [AppTypography.bodyCompact].
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style ?? AppTypography.bodyCompact,
        children: [
          TextSpan(
            text: '$term ',
            style: TextStyle(fontWeight: FontWeight.w800, color: termColor),
          ),
          TextSpan(text: definition),
        ],
      ),
    );
  }
}

/// Lista con viñetas (`.razones`).
class BulletList extends StatelessWidget {
  /// Crea la lista.
  const BulletList({required this.items, super.key});

  /// Elementos, en orden.
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        for (final item in items)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text('•', style: style),
                ),
              ),
              Expanded(child: Text(item, style: style)),
            ],
          ),
      ],
    );
  }
}

/// Nota de fuente de datos (`.nota`). Si la app usa datos de ejemplo, lo
/// indica, como hacía la referencia con "Cifras de ejemplo".
class SourceNote extends ConsumerWidget {
  /// Crea la nota.
  const SourceNote(this.text, {super.key});

  /// Fuente de los datos; puede estar vacía.
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usesMocks = ref.watch(appConfigProvider).usesMocks;
    final disclaimer = AppLocalizations.of(context).sampleDataDisclaimer;
    final content = [
      if (text.isNotEmpty) text,
      if (usesMocks) disclaimer,
    ].join(' ');
    if (content.isEmpty) return const SizedBox.shrink();
    return Text(content, style: Theme.of(context).textTheme.bodySmall);
  }
}

/// Aviso de que la app es una guía (`.guia`).
class GuideDisclaimer extends StatelessWidget {
  /// Crea el aviso.
  const GuideDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.all(Radius.circular(AppRadii.md)),
      ),
      child: Text(
        AppLocalizations.of(context).guideDisclaimer,
        style: AppTypography.caption,
      ),
    );
  }
}

/// Consejo destacado en verde (`.consejo`).
class AdviceBox extends StatelessWidget {
  /// Crea el recuadro.
  const AdviceBox({required this.lead, required this.text, super.key});

  /// Inicio en negrita (p. ej., "Consejo:").
  final String lead;

  /// Consejo.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.adviceTone.background,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadii.lg)),
      ),
      child: TermDefinition(
        term: lead,
        definition: text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.adviceTone.foreground,
        ),
      ),
    );
  }
}
