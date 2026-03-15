// Voice service for speech recognition
// For demo, this is a placeholder. In production, use speech_to_text package

class VoiceService {
  bool _isListening = false;

  Future<void> initialize() async {
    // Initialize speech recognition
    // In real app: await _speech.initialize();
  }

  Future<void> startListening(Function(String) onResult) async {
    _isListening = true;
    // In real app: await _speech.listen(onResult: (result) => onResult(result.recognizedWords));
  }

  Future<void> stopListening() async {
    _isListening = false;
    // In real app: await _speech.stop();
  }

  bool get isListening => _isListening;

  Future<void> dispose() async {
    _isListening = false;
  }
}