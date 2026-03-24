import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';
import '../services/ai_service.dart';

final aiServiceProvider = Provider((ref) => AIService());

final chatProvider =
NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);

class ChatState {
  final List<Message> messages;
  final bool isTyping;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isTyping,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  final _supabase = Supabase.instance.client;

  @override
  ChatState build() {
    // Load history when provider initializes
    _loadHistory();
    return const ChatState();
  }

  Future<void> _loadHistory() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return; // guest mode — no history

      final data = await _supabase
          .from('chat_history')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: true)
          .limit(50);

      final messages = (data as List).expand((row) {
        return [
          Message(
            id: '${row['id']}_q',
            text: row['question'] as String,
            isUser: true,
            timestamp: DateTime.parse(row['created_at'] as String),
          ),
          Message(
            id: '${row['id']}_a',
            text: row['answer'] as String,
            isUser: false,
            timestamp: DateTime.parse(row['created_at'] as String),
          ),
        ];
      }).toList();

      state = state.copyWith(messages: messages);
    } catch (_) {
      // Silently fail — chat still works without history
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
      error: null,
    );

    try {
      final response =
      await ref.read(aiServiceProvider).getLegalAdvice(text);

      final aiMsg = Message(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isTyping: false,
      );

      // Save to Supabase in background (don't await — don't block UI)
      _saveToSupabase(text, response);
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  Future<void> _saveToSupabase(String question, String answer) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return; // guest — skip saving

      await _supabase.from('chat_history').insert({
        'user_id': user.id,
        'question': question,
        'answer': answer,
      });
    } catch (_) {
      // Silently fail — user doesn't need to know
    }
  }

  void clearChat() {
    state = const ChatState();
  }
}