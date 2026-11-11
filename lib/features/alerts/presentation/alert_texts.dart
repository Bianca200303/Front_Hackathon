import 'package:flutter/material.dart';
import 'package:siembra_segura/core/l10n/app_localizations.dart';
import 'package:siembra_segura/core/theme/app_colors.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/alerts/domain/alert.dart';

/// Icono y color de cada tipo de aviso.
extension AlertTypeStyle on AlertType {
  /// Icono del tipo.
  IconData get icon => switch (this) {
    AlertType.rain => Icons.grain,
    AlertType.soil => Icons.water_drop_outlined,
    AlertType.forecastChange => Icons.warning_amber_rounded,
  };

  /// Colores del círculo del icono.
  Tone get tone => switch (this) {
    AlertType.rain => AppColors.waterTone,
    AlertType.soil => AppColors.soilTone,
    AlertType.forecastChange => AppColors.amberTone,
  };
}

/// "Hoy, 6:00 a. m.", "Ayer" o el día de la semana ("Viernes").
String relativeDayLabel(
  DateTime moment,
  DateTime now,
  AppLocalizations l10n, {
  bool includeTimeToday = true,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(moment.year, moment.month, moment.day);
  final daysAgo = today.difference(day).inDays;
  if (daysAgo == 0) {
    return includeTimeToday
        ? l10n.alertTimeToday(AppFormatters.time(moment))
        : AppFormatters.capitalize(AppFormatters.weekday(moment));
  }
  if (daysAgo == 1) return l10n.alertTimeYesterday;
  return AppFormatters.capitalize(AppFormatters.weekday(moment));
}

/// `42 s` → `0:42`
String formatAudioDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Fragmento de texto con o sin énfasis.
typedef EmphasisSegment = ({String text, bool emphasized});

/// Separa `**énfasis**` en segmentos. Un `**` sin cerrar se trata como
/// texto normal.
List<EmphasisSegment> parseEmphasis(String source) {
  final parts = source.split('**');
  if (parts.length.isEven) return [(text: source, emphasized: false)];
  return [
    for (final (index, part) in parts.indexed)
      if (part.isNotEmpty) (text: part, emphasized: index.isOdd),
  ];
}

/// Texto sin marcas de énfasis, para la lectura en voz alta.
String stripEmphasis(String source) =>
    parseEmphasis(source).map((segment) => segment.text).join();

/// Texto plano del mensaje.
extension AlertMessageTexts on AlertMessage {
  /// Párrafos sin marcas de énfasis, para leer en voz alta.
  String plainText() => paragraphs.map(stripEmphasis).join(' ');
}
