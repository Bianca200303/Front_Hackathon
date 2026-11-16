import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/core/theme/theme_mode_provider.dart';
import 'package:siembra_segura/shared/domain/app_mode.dart';
import 'package:siembra_segura/shared/state/app_mode_provider.dart';
import 'package:siembra_segura/shared/state/campaign_context_provider.dart';
import 'package:siembra_segura/shared/widgets/app_button.dart';
import 'package:siembra_segura/shared/widgets/selection_controls.dart';

/// Botón de Ajustes de cada cabecera: abre [showAppSettings].
class AppSettingsButton extends StatelessWidget {
  /// Crea el botón.
  const AppSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context).settingsTooltip,
      color: context.colors.primary,
      icon: const Icon(Icons.tune_rounded),
      onPressed: () => unawaited(showAppSettings(context)),
    );
  }
}

/// Ajustes: modo de uso, idioma, apariencia y acceso a los datos de la
/// parcela.
Future<void> showAppSettings(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const _SettingsSheet(),
  );
}

/// Solo el selector de idioma (bienvenida de la primera vez).
Future<void> showLanguagePicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const _SheetBody(children: [LanguageOptions()]),
  );
}

/// Nombre de [language] tal como lo escriben sus hablantes.
String languageName(AppLocalizations l10n, AppLanguage language) =>
    switch (language) {
      AppLanguage.spanish => l10n.languageSpanish,
      AppLanguage.english => l10n.languageEnglish,
      AppLanguage.quechua => l10n.languageQuechua,
    };

class _SettingsSheet extends ConsumerWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(appModeProvider);
    return _SheetBody(
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.settingsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        _Section(
          title: l10n.settingsModeTitle,
          child: SegmentedSelector<AppMode>(
            semanticsLabel: l10n.appModeSwitchSemantics,
            selected: mode,
            options: [
              (AppMode.assisted, l10n.appModeAssistedTitle),
              (AppMode.manual, l10n.appModeManualTitle),
            ],
            onChanged: (mode) =>
                unawaited(ref.read(appModeProvider.notifier).select(mode)),
          ),
        ),
        Text(
          mode == AppMode.assisted
              ? l10n.settingsModeAssistedNote
              : l10n.settingsModeManualNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const LanguageOptions(),
        _Section(
          title: l10n.settingsAppearanceTitle,
          child: SegmentedSelector<ThemeMode>(
            semanticsLabel: l10n.themeSwitchSemantics,
            // Solo claro u oscuro; mientras no se elija, se marca el que
            // se ve (el del celular).
            selected: switch (ref.watch(themeModeProvider)) {
              ThemeMode.system =>
                Theme.of(context).brightness == Brightness.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
              final mode => mode,
            },
            options: [
              (ThemeMode.light, l10n.themeLight),
              (ThemeMode.dark, l10n.themeDark),
            ],
            onChanged: (mode) =>
                unawaited(ref.read(themeModeProvider.notifier).select(mode)),
          ),
        ),
        AppButton(
          variant: AppButtonVariant.outline,
          label: l10n.settingsEditFarm,
          onPressed: () {
            Navigator.of(context).pop();
            // En modo asistido, Semi vuelve a preguntar una cosa a la vez.
            unawaited(
              context.push(
                mode == AppMode.assisted ? AppRoutes.farmChat : AppRoutes.farm,
              ),
            );
          },
        ),
        const _DeleteAllButton(),
      ],
    );
  }
}

/// Lista de idiomas: automático (el del celular) o uno elegido a mano.
class LanguageOptions extends ConsumerWidget {
  /// Crea la lista.
  const LanguageOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chosen = ref.watch(languagePreferenceProvider);
    final fromDevice = AppLanguage.resolve(ref.watch(deviceLocalesProvider));
    final inUse = ref.watch(appLanguageProvider);
    void select(AppLanguage? language) => unawaited(
      ref.read(languagePreferenceProvider.notifier).select(language),
    );

    return _Section(
      title: l10n.settingsLanguageTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          RadioOptionTile(
            label: l10n.languageAutomatic(languageName(l10n, fromDevice)),
            selected: chosen == null,
            onTap: () => select(null),
          ),
          for (final language in AppLanguage.values)
            RadioOptionTile(
              label: languageName(l10n, language),
              selected: chosen == language,
              onTap: () => select(language),
            ),
          if (inUse == AppLanguage.quechua)
            Text(l10n.languageQuechuaDraftNote, style: context.text.muted),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: context.text.cardTitle),
        ),
        child,
      ],
    );
  }
}

class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenGutter,
          0,
          AppSpacing.screenGutter,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.lg,
          children: children,
        ),
      ),
    );
  }
}

/// "Borrar todo y empezar de nuevo" (`.borrar` de `semi_app.html`): el
/// primer toque pide confirmar y el segundo borra los datos de la chacra y
/// el modo, y vuelve a la bienvenida.
class _DeleteAllButton extends ConsumerStatefulWidget {
  const _DeleteAllButton();

  @override
  ConsumerState<_DeleteAllButton> createState() => _DeleteAllButtonState();
}

class _DeleteAllButtonState extends ConsumerState<_DeleteAllButton> {
  bool _armed = false;

  void _onTap() {
    if (!_armed) {
      setState(() => _armed = true);
      return;
    }
    final router = GoRouter.of(context);
    ref.read(campaignContextProvider.notifier).reset();
    unawaited(ref.read(appModeProvider.notifier).forget());
    Navigator.of(context).pop();
    router.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return Center(
      child: TextButton(
        onPressed: _onTap,
        style: TextButton.styleFrom(
          foregroundColor: _armed ? colors.onPrimary : colors.negative,
          backgroundColor: _armed ? colors.negative : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(
          _armed ? l10n.deleteAllConfirm : l10n.deleteAll,
          style: TextStyle(
            decoration: _armed ? null : TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
