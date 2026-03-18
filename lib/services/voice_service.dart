class VoiceService {
  bool _isListening = false;

  Future<void> initialize() async {

  }

  Future<void> startListening(Function(String) onResult) async {
    _isListening = true;
  }

  Future<void> stopListening() async {
    _isListening = false;
  }

  bool get isListening => _isListening;

  Future<void> dispose() async {
    _isListening = false;
  }
}