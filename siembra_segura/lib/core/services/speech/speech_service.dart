import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/services/speech/flutter_tts_speech_service.dart';

/// Lectura en voz alta del contenido de cada pantalla ("Escuchar").
///
/// Hoy usa el TTS del dispositivo. Si el backend termina entregando audio
/// pregrabado o generado (decisión B8), basta con otra implementación.
abstract interface class SpeechService {
  /// Lee [text] en voz alta, interrumpiendo cualquier lectura anterior.
  ///
  /// Lanza [SpeechUnavailableException] si el dispositivo no puede leer.
  Future<void> speak(String text);

  Future<void> stop();
}

class SpeechUnavailableException implements Exception {
  const SpeechUnavailableException([this.cause]);

  final Object? cause;

  @override
  String toString() => 'SpeechUnavailableException(cause: $cause)';
}

final speechServiceProvider = Provider<SpeechService>((ref) {
  final service = FlutterTtsSpeechService();
  ref.onDispose(service.stop);
  return service;
});
