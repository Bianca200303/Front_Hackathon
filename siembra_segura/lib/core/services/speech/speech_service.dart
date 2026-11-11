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

  /// Corta la lectura en curso, si hay alguna.
  Future<void> stop();
}

/// El dispositivo no puede leer en voz alta (sin motor de voz en español).
class SpeechUnavailableException implements Exception {
  /// Crea el error, con la causa original opcional.
  const SpeechUnavailableException([this.cause]);

  /// Error original del motor de voz.
  final Object? cause;

  @override
  String toString() => 'SpeechUnavailableException(cause: $cause)';
}

/// Servicio de lectura en voz alta del dispositivo.
final speechServiceProvider = Provider<SpeechService>((ref) {
  final service = FlutterTtsSpeechService();
  ref.onDispose(service.stop);
  return service;
});
