import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/voice_service.dart';

final voiceServiceProvider = Provider((ref) => VoiceService());

final voiceStateProvider =
NotifierProvider<VoiceNotifier, VoiceState>(VoiceNotifier.new);

class VoiceState {
  final bool isListening;
  final String transcription;
  final bool hasError;

  VoiceState({
    this.isListening = false,
    this.transcription = '',
    this.hasError = false,
  });

  VoiceState copyWith({
    bool? isListening,
    String? transcription,
    bool? hasError,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      transcription: transcription ?? this.transcription,
      hasError: hasError ?? this.hasError,
    );
  }
}

class VoiceNotifier extends Notifier<VoiceState> {
  @override
  VoiceState build() => VoiceState();

  Future<void> startListening() async {
    try {
      state = state.copyWith(isListening: true, hasError: false);
      await ref.read(voiceServiceProvider).startListening((text) {
        state = state.copyWith(transcription: text);
      });
    } catch (e) {
      state = state.copyWith(hasError: true, isListening: false);
    }
  }

  Future<void> stopListening() async {
    await ref.read(voiceServiceProvider).stopListening();
    state = state.copyWith(isListening: false);
  }

  void reset() {
    state = VoiceState();
  }
}