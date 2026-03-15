import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/voice_service.dart';

final voiceServiceProvider = Provider((ref) => VoiceService());

final voiceStateProvider = StateNotifierProvider<VoiceNotifier, VoiceState>(
      (ref) => VoiceNotifier(ref.read(voiceServiceProvider)),
);

class VoiceState {
  final bool isListening;
  final String transcription;
  final bool hasError;
  final String? errorMessage;

  VoiceState({
    this.isListening = false,
    this.transcription = '',
    this.hasError = false,
    this.errorMessage,
  });

  VoiceState copyWith({
    bool? isListening,
    String? transcription,
    bool? hasError,
    String? errorMessage,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      transcription: transcription ?? this.transcription,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VoiceNotifier extends StateNotifier<VoiceState> {
  final VoiceService _service;

  VoiceNotifier(this._service) : super(VoiceState());

  Future<void> startListening() async {
    try {
      state = state.copyWith(isListening: true, hasError: false);

      // For demo purposes - in real app, use actual speech recognition
      // await _service.startListening((text) {
      //   state = state.copyWith(transcription: text);
      // });

      // Simulated voice input for demo
      await Future.delayed(Duration(seconds: 1));
      state = state.copyWith(
        transcription: 'Voice input active...',
      );
    } catch (e) {
      state = state.copyWith(
        hasError: true,
        isListening: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> stopListening() async {
    // await _service.stopListening();
    state = state.copyWith(isListening: false);
  }

  void reset() {
    state = VoiceState();
  }

  void updateTranscription(String text) {
    state = state.copyWith(transcription: text);
  }
}