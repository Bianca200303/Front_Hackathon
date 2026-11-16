import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/error/error_messages.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_avatar.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';

/// Renderiza de forma uniforme los estados de un [AsyncValue]:
/// carga, error (con reintento), vacío y datos.
class AsyncValueView<T> extends StatelessWidget {
  /// Crea la vista para [value].
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onRetry,
    this.isEmpty,
    this.emptyMessage,
    super.key,
  });

  /// Estado asíncrono a representar.
  final AsyncValue<T> value;

  /// Construye el contenido cuando hay datos.
  final Widget Function(T data) data;

  /// Si se indica, el error muestra "Reintentar".
  final VoidCallback? onRetry;

  /// Si devuelve `true`, se muestra [EmptyView] en lugar de [data].
  final bool Function(T data)? isEmpty;

  /// Mensaje del estado vacío; por defecto, uno genérico.
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return value.when(
      // Al recalcular con datos nuevos (otra fecha, otra rotación) se
      // mantiene lo anterior en pantalla en vez de parpadear "Cargando".
      skipLoadingOnReload: true,
      data: (result) => isEmpty?.call(result) ?? false
          ? EmptyView(message: emptyMessage)
          : data(result),
      error: (error, _) => ErrorView(error: error, onRetry: onRetry),
      loading: () => const LoadingView(),
    );
  }
}

/// Indicador de carga centrado y accesible.
///
/// Con datos reales Semi aparece pensando y avisa que está consultando los
/// satélites (la primera vez puede tardar). Con datos de ejemplo no hay
/// consulta a nadie: solo el indicador.
class LoadingView extends ConsumerWidget {
  /// Crea el indicador.
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (ref.watch(appConfigProvider).usesMocks) {
      return Center(
        child: Semantics(
          label: l10n.loading,
          child: const Padding(
            padding: EdgeInsets.all(AppSpacing.xxl),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Center(
      child: Semantics(
        liveRegion: true,
        label: l10n.loadingSatellite,
        excludeSemantics: true,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.md,
            children: [
              const SemiAvatar(expression: SemiExpression.thinking, size: 120),
              Text(
                l10n.loadingSatellite,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 160, child: LinearProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mensaje de error comprensible con opción de reintentar.
class ErrorView extends StatelessWidget {
  /// Crea la vista para [error].
  const ErrorView({required this.error, this.onRetry, super.key});

  /// Error recibido; se traduce con `userMessageFor`.
  final Object error;

  /// Si se indica, muestra el botón "Reintentar".
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _MessageView(
      icon: Icons.cloud_off_rounded,
      message: userMessageFor(error, l10n),
      action: onRetry == null
          ? null
          : FilledButton(onPressed: onRetry, child: Text(l10n.actionRetry)),
    );
  }
}

/// Mensaje para cuando no hay nada que mostrar.
class EmptyView extends StatelessWidget {
  /// Crea la vista vacía.
  const EmptyView({this.message, super.key});

  /// Mensaje a mostrar; por defecto, uno genérico.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      icon: Icons.inbox_outlined,
      message: message ?? AppLocalizations.of(context).emptyDefault,
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.icon, required this.message, this.action});

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
