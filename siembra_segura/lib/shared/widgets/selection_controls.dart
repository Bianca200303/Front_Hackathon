import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/core/theme/app_typography.dart';

/// Cómo anuncia su estado un control seleccionable a los lectores de
/// pantalla (equivale a `role="radio"` / `aria-pressed` de la referencia).
enum SelectionRole {
  /// Una opción entre varias excluyentes.
  radio,

  /// Interruptor independiente (encendido / apagado).
  toggle,
}

class _SelectionSemantics extends StatelessWidget {
  const _SelectionSemantics({
    required this.role,
    required this.selected,
    required this.child,
  });

  final SelectionRole role;
  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      inMutuallyExclusiveGroup: role == SelectionRole.radio ? true : null,
      checked: role == SelectionRole.radio ? selected : null,
      toggled: role == SelectionRole.toggle ? selected : null,
      child: child,
    );
  }
}

/// Chip con forma de píldora (`.chip` / `.chip.activo`).
class SelectableChip extends StatelessWidget {
  /// Crea el chip.
  const SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.role = SelectionRole.radio,
    this.badge,
    super.key,
  });

  /// Texto del chip.
  final String label;

  /// Si está seleccionado.
  final bool selected;

  /// Acción al tocar.
  final VoidCallback onTap;

  /// Cómo lo anuncian los lectores de pantalla.
  final SelectionRole role;

  /// Etiqueta pequeña junto al texto (p. ej., "Satélite" en lo que sugiere
  /// el satélite).
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(
        color: selected ? context.colors.primary : context.colors.borderStrong,
      ),
    );
    return _SelectionSemantics(
      role: role,
      selected: selected,
      child: Material(
        color: selected ? context.colors.primary : context.colors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
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
                child: _ChipLabel(
                  label: label,
                  badge: badge,
                  color: selected
                      ? context.colors.onPrimary
                      : context.colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Opción de lista con marca circular (`.prio` / `.prio.activo`).
class RadioOptionTile extends StatelessWidget {
  /// Crea la opción.
  const RadioOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// Texto de la opción.
  final String label;

  /// Si está seleccionada.
  final bool selected;

  /// Acción al tocar.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: AppRadii.button,
      side: selected
          ? BorderSide(color: context.colors.primary, width: 2)
          : BorderSide(color: context.colors.borderStrong),
    );
    return _SelectionSemantics(
      role: SelectionRole.radio,
      selected: selected,
      child: Material(
        color: selected ? context.colors.primarySoft : context.colors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                spacing: 10,
                children: [
                  _RadioMark(selected: selected),
                  Expanded(child: Text(label, style: context.text.option)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? context.colors.primary
              : context.colors.borderStrong,
          width: selected ? 6 : 2,
        ),
      ),
    );
  }
}

/// Control segmentado (`.seg`).
class SegmentedSelector<T> extends StatelessWidget {
  /// Crea el selector.
  const SegmentedSelector({
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.semanticsLabel,
    super.key,
  });

  /// Valor y etiqueta de cada segmento.
  final List<(T, String)> options;

  /// Valor seleccionado.
  final T selected;

  /// Se llama al elegir otro valor.
  final ValueChanged<T> onChanged;

  /// Nombre del grupo para lectores de pantalla.
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: context.colors.surfaceMuted,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadii.md)),
        ),
        child: Row(
          spacing: 6,
          children: [
            for (final (value, label) in options)
              Expanded(
                child: _Segment(
                  label: label,
                  selected: value == selected,
                  onTap: () => onChanged(value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(9));
    return _SelectionSemantics(
      role: SelectionRole.radio,
      selected: selected,
      child: Material(
        color: selected ? context.colors.primary : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTouchTarget,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTypography.compactButton.copyWith(
                    color: selected
                        ? context.colors.onPrimary
                        : context.colors.textBody,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Texto del chip con su etiqueta opcional.
class _ChipLabel extends StatelessWidget {
  const _ChipLabel({required this.label, required this.color, this.badge});

  final String label;
  final String? badge;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Text(label, style: AppTypography.chip.copyWith(color: color));
    final badgeText = badge;
    if (badgeText == null) return text;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xxs,
      children: [
        text,
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            child: Text(
              badgeText,
              style: AppTypography.pillDense.copyWith(color: color),
            ),
          ),
        ),
      ],
    );
  }
}
