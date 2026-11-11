import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';
import 'package:siembra_segura/shared/widgets/constrained_content.dart';
import 'package:siembra_segura/shared/widgets/listen_button.dart';

/// Esqueleto común de pantalla: cabecera fija, cuerpo desplazable y pie
/// opcional siempre visible (`.pie` en la referencia).
class ScreenLayout extends StatelessWidget {
  /// Crea el esqueleto de pantalla.
  const ScreenLayout({
    required this.body,
    this.header,
    this.footer,
    this.backgroundColor,
    this.wide = false,
    super.key,
  });

  /// Cabecera fija (normalmente [ScreenHeader]).
  final Widget? header;

  /// Contenido desplazable (normalmente [ScreenContent]).
  final Widget body;

  /// Acción principal siempre visible al pie (`.pie`).
  final Widget? footer;

  /// Fondo de la pantalla; por defecto, el del tema.
  final Color? backgroundColor;

  /// Permite un contenido más ancho en tablets para pantallas que usan
  /// `ResponsiveColumns`. Las pantallas de lectura lineal lo dejan en
  /// `false` para no alargar las líneas de texto.
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final maxWidth = wide
        ? AppSizes.maxWideContentWidth
        : AppSizes.maxContentWidth;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: footer == null,
        child: ConstrainedContent(
          maxWidth: maxWidth,
          child: Column(
            children: [
              ?header,
              Expanded(child: body),
            ],
          ),
        ),
      ),
      bottomNavigationBar: footer == null
          ? null
          : SafeArea(
              top: false,
              child: ConstrainedContent(
                maxWidth: maxWidth,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenGutter,
                    AppSpacing.lg,
                    AppSpacing.screenGutter,
                    AppSpacing.xxl,
                  ),
                  child: footer,
                ),
              ),
            ),
    );
  }
}

/// Lista desplazable con la separación estándar entre bloques.
class ScreenContent extends StatelessWidget {
  /// Crea la lista.
  const ScreenContent({required this.children, this.onRefresh, super.key});

  /// Bloques de la pantalla, en orden.
  final List<Widget> children;

  /// Si se indica, habilita "deslizar para actualizar".
  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final list = ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        AppSpacing.xs,
        AppSpacing.screenGutter,
        AppSpacing.xxl,
      ),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sectionGap),
      itemBuilder: (_, index) => children[index],
    );
    final refresh = onRefresh;
    return refresh == null
        ? list
        : RefreshIndicator(onRefresh: refresh, child: list);
  }
}

/// Cabecera de pantalla (`.barra`): título o marca a la izquierda y botón
/// "Escuchar" a la derecha.
class ScreenHeader extends StatelessWidget {
  /// Crea la cabecera; necesita [title] o [leading].
  const ScreenHeader({
    this.title,
    this.subtitle,
    this.leading,
    this.listenText,
    this.showListen = true,
    this.actions = const [],
    super.key,
  }) : assert(title != null || leading != null);

  /// Cabecera con la marca de la app.
  const ScreenHeader.brand({String? listenText, Key? key})
    : this(leading: const BrandMark(), listenText: listenText, key: key);

  /// Cabecera con botón de volver. Si no hay historial, navega a
  /// [fallbackLocation].
  ScreenHeader.back({
    required String fallbackLocation,
    String? listenText,
    Key? key,
  }) : this(
         leading: Align(
           alignment: AlignmentDirectional.centerStart,
           child: AppBackButton(fallbackLocation: fallbackLocation),
         ),
         listenText: listenText,
         key: key,
       );

  /// Título de la pantalla, si no hay [leading].
  final String? title;

  /// Texto pequeño sobre el título (p. ej., el nombre del valle).
  final String? subtitle;

  /// Contenido a la izquierda en lugar del título (marca, volver).
  final Widget? leading;

  /// Texto que lee "Escuchar"; `null` lo deshabilita.
  final String? listenText;

  /// Si es `false`, no se muestra "Escuchar".
  final bool showListen;

  /// Botones de icono extra a la derecha, antes de "Escuchar" (p. ej.,
  /// `FarmSettingsButton`).
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        AppSpacing.lg,
        AppSpacing.screenGutter,
        10,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Ancho aproximado del botón "Escuchar" con texto. Si ocupa más
          // del 40 % de la cabecera, se muestra solo el icono.
          final listenWidth = MediaQuery.textScalerOf(context).scale(120);
          final available =
              constraints.maxWidth - actions.length * AppSizes.minTouchTarget;
          final compactListen = listenWidth > available * 0.4;
          return Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child:
                    leading ?? ScreenTitle(title: title!, subtitle: subtitle),
              ),
              ...actions,
              if (showListen)
                ListenButton(text: listenText, compact: compactListen),
            ],
          );
        },
      ),
    );
  }
}

/// Título de pantalla (h1) con subtítulo opcional encima.
class ScreenTitle extends StatelessWidget {
  /// Crea el título.
  const ScreenTitle({required this.title, this.subtitle, super.key});

  /// Título principal.
  final String title;

  /// Texto pequeño sobre el título.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleText = subtitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (subtitleText != null)
          Text(subtitleText, style: AppTypography.muted),
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.headlineMedium),
        ),
      ],
    );
  }
}

/// Botón "Volver". Si no hay historial, navega a [fallbackLocation].
class AppBackButton extends StatelessWidget {
  /// Crea el botón.
  const AppBackButton({
    required this.fallbackLocation,
    this.color = AppColors.textPrimary,
    super.key,
  });

  /// Ruta a la que ir si no hay pantalla anterior.
  final String fallbackLocation;

  /// Color del icono.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context).actionBack,
      color: color,
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () =>
          context.canPop() ? context.pop() : context.go(fallbackLocation),
    );
  }
}

/// Logo y nombre de la app.
class BrandMark extends StatelessWidget {
  /// Crea la marca.
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        const AppLogo(),
        Flexible(
          child: Text(
            AppLocalizations.of(context).appTitle,
            style: AppTypography.cardTitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Logo de la app (hoja sobre fondo verde).
class AppLogo extends StatelessWidget {
  /// Crea el logo.
  const AppLogo({
    this.size = 36,
    this.background = AppColors.primary,
    this.foreground = AppColors.onPrimary,
    this.circular = false,
    super.key,
  });

  /// Lado del logo, en dp.
  final double size;

  /// Color de fondo.
  final Color background;

  /// Color de la hoja.
  final Color foreground;

  /// Si es `true`, círculo; si no, cuadrado redondeado.
  final bool circular;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(circular ? size / 2 : 10),
        ),
        child: Icon(Icons.eco_rounded, color: foreground, size: size * 0.56),
      ),
    );
  }
}
