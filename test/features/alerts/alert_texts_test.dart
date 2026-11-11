import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/l10n/app_localizations_es.dart';
import 'package:siembra_segura/core/utils/formatters.dart';
import 'package:siembra_segura/features/alerts/presentation/alert_texts.dart';

import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEs();

  setUpAll(initTestLocale);

  group('relativeDayLabel', () {
    test('hoy, ayer y días anteriores', () {
      expect(
        relativeDayLabel(DateTime(2026, 11, 8, 6), testNow, l10n),
        'Hoy, 6:00 a.${AppFormatters.nonBreakingSpace}m.',
      );
      expect(
        relativeDayLabel(DateTime(2026, 11, 7, 15), testNow, l10n),
        'Ayer',
      );
      expect(
        relativeDayLabel(DateTime(2026, 11, 6, 7), testNow, l10n),
        'Viernes',
      );
    });

    test('puede omitir la hora de hoy', () {
      expect(
        relativeDayLabel(
          DateTime(2026, 11, 8, 6),
          testNow,
          l10n,
          includeTimeToday: false,
        ),
        'Domingo',
      );
    });
  });

  group('parseEmphasis', () {
    test('separa los fragmentos con énfasis', () {
      expect(parseEmphasis('ya no **arroz**, ahora **maíz**.'), [
        (text: 'ya no ', emphasized: false),
        (text: 'arroz', emphasized: true),
        (text: ', ahora ', emphasized: false),
        (text: 'maíz', emphasized: true),
        (text: '.', emphasized: false),
      ]);
    });

    test('un énfasis sin cerrar se deja como texto', () {
      expect(parseEmphasis('a **b'), [(text: 'a **b', emphasized: false)]);
    });

    test('stripEmphasis devuelve texto plano', () {
      expect(
        stripEmphasis('hasta el **15 de diciembre**.'),
        'hasta el 15 de diciembre.',
      );
    });
  });

  test('formatAudioDuration', () {
    expect(formatAudioDuration(const Duration(seconds: 42)), '0:42');
    expect(formatAudioDuration(const Duration(seconds: 75)), '1:15');
  });
}
