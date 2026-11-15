import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/utils/async_value_combine.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/farm/domain/farm.dart';
import 'package:siembra_segura/features/farm/presentation/providers/farm_providers.dart';
import 'package:siembra_segura/features/farm/presentation/widgets/parcel_map_card.dart';
import 'package:siembra_segura/shared/domain/campaign_catalog.dart';
import 'package:siembra_segura/shared/state/campaign_catalog_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/listen_button.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_avatar.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';

/// "Mi parcela" en modo asistido (`#v-chat` de `semi_app.html`): Semi hace
/// las mismas preguntas que el formulario, una por una, y explica por qué
/// pregunta cada cosa. Guarda lo mismo que "Mi parcela".
class FarmChatScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const FarmChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = combineAsync(
      ref.watch(farmProvider),
      ref.watch(campaignCatalogProvider),
      (farm, catalog) => (farm: farm, catalog: catalog),
    );
    return Scaffold(
      body: AsyncValueView(
        value: content,
        onRetry: () => ref
          ..invalidate(farmProvider)
          ..invalidate(campaignCatalogProvider),
        data: (content) =>
            _Conversation(farm: content.farm, catalog: content.catalog),
      ),
    );
  }
}

/// Una respuesta posible a lo que pregunta Semi.
class _Answer {
  const _Answer(this.label, this.onChosen, {this.primary = false});

  final String label;
  final VoidCallback onChosen;

  /// La acción principal (p. ej., "Ver mi plan").
  final bool primary;
}

/// Lo que dice Semi en un paso de la conversación.
class _Step {
  const _Step({
    required this.expression,
    required this.message,
    required this.answers,
    this.why,
    this.image,
  });

  final SemiExpression expression;
  final String message;

  /// Por qué lo pregunta (texto más pequeño debajo).
  final String? why;

  /// Imagen dentro del globo (p. ej., el mapa de la chacra).
  final Widget? image;
  final List<_Answer> answers;
}

class _Conversation extends ConsumerStatefulWidget {
  const _Conversation({required this.farm, required this.catalog});

  final Farm farm;
  final CampaignCatalog catalog;

  @override
  ConsumerState<_Conversation> createState() => _ConversationState();
}

class _ConversationState extends ConsumerState<_Conversation>
    with SingleTickerProviderStateMixin {
  /// Preguntas antes del cierre (para la barra de progreso).
  static const _questionCount = 4;

  /// Cuánto "piensa" Semi antes de hablar.
  static const _thinkingTime = Duration(milliseconds: 750);

  late final AnimationController _thinking = AnimationController(
    vsync: this,
    duration: _thinkingTime,
  );
  final _scroll = ScrollController();

  int _step = 0;
  String? _lastAnswer;

  /// Respuesta corta de Semi a algo que se le dijo, antes de la siguiente
  /// pregunta (p. ej., "Gracias por decirme…").
  String? _reply;

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Semi piensa antes de la primera pregunta, desde el primer cuadro.
    if (!_started) {
      _started = true;
      _think(rebuild: false);
    }
  }

  @override
  void dispose() {
    _thinking.dispose();
    _scroll.dispose();
    super.dispose();
  }

  bool get _isThinking => _thinking.isAnimating;

  /// Muestra los puntos de "pensando" y después el paso actual. Si el
  /// celular pide reducir el movimiento, va directo al paso.
  void _think({bool rebuild = true}) {
    if (!mounted || MediaQuery.disableAnimationsOf(context)) return;
    unawaited(
      _thinking.forward(from: 0).then((_) {
        if (mounted) setState(() {});
      }),
    );
    if (rebuild) setState(() {});
  }

  void _answer(String label, {VoidCallback? apply, String? reply}) {
    unawaited(ref.read(speechServiceProvider).stop());
    apply?.call();
    setState(() {
      _lastAnswer = label;
      _reply = reply;
      _step++;
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
    _think();
  }

  void _finish() {
    // Abierta desde Ajustes (encima de las pestañas): vuelve ahí.
    if (!(ModalRoute.of(context)?.isFirst ?? true)) {
      context.pop();
    } else {
      context.go(AppRoutes.climate);
    }
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.welcome);
    }
  }

  _Step _currentStep(AppLocalizations l10n) {
    final farm = widget.farm;
    final notifier = ref.read(campaignContextProvider.notifier);
    String lower(String text) => text.toLowerCase();

    final step = switch (_step) {
      0 => _Step(
        expression: SemiExpression.happy,
        message: l10n.chatParcelQuestion(
          farm.valleyName,
          AppFormatters.decimal(farm.areaHectares),
        ),
        why: l10n.chatParcelWhy,
        image: LayoutBuilder(
          builder: (context, constraints) =>
              ParcelMapThumbnail(width: constraints.maxWidth),
        ),
        answers: [
          _Answer(l10n.chatParcelYes, () => _answer(l10n.chatParcelYes)),
          _Answer(
            l10n.chatParcelNo,
            () => _answer(l10n.chatParcelNo, reply: l10n.chatParcelNoReply),
          ),
        ],
      ),
      1 => _Step(
        expression: SemiExpression.thinking,
        message: l10n.chatLastCropQuestion(lower(farm.inferredLastCrop.name)),
        why: l10n.chatLastCropWhy,
        answers: [
          // Primero lo que vio el satélite.
          for (final crop in [
            farm.inferredLastCrop,
            ...farm.lastCropOptions.where(
              (crop) => crop.id != farm.inferredLastCrop.id,
            ),
          ])
            () {
              final label = crop.id == farm.inferredLastCrop.id
                  ? l10n.chatLastCropYes(lower(crop.name))
                  : l10n.chatLastCropNo(lower(crop.name));
              return _Answer(
                label,
                () => _answer(
                  label,
                  apply: () => notifier.selectLastCrop(crop.id),
                ),
              );
            }(),
        ],
      ),
      2 => _Step(
        expression: SemiExpression.happy,
        message: l10n.chatPriorityQuestion,
        why: l10n.chatPriorityWhy,
        answers: [
          for (final priority in widget.catalog.priorities)
            _Answer(
              priority.name,
              () => _answer(
                priority.name,
                apply: () => notifier.selectPriority(priority.id),
              ),
            ),
        ],
      ),
      3 => _Step(
        expression: SemiExpression.happy,
        message: l10n.chatRestrictionQuestion,
        why: l10n.chatRestrictionWhy,
        answers: [
          for (final restriction in widget.catalog.restrictions)
            _Answer(
              restriction.name,
              () => _answer(
                restriction.name,
                apply: () => notifier.setRestrictions({restriction.id}),
              ),
            ),
          _Answer(
            l10n.chatRestrictionNone,
            () => _answer(
              l10n.chatRestrictionNone,
              apply: () => notifier.setRestrictions({}),
            ),
          ),
        ],
      ),
      _ => _Step(
        expression: SemiExpression.celebrating,
        message: l10n.chatDone,
        answers: [_Answer(l10n.actionSeePlan, _finish, primary: true)],
      ),
    };
    final reply = _reply;
    if (reply == null) return step;
    // La respuesta corta va antes de la pregunta, en el mismo globo.
    return _Step(
      expression: step.expression,
      message: '$reply ${step.message}',
      why: step.why,
      image: step.image,
      answers: step.answers,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final step = _currentStep(l10n);
    final thinking = _isThinking;
    final answered = math.min(_step, _questionCount);
    final lastAnswer = _lastAnswer;
    final colors = context.colors;
    // Semi grande, pero sin comerse la pantalla en horizontal.
    final semiSize = math
        .min(170, MediaQuery.sizeOf(context).height * 0.24)
        .toDouble();

    // Escena de `semi_app.html` (#v-chat): todo apoyado abajo, el globo
    // apunta a Semi, que está parado sobre los surcos; las respuestas van
    // en la barra fija de abajo.
    return ColoredBox(
      color: colors.background,
      child: Column(
        children: [
          _ChatHeader(answered: answered, total: _questionCount, onBack: _back),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                controller: _scroll,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppSizes.maxContentWidth,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                            child: thinking
                                ? _ThinkingBubble(animation: _thinking)
                                : _SemiBubble(step: step),
                          ),
                          _SemiStage(
                            size: semiSize,
                            child: SemiAvatar(
                              expression: thinking
                                  ? SemiExpression.thinking
                                  : step.expression,
                              size: semiSize,
                              semanticLabel: l10n.semiAvatarSemantics,
                            ),
                          ),
                          if (lastAnswer != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
                              child: _YouSaid(answer: lastAnswer),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _AnswersBar(answers: thinking ? const [] : step.answers),
        ],
      ),
    );
  }
}

/// Semi parado sobre los surcos de la chacra.
class _SemiStage extends StatelessWidget {
  const _SemiStage({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: size + 30,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            top: null,
            child: SizedBox(
              height: 70,
              child: CustomPaint(painter: _FurrowsPainter(colors)),
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 10), child: child),
        ],
      ),
    );
  }
}

/// Surcos de `semi_app.html` (dos lomas y dos rayas).
class _FurrowsPainter extends CustomPainter {
  _FurrowsPainter(this.colors);

  final AppPalette colors;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    double y(double svg) => svg / 70 * h;
    canvas
      ..drawPath(
        Path()
          ..moveTo(0, h)
          ..lineTo(0, y(34))
          ..quadraticBezierTo(w / 2, y(14), w, y(34))
          ..lineTo(w, h)
          ..close(),
        Paint()..color = colors.furrowLight,
      )
      ..drawPath(
        Path()
          ..moveTo(0, h)
          ..lineTo(0, y(50))
          ..quadraticBezierTo(w / 2, y(32), w, y(50))
          ..lineTo(w, h)
          ..close(),
        Paint()..color = colors.furrowDark,
      );
    final line = Paint()
      ..color = colors.furrowLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas
      ..drawPath(
        Path()
          ..moveTo(w * 0.1, h)
          ..quadraticBezierTo(w / 2, y(40), w * 0.9, h),
        line,
      )
      ..drawPath(
        Path()
          ..moveTo(w * 0.275, h)
          ..quadraticBezierTo(w / 2, y(50), w * 0.725, h),
        line,
      );
  }

  @override
  bool shouldRepaint(_FurrowsPainter oldDelegate) =>
      oldDelegate.colors != colors;
}

/// Respuestas en la barra fija de abajo (`.respuestas`): de a dos si caben,
/// si no, una por fila.
class _AnswersBar extends StatelessWidget {
  const _AnswersBar({required this.answers});

  final List<_Answer> answers;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.background,
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 72,
            maxHeight: MediaQuery.sizeOf(context).height * 0.45,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final scale = MediaQuery.textScalerOf(context).scale(1);
                    final half = (constraints.maxWidth - AppSpacing.sm) / 2;
                    final twoPerRow =
                        half >= 150 * scale &&
                        answers.every((a) => a.label.length <= 24);
                    return Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final (index, answer) in answers.indexed)
                          SizedBox(
                            // El último impar ocupa toda la fila.
                            width:
                                twoPerRow &&
                                    !(index == answers.length - 1 &&
                                        answers.length.isOdd)
                                ? half
                                : constraints.maxWidth,
                            child: _AnswerButton(answer: answer),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({required this.answer});

  final _Answer answer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: colors.primary, width: 2),
    );
    const style = TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    return answer.primary
        ? FilledButton(
            onPressed: answer.onChosen,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: shape,
              textStyle: style,
            ),
            child: Text(answer.label, textAlign: TextAlign.center),
          )
        : OutlinedButton(
            onPressed: answer.onChosen,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: shape,
              side: BorderSide(color: colors.primary, width: 2),
              textStyle: style,
            ),
            child: Text(answer.label, textAlign: TextAlign.center),
          );
  }
}

/// Barra verde de arriba: volver, título y progreso.
class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.answered,
    required this.total,
    required this.onBack,
  });

  final int answered;
  final int total;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: colors.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            AppSpacing.xs,
            AppSpacing.screenGutter,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.sm,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: l10n.actionBack,
                    color: colors.onPrimary,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            l10n.chatTitle,
                            style: textTheme.titleMedium?.copyWith(
                              color: colors.onPrimary,
                            ),
                          ),
                        ),
                        Text(
                          l10n.chatSubtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg),
                child: Semantics(
                  label: l10n.chatProgressSemantics(
                    math.min(answered + 1, total),
                    total,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    child: LinearProgressIndicator(
                      value: answered / total,
                      minHeight: 6,
                      color: colors.focus,
                      backgroundColor: colors.onPrimary.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Forma del globo: la esquina de abajo a la izquierda "sale" de Semi.
const _bubbleShape = BorderRadius.all(Radius.circular(18));

/// Globo de Semi: imagen opcional, mensaje, por qué y "Escuchar".
class _SemiBubble extends StatelessWidget {
  const _SemiBubble({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final why = step.why;
    final image = step.image;
    final spoken = why == null ? step.message : '${step.message} $why';
    // `.globo-semi`: borde marcado y una punta que baja hacia Semi.
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: _bubbleShape,
            border: Border.all(color: colors.borderStrong, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                ?image,
                Semantics(
                  liveRegion: true,
                  child: Text(
                    step.message,
                    style: TextStyle(
                      fontSize: 19,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (why != null)
                  Text(
                    why,
                    style: TextStyle(fontSize: 15, color: colors.textMuted),
                  ),
                ListenButton(text: spoken),
              ],
            ),
          ),
        ),
        CustomPaint(
          size: const Size(24, 12),
          painter: _BubbleTipPainter(colors),
        ),
      ],
    );
  }
}

/// Globo con tres puntos mientras Semi "piensa".
class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Semantics(
        label: AppLocalizations.of(context).chatThinkingSemantics,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: _bubbleShape,
            border: Border.all(color: colors.semiGuideBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.sm,
                children: [
                  for (var i = 0; i < 3; i++)
                    Opacity(
                      // Cada punto se enciende un poco después del anterior.
                      opacity:
                          0.35 +
                          0.65 *
                              (0.5 +
                                  0.5 *
                                      math.sin(
                                        (animation.value * 3 - i / 3) *
                                            2 *
                                            math.pi,
                                      )),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lo que respondió el agricultor, a la derecha.
class _YouSaid extends StatelessWidget {
  const _YouSaid({required this.answer});

  final String answer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Semantics(
        label: AppLocalizations.of(context).chatYouSaid(answer),
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.primarySoft,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Text(
              answer,
              style: context.text.option.copyWith(color: colors.primaryDark),
            ),
          ),
        ),
      ),
    );
  }
}

/// Punta del globo, hacia Semi.
class _BubbleTipPainter extends CustomPainter {
  _BubbleTipPainter(this.colors);

  final AppPalette colors;

  @override
  void paint(Canvas canvas, Size size) {
    final tip = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);
    canvas
      ..drawPath(tip, Paint()..color = colors.surface)
      ..drawPath(
        tip,
        Paint()
          ..color = colors.borderStrong
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
  }

  @override
  bool shouldRepaint(_BubbleTipPainter oldDelegate) =>
      oldDelegate.colors != colors;
}
