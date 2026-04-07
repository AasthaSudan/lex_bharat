import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';

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
  final StorageService _storage = StorageService();

  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  @override
  ChatState build() {
    _loadHistory();
    return const ChatState();
  }

  Future<void> _loadHistory() async {
    try {
      final client = _supabase;
      final user = client?.auth.currentUser;
      if (client != null && user != null) {
        final data = await client
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
        return;
      }
    } catch (e) {
      debugPrint('Supabase chat load failed: $e');
    }

    try {
      final localHistory = await _storage.getChatHistory();
      if (localHistory != null && localHistory.isNotEmpty) {
        final messages = localHistory.map((m) => Message(
          id: m['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          text: m['text'] ?? '',
          isUser: m['isUser'] == true,
          timestamp: DateTime.tryParse(m['timestamp'] ?? '') ?? DateTime.now(),
        )).toList();
        state = state.copyWith(messages: messages);
      }
    } catch (e) {
      debugPrint('Local chat load failed: $e');
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

      _saveToSupabase(text, response);
      _saveToLocal();
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  Future<void> _saveToSupabase(String question, String answer) async {
    try {
      final client = _supabase;
      final user = client?.auth.currentUser;
      if (client == null || user == null) return;

      await client.from('chat_history').insert({
        'user_id': user.id,
        'question': question,
        'answer': answer,
      });
    } catch (e) {
      debugPrint('Supabase chat save failed: $e');
    }
  }

  Future<void> _saveToLocal() async {
    try {
      final historyMaps = state.messages.map((m) => {
        'id': m.id,
        'text': m.text,
        'isUser': m.isUser,
        'timestamp': m.timestamp.toIso8601String(),
      }).toList();
      await _storage.saveChatHistory(historyMaps);
    } catch (e) {
      debugPrint('Local chat save failed: $e');
    }
  }

  void clearChat() {
    state = const ChatState();
    _storage.clearChatHistory();
  }
}