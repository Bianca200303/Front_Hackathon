import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/shared/domain/agro_vocabulary.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_card.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// "¿A cuál de estas se parece tu tierra?": el agricultor reconoce su suelo
/// en una ilustración y esa respuesta manda sobre la que estima el satélite.
///
/// Cambia cuánta lluvia aprovecha el cultivo, así que al contestar se vuelve
/// a pedir la recomendación. Si no contesta, se usa SoilGrids.
class SoilTextureCard extends ConsumerWidget {
  /// Crea la tarjeta con las texturas de [catalog].
  const SoilTextureCard({required this.catalog, super.key});

  /// Catálogo con la pregunta y las texturas disponibles.
  final CampaignCatalog catalog;

  /// Lado de la ilustración de cada textura, en dp.
  static const swatchSize = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!catalog.asksForSoilTexture) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(
      campaignContextProvider.select((context) => context.soilTexture),
    );
    final notifier = ref.read(campaignContextProvider.notifier);

    return AppCard(
      children: [
        SectionTitle(catalog.soilTextureQuestion),
        MutedText(l10n.farmSoilTextureHint),
        Semantics(
          label: l10n.farmSoilTextureGroupSemantics,
          container: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.sm,
            children: [
              for (final answer in catalog.soilTextures)
                RadioOptionTile(
                  label: answer.name,
                  description: answer.description,
                  leading: _SoilSwatch(texture: answer.texture),
                  selected: answer.texture == selected,
                  onTap: () => notifier.selectSoilTexture(answer.texture),
                ),
              RadioOptionTile(
                label: l10n.farmSoilTextureUnknown,
                description: l10n.farmSoilTextureUnknownHint,
                selected: selected == null,
                onTap: () => notifier.selectSoilTexture(null),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Ilustración de una textura: granos gruesos y sueltos, migas o terrones
/// agrietados.
class _SoilSwatch extends StatelessWidget {
  const _SoilSwatch({required this.texture});

  final SoilTexture texture;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: SoilTextureCard.swatchSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.soilTone.background,
            borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(AppRadii.sm)),
            child: CustomPaint(
              painter: _SoilTexturePainter(
                texture,
                context.colors.soilTone.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoilTexturePainter extends CustomPainter {
  const _SoilTexturePainter(this.texture, this.color);

  final SoilTexture texture;

  /// Color de los granos y grietas (cambia con el modo oscuro).
  final Color color;

  /// Semilla fija: el dibujo no debe cambiar entre reconstrucciones.
  static const _seed = 7;

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(_seed);
    final paint = Paint()..color = color;
    switch (texture) {
      case SoilTexture.sandy:
        _grains(canvas, size, random, paint, count: 90, radius: 0.9);
      case SoilTexture.loamy:
        _grains(canvas, size, random, paint, count: 22, radius: 2.4);
        _grains(canvas, size, random, paint, count: 40, radius: 0.8);
      case SoilTexture.clayey:
        _cracks(canvas, size, random, paint);
    }
  }

  void _grains(
    Canvas canvas,
    Size size,
    Random random,
    Paint paint, {
    required int count,
    required double radius,
  }) {
    for (var i = 0; i < count; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        radius,
        paint,
      );
    }
  }

  void _cracks(Canvas canvas, Size size, Random random, Paint paint) {
    final stroke = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = paint.color.withValues(alpha: 0.18),
    );
    for (var i = 1; i <= 2; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(
        Offset(0, y + random.nextDouble() * 4 - 2),
        Offset(size.width, y + random.nextDouble() * 4 - 2),
        stroke,
      );
      final x = size.width * i / 3;
      canvas.drawLine(
        Offset(x + random.nextDouble() * 4 - 2, 0),
        Offset(x + random.nextDouble() * 4 - 2, size.height),
        stroke,
      );
    }
  }

  @override
  bool shouldRepaint(_SoilTexturePainter oldDelegate) =>
      oldDelegate.texture != texture || oldDelegate.color != color;
}
