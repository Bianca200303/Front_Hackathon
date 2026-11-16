import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/services/speech/flutter_tts_speech_service.dart';
import 'package:siembra_segura/core/services/speech/speech_text.dart';

void main() {
  group('SpeechText.normalize', () {
    test('lee soles, grados, milímetros y hectáreas como palabras', () {
      expect(
        SpeechText.normalize('Podrías perder hasta S/ 5,000.'),
        'Podrías perder hasta 5,000 soles.',
      );
      expect(SpeechText.normalize('2 °C más'), '2 grados más');
      expect(
        SpeechText.normalize('Se esperan 40 mm.'),
        'Se esperan 40 milímetros.',
      );
      expect(SpeechText.normalize('1.5 ha'), '1.5 hectáreas');
      expect(SpeechText.normalize('70%'), '70 por ciento');
    });

    test('quita negritas y cambia separadores por pausas', () {
      expect(
        SpeechText.normalize('Tiene hasta el **15 de diciembre** · SENAMHI'),
        'Tiene hasta el 15 de diciembre, SENAMHI',
      );
    });

    test('no toca palabras que contienen las abreviaturas', () {
      expect(
        SpeechText.normalize('Hay harina y más mm'),
        'Hay harina y más mm',
      );
    });
  });

  group('pickVoice', () {
    test('prefiere español de Perú, alta calidad y sin internet', () {
      final voice = FlutterTtsSpeechService.pickVoice([
        {
          'name': 'en-us-x-iol-local',
          'locale': 'en-US',
          'quality': 'very high',
        },
        {
          'name': 'es-es-x-eea-local',
          'locale': 'es-ES',
          'quality': 'very high',
        },
        {
          'name': 'es-us-x-esd-network',
          'locale': 'es-US',
          'quality': 'very high',
          'network_required': '1',
        },
        {
          'name': 'es-us-x-esf-local',
          'locale': 'es-US',
          'quality': 'high',
          'network_required': '0',
        },
      ]);
      expect(voice, {'name': 'es-us-x-esf-local', 'locale': 'es-US'});
    });

    test('sin voces en español devuelve null', () {
      expect(
        FlutterTtsSpeechService.pickVoice([
          {'name': 'en', 'locale': 'en-US'},
          'basura',
        ]),
        isNull,
      );
    });
  });
}
