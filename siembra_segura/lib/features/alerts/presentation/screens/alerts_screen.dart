import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/router/app_routes.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/core/utils/clock.dart';
import 'package:siembra_segura/features/alerts/domain/alert.dart';
import 'package:siembra_segura/features/alerts/presentation/alert_texts.dart';
import 'package:siembra_segura/features/alerts/presentation/providers/alerts_providers.dart';
import 'package:siembra_segura/shared/widgets/app_settings.dart';
import 'package:siembra_segura/shared/widgets/async_value_view.dart';
import 'package:siembra_segura/shared/widgets/notice_tile.dart';
import 'package:siembra_segura/shared/widgets/screen_layout.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_guide.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';
import 'package:siembra_segura/shared/widgets/text_blocks.dart';

/// Pantalla 4: Avisos.
class AlertsScreen extends ConsumerWidget {
  /// Crea la pantalla.
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final alerts = ref.watch(alertsProvider);
    final now = ref.watch(clockProvider)();
    final loaded = alerts.value;

    return ScreenLayout(
      guide: SemiGuide(
        message: l10n.semiAlertsGuide,
        expression: SemiExpression.alert,
      ),
      header: ScreenHeader(
        actions: const [AppSettingsButton()],
        title: l10n.alertsTitle,
        listenText: loaded == null ? null : _narration(loaded, l10n),
      ),
      body: AsyncValueView(
        value: alerts,
        onRetry: () => ref.invalidate(alertsProvider),
        isEmpty: (alerts) => alerts.isEmpty,
        emptyMessage: l10n.emptyAlerts,
        data: (alerts) => ScreenContent(
          onRefresh: () => ref.refresh(alertsProvider.future),
          children: [
            for (final alert in alerts)
              NoticeTile(
                icon: alert.type.icon,
                iconTone: alert.type.tone(context.colors),
                title: alert.title,
                body: alert.body,
                meta: l10n.alertMeta(
                  relativeDayLabel(alert.receivedAt, now, l10n),
                  alert.source,
                ),
                onTap: () => _open(context, alert),
              ),
            SourceNote(l10n.alertsFooter),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Alert alert) {
    switch (alert.destination) {
      case AlertDestination.climate:
        context.go(AppRoutes.climate);
      case AlertDestination.message:
        context.go(AppRoutes.alertDetail(alert.id));
    }
  }

  String _narration(List<Alert> alerts, AppLocalizations l10n) => [
    l10n.alertsCount(alerts.length),
    for (final alert in alerts) '${alert.title}.',
  ].join(' ');
}
