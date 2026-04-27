import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import 'app_provider.dart';

final aiServiceProvider = Provider((ref) => AIService());
final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);

class ChatState {
  final List<Message> messages;
  final bool isTyping;
  final String? error;
  final String sessionId;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
    required this.sessionId,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isTyping,
    String? error,
    String? sessionId,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  final StorageService _storage = StorageService();

  @override
  ChatState build() {
    _loadHistory();
    return ChatState(sessionId: DateTime.now().toString());
  }

  Future<void> _loadHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('chat_history')
            .where('user_id', isEqualTo: user.uid)
            .orderBy('created_at', descending: false)
            .limit(50)
            .get();

        final messages = snapshot.docs.expand((doc) {
          final data = doc.data();
          final createdAt = (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now();
          return [
            Message(
              id: '${doc.id}_q',
              text: data['question'] as String,
              isUser: true,
              timestamp: createdAt,
            ),
            Message(
              id: '${doc.id}_a',
              text: data['answer'] as String,
              isUser: false,
              timestamp: createdAt,
            ),
          ];
        }).toList();

        state = state.copyWith(messages: messages);
        return;
      }
    } catch (e) {
      debugPrint('Firestore chat load failed: $e');
    }

    try {
      final localHistory = await _storage.getChatHistory();
      if (localHistory != null && localHistory.isNotEmpty) {
        final messages = localHistory
            .map(
              (m) => Message(
                id: m['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
                text: m['text'] ?? '',
                isUser: m['isUser'] == true,
                timestamp:
                    DateTime.tryParse(m['timestamp'] ?? '') ?? DateTime.now(),
              ),
            )
            .toList();
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
      final language = ref.read(languageProvider);

      final conversationHistory = state.messages
          .map(
            (m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text},
          )
          .toList();

      final response = await ref
          .read(aiServiceProvider)
          .getLegalAdvice(
            text,
            language: language,
            conversationHistory: conversationHistory.isNotEmpty
                ? conversationHistory
                : null,
          );

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

      _saveToFirestore(text, response);
      _saveToLocal();
      _saveToHive();
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  Future<void> _saveToFirestore(String question, String answer) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance.collection('chat_history').add({
        'user_id': user.uid,
        'question': question,
        'answer': answer,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Firestore chat save failed: $e');
    }
  }

  Future<void> _saveToLocal() async {
    try {
      final historyMaps = state.messages
          .map(
            (m) => {
              'id': m.id,
              'text': m.text,
              'isUser': m.isUser,
              'timestamp': m.timestamp.toIso8601String(),
            },
          )
          .toList();
      await _storage.saveChatHistory(historyMaps);
    } catch (e) {
      debugPrint('Local chat save failed: $e');
    }
  }

  Future<void> _saveToHive() async {
    try {
      final messagesJson = state.messages
          .map(
            (m) => {
              'id': m.id,
              'text': m.text,
              'isUser': m.isUser,
              'timestamp': m.timestamp.toIso8601String(),
            },
          )
          .toList();

      await DatabaseService.saveChatSession(state.sessionId, {
        'id': state.sessionId,
        'messages': messagesJson,
        'createdAt': DateTime.now().toIso8601String(),
        'title': state.messages.isNotEmpty
            ? state.messages.first.text.substring(0, 30)
            : 'Chat Session',
      });
    } catch (e) {
      debugPrint('Hive chat save failed: $e');
    }
  }

  void clearChat() {
    state = ChatState(sessionId: DateTime.now().toString());
    _storage.clearChatHistory();
  }
}
