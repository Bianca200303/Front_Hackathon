import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/error/error_messages.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_spacing.dart';

/// Renderiza de forma uniforme los estados de un [AsyncValue]:
/// carga, error (con reintento), vacío y datos.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onRetry,
    this.isEmpty,
    this.emptyMessage,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  /// Si devuelve `true`, se muestra [EmptyView] en lugar de [data].
  final bool Function(T data)? isEmpty;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (result) => isEmpty?.call(result) ?? false
          ? EmptyView(message: emptyMessage)
          : data(result),
      error: (error, _) => ErrorView(error: error, onRetry: onRetry),
      loading: () => const LoadingView(),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: AppLocalizations.of(context).loading,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, this.onRetry, super.key});

  final Object error;
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

class EmptyView extends StatelessWidget {
  const EmptyView({this.message, super.key});

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
