import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/theme/theme_mode_provider.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/state/app_mode_provider.dart';
import 'package:siembra_segura/shared/widgets/app_settings.dart';
import 'package:siembra_segura/shared/widgets/constrained_content.dart';
import 'package:siembra_segura/shared/widgets/listen_button.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_avatar.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';

/// Bienvenida de la primera vez (`#v-inicio` de `semi_app.html`): Semi se
/// presenta y se elige cómo empezar. Arriba se puede cambiar el idioma y
/// poner la pantalla clara u oscura antes de nada.
class WelcomeScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spoken =
        '${l10n.welcomeTitle}. ${l10n.welcomeBody} ${l10n.welcomeQuestion} '
        '${l10n.welcomeAssistedTitle}. ${l10n.welcomeManualTitle}.';

    void choose(AppMode mode) {
      unawaited(ref.read(appModeProvider.notifier).select(mode));
      // Asistido: Semi pregunta una cosa a la vez. Manual: el formulario.
      context.go(
        mode == AppMode.assisted ? AppRoutes.farmChat : AppRoutes.farm,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenGutter,
            AppSpacing.sm,
            AppSpacing.screenGutter,
            AppSpacing.xxl,
          ),
          child: ConstrainedContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.lg,
              children: [
                const _TopActions(),
                _Greeting(title: l10n.welcomeTitle, body: l10n.welcomeBody),
                Text(l10n.welcomeAiNote, style: context.text.caption),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ListenButton(text: spoken),
                ),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.welcomeQuestion,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _ModeButton(
                  icon: Icons.smart_toy_outlined,
                  title: l10n.welcomeAssistedTitle,
                  body: l10n.welcomeAssistedBody,
                  onTap: () => choose(AppMode.assisted),
                ),
                _ModeButton(
                  icon: Icons.edit_note_rounded,
                  title: l10n.welcomeManualTitle,
                  body: l10n.welcomeManualBody,
                  onTap: () => choose(AppMode.manual),
                ),
                Text(
                  l10n.welcomeChangeLater,
                  style: context.text.caption.copyWith(color: colors.textMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Idioma y claro/oscuro, arriba a la derecha.
class _TopActions extends ConsumerWidget {
  const _TopActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final language = ref.watch(appLanguageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.language_rounded),
          label: Text(l10n.languageButton(languageName(l10n, language))),
          onPressed: () => unawaited(showLanguagePicker(context)),
        ),
        IconButton.outlined(
          tooltip: isDark ? l10n.themeToLight : l10n.themeToDark,
          color: context.colors.textPrimary,
          style: IconButton.styleFrom(
            side: BorderSide(color: context.colors.borderStrong),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
          onPressed: () => unawaited(
            ref
                .read(themeModeProvider.notifier)
                .select(isDark ? ThemeMode.light : ThemeMode.dark),
          ),
        ),
      ],
    );
  }
}

/// Semi grande con su globo de saludo. En pantallas angostas o con letra
/// muy grande, el globo va debajo de Semi.
class _Greeting extends StatelessWidget {
  const _Greeting({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bubble = DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadii.card,
        border: Border.all(color: context.colors.semiGuideBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xs,
          children: [
            Semantics(
              header: true,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Text(body, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
    final semi = SemiAvatar(
      expression: SemiExpression.happy,
      size: 120,
      semanticLabel: l10n.semiAvatarSemantics,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow =
            constraints.maxWidth < MediaQuery.textScalerOf(context).scale(340);
        if (narrow) {
          return Column(
            spacing: AppSpacing.sm,
            children: [
              semi,
              SizedBox(width: double.infinity, child: bubble),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            semi,
            // El globo queda arriba, a la altura de la cara de Semi.
            Expanded(child: bubble),
          ],
        );
      },
    );
  }
}

/// Opción grande para elegir el modo (`.modo` de `semi_app.html`).
class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadii.card,
      side: BorderSide(color: colors.borderStrong),
    );
    return Semantics(
      button: true,
      container: true,
      child: Material(
        color: colors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              spacing: AppSpacing.md,
              children: [
                Icon(icon, size: 32, color: colors.primary),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xxs,
                    children: [
                      Text(title, style: context.text.cardTitle),
                      Text(body, style: context.text.muted),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
