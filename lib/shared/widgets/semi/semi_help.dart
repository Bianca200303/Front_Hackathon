import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/theme/theme_mode_provider.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/state/app_mode_provider.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/app_settings.dart';
import 'package:siembra_segura/shared/widgets/listen_button.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_avatar.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';

/// Pestaña desde la que se pide ayuda: define qué preguntas aparecen en
/// "Qué significa".
enum HelpSection {
  /// Clima.
  climate,

  /// Qué sembrar.
  whatToPlant,

  /// Rotación.
  rotation,

  /// Avisos.
  alerts,
}

/// Botón "Ayuda" con la cara de Semi (`.semi-fab` de `semi_app.html`).
class SemiHelpButton extends StatelessWidget {
  /// Crea el botón para la pestaña [section].
  const SemiHelpButton({required this.section, super.key});

  /// Pestaña actual.
  final HelpSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return Semantics(
      label: l10n.helpButtonSemantics,
      button: true,
      excludeSemantics: true,
      child: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => unawaited(showSemiHelp(context, section)),
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 3,
        shape: StadiumBorder(side: BorderSide(color: colors.semiGuideBorder)),
        icon: const SemiAvatar.head(expression: SemiExpression.happy, size: 36),
        label: Text(l10n.helpButton, style: AppTypography.compactButton),
      ),
    );
  }
}

/// "Pregúntale a Semi": preguntas y respuestas fijas, sin IA (funcionan sin
/// internet y siempre responden lo mismo).
Future<void> showSemiHelp(BuildContext context, HelpSection section) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.colors.semiGuideBackground,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.92,
    ),
    builder: (context) => _SemiHelpSheet(section: section),
  );
}

/// Una pregunta que se le puede hacer a Semi.
class _Topic {
  const _Topic({
    required this.question,
    required this.keywords,
    required this.respond,
    this.expression = SemiExpression.happy,
    this.action,
  });

  final String question;

  /// Palabras con las que se encuentra al escribir (separadas por comas).
  final String keywords;

  /// Hace lo que se pidió (si hay algo que hacer) y devuelve la respuesta.
  final String Function() respond;

  final SemiExpression expression;

  /// Botón opcional bajo la respuesta (p. ej., "Elegir idioma").
  final (String, VoidCallback)? action;
}

class _SemiHelpSheet extends ConsumerStatefulWidget {
  const _SemiHelpSheet({required this.section});

  final HelpSection section;

  @override
  ConsumerState<_SemiHelpSheet> createState() => _SemiHelpSheetState();
}

class _SemiHelpSheetState extends ConsumerState<_SemiHelpSheet> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  String? _answer;
  String? _asked;
  SemiExpression _expression = SemiExpression.happy;
  (String, VoidCallback)? _action;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _topicName(AppLocalizations l10n) => switch (widget.section) {
    HelpSection.climate => l10n.helpTopicClimate,
    HelpSection.whatToPlant => l10n.helpTopicWhatToPlant,
    HelpSection.rotation => l10n.helpTopicRotation,
    HelpSection.alerts => l10n.helpTopicAlerts,
  };

  /// Preguntas por grupo: qué significa (según la pestaña), cambiar algo y
  /// cómo se usa.
  ({
    List<_Topic> meaning,
    List<_Topic> change,
    List<_Topic> howTo,
    List<_Topic> all,
  })
  _topics(AppLocalizations l10n) {
    _Topic info(String q, String a, String k) =>
        _Topic(question: q, keywords: k, respond: () => a);

    final probable = info(
      l10n.helpProbableQ,
      l10n.helpProbableA,
      l10n.helpProbableK,
    );
    final source = info(l10n.helpSourceQ, l10n.helpSourceA, l10n.helpSourceK);
    final rainMm = info(l10n.helpRainMmQ, l10n.helpRainMmA, l10n.helpRainMmK);
    final moisture = info(
      l10n.helpMoistureQ,
      l10n.helpMoistureA,
      l10n.helpMoistureK,
    );
    final harvest = info(
      l10n.helpHarvestQ,
      l10n.helpHarvestA,
      l10n.helpHarvestK,
    );
    final water = info(l10n.helpWaterQ, l10n.helpWaterA, l10n.helpWaterK);
    final soil = info(l10n.helpSoilQ, l10n.helpSoilA, l10n.helpSoilK);
    final deadline = info(
      l10n.helpDeadlineQ,
      l10n.helpDeadlineA,
      l10n.helpDeadlineK,
    );
    final blocks = info(l10n.helpBlocksQ, l10n.helpBlocksA, l10n.helpBlocksK);
    final rotate = info(l10n.helpRotateQ, l10n.helpRotateA, l10n.helpRotateK);
    final greenManure = info(
      l10n.helpGreenManureQ,
      l10n.helpGreenManureA,
      l10n.helpGreenManureK,
    );
    final alerts = _Topic(
      question: l10n.helpAlertsQ,
      keywords: l10n.helpAlertsK,
      expression: SemiExpression.alert,
      respond: () => l10n.helpAlertsA,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mode = ref.read(appModeProvider);
    final theme = _Topic(
      question: isDark ? l10n.helpToLightQ : l10n.helpToDarkQ,
      keywords: l10n.helpThemeK,
      expression: SemiExpression.celebrating,
      respond: () {
        unawaited(
          ref
              .read(themeModeProvider.notifier)
              .select(isDark ? ThemeMode.light : ThemeMode.dark),
        );
        return isDark ? l10n.helpToLightA : l10n.helpToDarkA;
      },
    );
    final toManual = mode == AppMode.assisted;
    final modeTopic = _Topic(
      question: toManual ? l10n.helpToManualQ : l10n.helpToAssistedQ,
      keywords: l10n.helpModeK,
      expression: SemiExpression.celebrating,
      respond: () {
        unawaited(
          ref
              .read(appModeProvider.notifier)
              .select(toManual ? AppMode.manual : AppMode.assisted),
        );
        return toManual ? l10n.helpToManualA : l10n.helpToAssistedA;
      },
    );
    final farm = _Topic(
      question: l10n.helpFarmQ,
      keywords: l10n.helpFarmK,
      respond: () => l10n.helpFarmA,
      action: (
        l10n.actionChange,
        () {
          final router = GoRouter.of(context);
          final assisted = ref.read(appModeProvider) == AppMode.assisted;
          Navigator.of(context).pop();
          unawaited(
            router.push(assisted ? AppRoutes.farmChat : AppRoutes.farm),
          );
        },
      ),
    );
    final language = _Topic(
      question: l10n.helpLanguageQ,
      keywords: l10n.helpLanguageK,
      respond: () => l10n.helpLanguageA,
      action: (
        l10n.helpLanguageAction,
        () => unawaited(showLanguagePicker(context)),
      ),
    );
    final listen = info(l10n.helpListenQ, l10n.helpListenA, l10n.helpListenK);

    return (
      meaning: switch (widget.section) {
        HelpSection.climate => [probable, source, rainMm, moisture],
        HelpSection.whatToPlant => [harvest, water, soil, deadline],
        HelpSection.rotation => [blocks, rotate, greenManure, water],
        HelpSection.alerts => [alerts, source],
      },
      change: [theme, modeTopic, farm, language],
      howTo: [listen],
      // Al escribir se busca en todas, no solo en las de esta pestaña.
      all: [
        probable,
        source,
        rainMm,
        moisture,
        harvest,
        water,
        soil,
        deadline,
        blocks,
        rotate,
        greenManure,
        alerts,
        theme,
        modeTopic,
        farm,
        language,
        listen,
      ],
    );
  }

  void _respond(_Topic topic, String asked) {
    final answer = topic.respond();
    setState(() {
      _asked = asked;
      _answer = answer;
      _expression = topic.expression;
      _action = topic.action;
    });
    _showAnswer();
  }

  /// Sube hasta la respuesta: la pregunta pudo tocarse más abajo.
  void _showAnswer() {
    if (!_scroll.hasClients) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(0);
    } else {
      unawaited(
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  /// Busca la pregunta cuyas palabras clave aparecen en [text] (sin
  /// mayúsculas ni tildes); gana la que más letras coinciden.
  void _ask(String text, List<_Topic> all, AppLocalizations l10n) {
    final asked = text.trim();
    if (asked.isEmpty) return;
    _input.clear();
    final normalized = normalizeForSearch(asked);
    _Topic? best;
    var bestScore = 0;
    for (final topic in all) {
      var score = 0;
      for (final keyword in topic.keywords.split(',')) {
        final key = normalizeForSearch(keyword.trim());
        if (key.isNotEmpty && normalized.contains(key)) score += key.length;
      }
      if (score > bestScore) {
        bestScore = score;
        best = topic;
      }
    }
    final found = best;
    if (found != null) {
      _respond(found, asked);
    } else {
      setState(() {
        _asked = asked;
        _answer = l10n.helpUnknown;
        _expression = SemiExpression.thinking;
        _action = null;
      });
      _showAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topics = _topics(l10n);
    final answer = _answer ?? l10n.helpIntro(_topicName(l10n));
    final asked = _asked;
    final action = _action;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenGutter,
            0,
            AppSpacing.screenGutter,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.lg,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.helpTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.helpClose,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              if (asked != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    l10n.helpYouAsked(asked),
                    style: context.text.muted,
                    textAlign: TextAlign.end,
                  ),
                ),
              _Answer(text: answer, expression: _expression),
              if (action != null)
                AppButton(label: action.$1, onPressed: action.$2),
              _Group(
                title: l10n.helpGroupMeaning,
                topics: topics.meaning,
                onTap: _respond,
              ),
              _Group(
                title: l10n.helpGroupChange,
                topics: topics.change,
                onTap: _respond,
              ),
              _Group(
                title: l10n.helpGroupHowTo,
                topics: topics.howTo,
                onTap: _respond,
              ),
              _AskField(
                controller: _input,
                onAsk: (text) => _ask(text, topics.all, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sin mayúsculas ni tildes, para comparar lo que se escribe con las
/// palabras clave ("Abono Verde" = "abono verde", "satélite" = "satelite").
@visibleForTesting
String normalizeForSearch(String text) {
  const from = 'áàäâéèëêíìïîóòöôúùüûñ';
  const to = 'aaaaeeeeiiiioooouuuun';
  final buffer = StringBuffer();
  for (final char in text.toLowerCase().split('')) {
    final index = from.indexOf(char);
    buffer.write(index < 0 ? char : to[index]);
  }
  return buffer.toString();
}

/// Semi con su respuesta y "Escuchar".
class _Answer extends StatelessWidget {
  const _Answer({required this.text, required this.expression});

  final String text;
  final SemiExpression expression;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: AppSpacing.md,
      children: [
        SemiAvatar(
          expression: expression,
          size: 84,
          semanticLabel: AppLocalizations.of(context).semiAvatarSemantics,
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadii.card,
              border: Border.all(color: colors.semiGuideBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  ListenButton(text: text),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Un grupo de preguntas con su título.
class _Group extends StatelessWidget {
  const _Group({
    required this.title,
    required this.topics,
    required this.onTap,
  });

  final String title;
  final List<_Topic> topics;
  final void Function(_Topic topic, String asked) onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Semantics(
          header: true,
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final topic in topics)
              Material(
                color: colors.surface,
                shape: StadiumBorder(
                  side: BorderSide(color: colors.borderStrong),
                ),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => onTap(topic, topic.question),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AppSizes.minTouchTarget,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          topic.question,
                          style: AppTypography.chip.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Campo para escribir una pregunta.
class _AskField extends StatelessWidget {
  const _AskField({required this.controller, required this.onAsk});

  final TextEditingController controller;
  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final field = TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onAsk,
      decoration: InputDecoration(
        labelText: l10n.messageInputLabel,
        hintText: l10n.helpInputHint,
      ),
    );
    final button = AppButton(
      label: l10n.helpAsk,
      compact: true,
      onPressed: () => onAsk(controller.text),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        // Con letra grande o pantalla angosta, el botón va debajo.
        if (constraints.maxWidth <
            MediaQuery.textScalerOf(context).scale(420)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.sm,
            children: [field, button],
          );
        }
        return Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(child: field),
            SizedBox(width: 140, child: button),
          ],
        );
      },
    );
  }
}
