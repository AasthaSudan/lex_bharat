import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    _isInitialized = await _speech.initialize(
      onError: (error) => print('STT error: $error'),
      onStatus: (status) => print('STT status: $status'),
    );

    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String text) onResult,
    required Function(String text) onDone,
    required Function(String error) onError,
    String localeId = 'en_IN',
  }) async {
    if (!_isInitialized) await initialize();
    if (!_isInitialized) {
      onError('Microphone not available');
      return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            onDone(result.recognizedWords);
          } else {
            onResult(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: localeId,
        cancelOnError: true,
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  Future<void> speak(String text) async {
    final cleanText = text
        .replaceAll('This is for educational purposes only.', '')
        .replaceAll('For legal advice, consult a qualified lawyer.', '')
        .trim();
    await _tts.speak(cleanText);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  bool get isListening => _speech.isListening;
  bool get isAvailable => _isInitialized;
}