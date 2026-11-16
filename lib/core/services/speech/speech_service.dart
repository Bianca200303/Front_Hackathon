import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:siembra_segura/core/config/app_config.dart';
import 'package:siembra_segura/core/l10n/app_language_provider.dart';
import 'package:siembra_segura/core/services/speech/audio_clip_player.dart';
import 'package:siembra_segura/core/services/speech/backend_speech_client.dart';
import 'package:siembra_segura/core/services/speech/clip_speech_service.dart';
import 'package:siembra_segura/core/services/speech/flutter_tts_speech_service.dart';

/// Lectura en voz alta del contenido de cada pantalla ("Escuchar").
///
/// Con `VOICE_SOURCE=backend` habla con la voz que genera el backend
/// (decisión B8); si no, o si falla la red, usa el TTS del dispositivo.
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

/// Servicio de lectura en voz alta: la voz de Semi generada por el backend
/// (`VOICE_SOURCE=backend`) o, si no, la del celular.
final speechServiceProvider = Provider<SpeechService>((ref) {
  final language = ref.watch(appLanguageProvider);
  final device = FlutterTtsSpeechService(language: language);
  final config = ref.watch(appConfigProvider);
  final baseUrl = config.apiBaseUrl;
  if (config.voiceSource != VoiceSource.backend || baseUrl == null) {
    ref.onDispose(device.stop);
    return device;
  }

  final client = BackendSpeechClient(baseUrl, appLanguage: language);
  final player = AudioplayersClipPlayer();
  final service = ClipSpeechService(
    synthesize: client.synthesize,
    player: player,
    fallback: device,
    cacheDirectory: Directory(
      '${Directory.systemTemp.path}${Platform.pathSeparator}semi_voice',
    ),
    voiceKey: '${client.endpoint} ${client.language}',
    language: language,
  );
  ref.onDispose(() async {
    await service.stop();
    await player.dispose();
    client.close();
  });
  return service;
});
