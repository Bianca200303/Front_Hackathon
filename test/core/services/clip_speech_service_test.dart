import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:siembra_segura/core/services/speech/audio_clip_player.dart';
import 'package:siembra_segura/core/services/speech/clip_speech_service.dart';

import '../../helpers/fake_speech_service.dart';

class _FakePlayer implements AudioClipPlayer {
  final List<String> played = [];
  int stopCalls = 0;

  @override
  Future<void> playFile(String path) async => played.add(path);

  @override
  Future<void> stop() async => stopCalls++;

  @override
  Future<void> dispose() async {}
}

void main() {
  late Directory cache;
  late _FakePlayer player;
  late FakeSpeechService device;

  setUp(() {
    cache = Directory.systemTemp.createTempSync('semi_voice_test');
    player = _FakePlayer();
    device = FakeSpeechService();
  });

  tearDown(() => cache.deleteSync(recursive: true));

  ClipSpeechService service(SpeechSynthesizer synthesize) => ClipSpeechService(
    synthesize: synthesize,
    player: player,
    fallback: device,
    cacheDirectory: cache,
    voiceKey: 'voz-semi',
  );

  test('genera la frase una sola vez y después la toma de la caché', () async {
    var calls = 0;
    final voice = service((text) async {
      calls++;
      return Uint8List.fromList([1, 2, 3]);
    });

    await voice.speak('Hola, soy Semi');
    await voice.speak('Hola, soy Semi');

    expect(calls, 1);
    expect(player.played, hasLength(2));
    expect(File(player.played.first).readAsBytesSync(), [1, 2, 3]);
    expect(device.spoken, isEmpty);
  });

  test('sin internet usa la voz del celular', () async {
    final voice = service(
      (text) async => throw const SocketException('sin señal'),
    );

    await voice.speak('Viene lluvia');

    expect(player.played, isEmpty);
    expect(device.spoken, ['Viene lluvia']);
  });

  test('descarta una frase que llega tarde si ya se pidió otra', () async {
    final slow = Completer<Uint8List>();
    final voice = service(
      (text) => text == 'primera'
          ? slow.future
          : Future.value(Uint8List.fromList([9])),
    );

    final first = voice.speak('primera');
    await voice.speak('segunda');
    slow.complete(Uint8List.fromList([1]));
    await first;

    expect(player.played, hasLength(1));
    expect(File(player.played.single).readAsBytesSync(), [9]);
  });

  test('detener corta el audio y la voz del celular', () async {
    final voice = service((text) async => Uint8List.fromList([1]));

    await voice.stop();

    expect(player.stopCalls, 1);
    expect(device.stopCalls, 1);
  });

  test('el nombre del archivo cambia con la voz y con el texto', () {
    final base = ClipSpeechService.clipFileName('voz-a', 'Hola');
    expect(ClipSpeechService.clipFileName('voz-a', 'Hola'), base);
    expect(ClipSpeechService.clipFileName('voz-b', 'Hola'), isNot(base));
    expect(ClipSpeechService.clipFileName('voz-a', 'Chau'), isNot(base));
  });
}
