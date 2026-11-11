import 'package:flutter_tts/flutter_tts.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';

/// Implementación de [SpeechService] con el motor TTS del dispositivo.
class FlutterTtsSpeechService implements SpeechService {
  /// Crea el servicio; [tts] permite inyectar un doble en pruebas.
  FlutterTtsSpeechService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  /// Idiomas en orden de preferencia: español de Perú primero.
  static const _preferredLanguages = ['es-PE', 'es-US', 'es-419', 'es-ES'];

  /// Algo más lento que lo normal (0.5) para facilitar la comprensión.
  static const _speechRate = 0.45;

  final FlutterTts _tts;
  Future<void>? _configuration;

  @override
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    try {
      await (_configuration ??= _configure());
      await _tts.stop();
      await _tts.speak(text);
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
    for (final language in _preferredLanguages) {
      final available = await _tts.isLanguageAvailable(language);
      if (available == true) {
        await _tts.setLanguage(language);
        break;
      }
    }
    await _tts.setSpeechRate(_speechRate);
  }
}
