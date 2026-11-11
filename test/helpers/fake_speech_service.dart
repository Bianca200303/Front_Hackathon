import 'package:siembra_segura/core/services/speech/speech_service.dart';

class FakeSpeechService implements SpeechService {
  final List<String> spoken = [];
  int stopCalls = 0;

  @override
  Future<void> speak(String text) async => spoken.add(text);

  @override
  Future<void> stop() async => stopCalls++;
}
