import 'package:audioplayers/audioplayers.dart';

/// Reproduce archivos de audio del dispositivo. Separado de `audioplayers`
/// para poder sustituirlo en pruebas.
abstract interface class AudioClipPlayer {
  /// Reproduce el archivo en [path], cortando lo que estuviera sonando.
  Future<void> playFile(String path);

  /// Corta la reproducción en curso, si hay alguna.
  Future<void> stop();

  /// Libera el reproductor.
  Future<void> dispose();
}

/// [AudioClipPlayer] con el paquete `audioplayers`.
class AudioplayersClipPlayer implements AudioClipPlayer {
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> playFile(String path) async {
    await _player.stop();
    await _player.play(DeviceFileSource(path));
  }

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> dispose() => _player.dispose();
}
