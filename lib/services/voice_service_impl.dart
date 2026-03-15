import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceServiceImpl {
  late stt.SpeechToText _speechToText;
  late FlutterTts _flutterTts;

  bool _isListening = false;
  String _recognizedText = '';

  VoiceServiceImpl() {
    _speechToText = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  Future<bool> initializeSpeechToText() async {
    try {
      bool available = await _speechToText.initialize(
        onError: (error) => print('Error: $error'),
        onStatus: (status) => print('Status: $status'),
      );
      return available;
    } catch (e) {
      print('Error initializing speech to text: $e');
      return false;
    }
  }

  Future<bool> initializeTextToSpeech() async {
    try {
      await _flutterTts.setLanguage('hi'); // Default to Hindi
      await _flutterTts.setSpeechRate(0.5);
      return true;
    } catch (e) {
      print('Error initializing TTS: $e');
      return false;
    }
  }

  Future<void> startListening(
    Function(String) onResult,
    Function(String) onError,
  ) async {
    if (!_isListening && await initializeSpeechToText()) {
      try {
        _isListening = true;
        _speechToText.listen(
          onResult: (result) {
            _recognizedText = result.recognizedWords;
            onResult(_recognizedText);
          },
        );
      } catch (e) {
        onError('Error starting listening: $e');
      }
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
    }
  }

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;

  Future<void> speak(String text, {String language = 'hi'}) async {
    try {
      await _flutterTts.setLanguage(language);
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  Future<void> setLanguage(String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
  }

  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
  }
}

