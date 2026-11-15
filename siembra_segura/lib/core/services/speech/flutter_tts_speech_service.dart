import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/core/services/speech/speech_text.dart';

/// Implementación de [SpeechService] con el motor TTS del dispositivo,
/// ajustado para que Semi suene cercano: tono algo más alto, ritmo pausado
/// y la mejor voz instalada en el idioma de la app.
class FlutterTtsSpeechService implements SpeechService {
  /// Crea el servicio para hablar en [language]; [tts] permite inyectar un
  /// doble en pruebas.
  FlutterTtsSpeechService({
    this.language = AppLanguage.spanish,
    FlutterTts? tts,
  }) : _tts = tts ?? FlutterTts();

  /// Idioma en que habla Semi.
  final AppLanguage language;

  /// Voces en español, en orden de preferencia: de Perú primero.
  static const _spanishVoices = ['es-PE', 'es-US', 'es-419', 'es-MX', 'es-ES'];

  /// Voces en inglés, en orden de preferencia.
  static const _englishVoices = ['en-US', 'en-GB', 'en-AU', 'en-IN'];

  /// Voces a probar para [language], en orden. Los celulares no traen voz
  /// en quechua: se lee con la de español de Perú, que pronuncia bien la
  /// escritura quechua.
  static List<String> preferredLanguagesFor(AppLanguage language) =>
      language == AppLanguage.english ? _englishVoices : _spanishVoices;

  /// Algo más lento que lo normal (0.5) para facilitar la comprensión.
  static const _speechRate = 0.42;

  /// Tono un poco más alto que el normal (1.0): suena más amable, sin
  /// llegar a voz de dibujo animado.
  static const _pitch = 1.12;

  final FlutterTts _tts;
  Future<void>? _configuration;

  @override
  Future<void> speak(String text) async {
    final spoken = SpeechText.normalize(text, language);
    if (spoken.isEmpty) return;
    try {
      await (_configuration ??= _configure());
      await _tts.stop();
      await _tts.speak(spoken);
    } on Object catch (error) {
      _configuration = null;
      throw SpeechUnavailableException(error);
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } on Object {
      // Detener nunca debe romper la navegación.
    }
  }

  Future<void> _configure() async {
    final preferred = preferredLanguagesFor(language);
    for (final code in preferred) {
      final available = await _tts.isLanguageAvailable(code);
      if (available == true) {
        await _tts.setLanguage(code);
        break;
      }
    }
    await _tts.setSpeechRate(_speechRate);
    await _tts.setPitch(_pitch);
    await _tts.setVolume(1);
    try {
      final voices = await _tts.getVoices;
      final voice = pickVoice(voices is List ? voices : const [], preferred);
      if (voice != null) await _tts.setVoice(voice);
    } on Object catch (error) {
      // Sin lista de voces se queda la voz por defecto del idioma.
      debugPrint('No se pudo elegir la voz de Semi: $error');
    }
  }

  /// Elige la voz más natural entre las que informa el motor: del primer
  /// idioma posible de [preferredLanguages], de alta calidad y que funcione
  /// sin internet (en el campo la señal falla). Devuelve `{name, locale}` o
  /// `null`.
  @visibleForTesting
  static Map<String, String>? pickVoice(
    List<Object?> voices, [
    List<String> preferredLanguages = _spanishVoices,
  ]) {
    Map<String, String>? best;
    var bestScore = -1;
    for (final raw in voices) {
      if (raw is! Map) continue;
      final name = raw['name']?.toString();
      final locale = raw['locale']?.toString();
      if (name == null || locale == null) continue;
      final language = locale.replaceAll('_', '-');
      final languageRank = preferredLanguages.indexWhere(
        (preferred) => preferred.toLowerCase() == language.toLowerCase(),
      );
      if (languageRank < 0) continue;

      var score = (preferredLanguages.length - languageRank) * 10;
      // Android: quality "very high"/"high", network_required "1"/"0".
      // iOS: quality "enhanced"/"premium".
      final quality = raw['quality']?.toString().toLowerCase() ?? '';
      if (quality.contains('very high') || quality.contains('premium')) {
        score += 8;
      } else if (quality.contains('high') || quality.contains('enhanced')) {
        score += 5;
      }
      final network = raw['network_required']?.toString();
      final needsNetwork =
          network == '1' || network == 'true' || name.contains('network');
      if (!needsNetwork) score += 6;

      if (score > bestScore) {
        bestScore = score;
        best = {'name': name, 'locale': locale};
      }
    }
    return best;
  }
}
