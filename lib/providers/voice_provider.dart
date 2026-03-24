import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/voice_service.dart';

final voiceServiceProvider = Provider((ref) => VoiceService());

final voiceStateProvider =
NotifierProvider<VoiceNotifier, VoiceState>(VoiceNotifier.new);

class VoiceState {
  final bool isListening;
  final String liveTranscript;
  final bool hasError;
  final String errorMessage;

  const VoiceState({
    this.isListening = false,
    this.liveTranscript = '',
    this.hasError = false,
    this.errorMessage = '',
  });

  VoiceState copyWith({
    bool? isListening,
    String? liveTranscript,
    bool? hasError,
    String? errorMessage,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      liveTranscript: liveTranscript ?? this.liveTranscript,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VoiceNotifier extends Notifier<VoiceState> {
  Completer<String>? _completer;

  @override
  VoiceState build() => const VoiceState();

  Future<String?> startListening() async {
    final service = ref.read(voiceServiceProvider);

    final initialized = await service.initialize();
    if (!initialized) {
      state = state.copyWith(
        hasError: true,
        errorMessage: 'Microphone not available. Check permissions.',
      );
      return null;
    }

    _completer = Completer<String>();
    state = state.copyWith(
      isListening: true,
      liveTranscript: '',
      hasError: false,
      errorMessage: '',
    );

    await service.startListening(
      onResult: (text) {
        state = state.copyWith(liveTranscript: text);
      },
      onDone: (finalText) {
        state = state.copyWith(
          isListening: false,
          liveTranscript: '',
        );
        if (_completer != null && !_completer!.isCompleted) {
          _completer!.complete(finalText);
        }
      },
      onError: (error) {
        state = state.copyWith(
          isListening: false,
          liveTranscript: '',
          hasError: true,
          errorMessage: error,
        );
        if (_completer != null && !_completer!.isCompleted) {
          _completer!.complete('');
        }
      },
    );

    try {
      final result = await _completer!.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          state = state.copyWith(isListening: false, liveTranscript: '');
          return '';
        },
      );
      return result.trim().isEmpty ? null : result;
    } catch (_) {
      return null;
    }
  }

  Future<void> stopListening() async {
    await ref.read(voiceServiceProvider).stopListening();
    state = state.copyWith(isListening: false, liveTranscript: '');
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(state.liveTranscript);
    }
  }

  Future<void> speakResponse(String text) async {
    await ref.read(voiceServiceProvider).speak(text);
  }

  void reset() {
    state = const VoiceState();
    _completer = null;
  }
}