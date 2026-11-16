import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:siembra_segura/core/l10n/app_language.dart';
import 'package:siembra_segura/core/services/speech/audio_clip_player.dart';
import 'package:siembra_segura/core/services/speech/speech_service.dart';
import 'package:siembra_segura/core/services/speech/speech_text.dart';

/// Convierte un texto en audio MP3.
typedef SpeechSynthesizer = Future<Uint8List> Function(String text);

/// Voz de Semi con audios generados fuera del celular (hoy, por el backend:
/// `BackendSpeechClient`).
///
/// - Cada frase se genera una sola vez y se guarda en [cacheDirectory]: la
///   segunda vez suena al instante, sin internet.
/// - Si no hay internet o el generador falla, lee la frase con la voz del
///   dispositivo ([fallback]), así "Escuchar" nunca se queda mudo.
/// - Si llega otra frase (o [stop]) mientras se descarga una, la anterior se
///   descarta en lugar de sonar tarde.
class ClipSpeechService implements SpeechService {
  /// Crea el servicio. [voiceKey] distingue los archivos en caché de cada
  /// voz, para que cambiar de voz no reproduzca audios viejos.
  ClipSpeechService({
    required SpeechSynthesizer synthesize,
    required AudioClipPlayer player,
    required SpeechService fallback,
    required Directory cacheDirectory,
    required String voiceKey,
    this.language = AppLanguage.spanish,
  }) : _synthesize = synthesize,
       _player = player,
       _fallback = fallback,
       _cacheDirectory = cacheDirectory,
       _voiceKey = voiceKey;

  /// Idioma de las frases (para leer bien símbolos y unidades).
  final AppLanguage language;

  final SpeechSynthesizer _synthesize;
  final AudioClipPlayer _player;
  final SpeechService _fallback;
  final Directory _cacheDirectory;
  final String _voiceKey;

  /// Aumenta con cada pedido; una descarga solo suena si sigue siendo el
  /// último pedido.
  int _turn = 0;

  @override
  Future<void> speak(String text) async {
    final phrase = SpeechText.normalize(text, language);
    if (phrase.isEmpty) return;
    final turn = ++_turn;
    await _silence();
    try {
      final clip = await _clipFor(phrase);
      if (turn != _turn) return;
      await _player.playFile(clip.path);
    } on Object catch (error) {
      debugPrint('Voz de Semi no disponible, uso la del celular: $error');
      if (turn != _turn) return;
      await _fallback.speak(phrase);
    }
  }

  @override
  Future<void> stop() async {
    _turn++;
    await _silence();
  }

  Future<void> _silence() async {
    try {
      await _player.stop();
    } on Object {
      // Detener nunca debe romper la navegación.
    }
    await _fallback.stop();
  }

  Future<File> _clipFor(String phrase) async {
    final file = File(
      '${_cacheDirectory.path}${Platform.pathSeparator}'
      '${clipFileName(_voiceKey, phrase)}',
    );
    if (file.existsSync() && file.lengthSync() > 0) return file;

    final audio = await _synthesize(phrase);
    if (audio.isEmpty) throw const FormatException('Audio vacío');
    await _cacheDirectory.create(recursive: true);
    // Se escribe aparte y se renombra: nunca queda un MP3 a medias.
    final partial = File('${file.path}.part');
    await partial.writeAsBytes(audio, flush: true);
    return partial.rename(file.path);
  }

  /// Nombre estable del archivo de una frase: hash FNV-1a de voz + texto,
  /// más la longitud del texto para hacer improbables las colisiones.
  @visibleForTesting
  static String clipFileName(String voiceKey, String phrase) {
    var hash = 0x811c9dc5;
    for (final byte in utf8.encode('$voiceKey\n$phrase')) {
      hash = ((hash ^ byte) * 0x01000193) & 0xFFFFFFFF;
    }
    return 'semi_${hash.toRadixString(16).padLeft(8, '0')}'
        '_${phrase.length}.mp3';
  }
}
