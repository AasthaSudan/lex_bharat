import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  static const String chatSessionsBox = 'chat_sessions';
  static const String chatMessagesBox = 'chat_messages';
  static const String learningProgressBox = 'learning_progress';
  static const String formResponsesBox = 'form_responses';
  static const String userPreferencesBox = 'user_preferences';
  static const String offlineCacheBox = 'offline_cache';

  static Future<void> initHive() async {
    try {
      await Hive.initFlutter();

      // Open all boxes
      await Hive.openBox(chatSessionsBox);
      await Hive.openBox(chatMessagesBox);
      await Hive.openBox(learningProgressBox);
      await Hive.openBox(formResponsesBox);
      await Hive.openBox(userPreferencesBox);
      await Hive.openBox(offlineCacheBox);

      print('✓ Hive database initialized successfully');
    } catch (e) {
      print('✗ Error initializing Hive: $e');
      rethrow;
    }
  }

  // Chat operations
  static Future<void> saveChatSession(String key, Map<String, dynamic> session) async {
    final box = Hive.box(chatSessionsBox);
    await box.put(key, session);
  }

  static Future<Map<String, dynamic>?> getChatSession(String key) async {
    final box = Hive.box(chatSessionsBox);
    return box.get(key) as Map<String, dynamic>?;
  }

  static Future<List<Map<String, dynamic>>> getAllChatSessions() async {
    final box = Hive.box(chatSessionsBox);
    return box.values.cast<Map<String, dynamic>>().toList();
  }

  static Future<void> deleteChatSession(String key) async {
    final box = Hive.box(chatSessionsBox);
    await box.delete(key);
  }

  // Learning progress operations
  static Future<void> saveLearningProgress(String key, Map<String, dynamic> progress) async {
    final box = Hive.box(learningProgressBox);
    await box.put(key, progress);
  }

  static Future<Map<String, dynamic>?> getLearningProgress(String key) async {
    final box = Hive.box(learningProgressBox);
    return box.get(key) as Map<String, dynamic>?;
  }

  static Future<List<Map<String, dynamic>>> getUserLearningProgress(String userId) async {
    final box = Hive.box(learningProgressBox);
    final results = <Map<String, dynamic>>[];
    for (var key in box.keys) {
      final value = box.get(key) as Map<String, dynamic>?;
      if (value?['userId'] == userId) {
        results.add(value!);
      }
    }
    return results;
  }

  // Form responses operations
  static Future<void> saveFormResponse(String key, Map<String, dynamic> response) async {
    final box = Hive.box(formResponsesBox);
    await box.put(key, response);
  }

  static Future<Map<String, dynamic>?> getFormResponse(String key) async {
    final box = Hive.box(formResponsesBox);
    return box.get(key) as Map<String, dynamic>?;
  }

  static Future<List<Map<String, dynamic>>> getUserFormResponses(String userId) async {
    final box = Hive.box(formResponsesBox);
    final results = <Map<String, dynamic>>[];
    for (var key in box.keys) {
      final value = box.get(key) as Map<String, dynamic>?;
      if (value?['userId'] == userId) {
        results.add(value!);
      }
    }
    return results;
  }

  // Cache operations for offline content
  static Future<void> cacheContent(String key, Map<String, dynamic> data) async {
    final box = Hive.box(offlineCacheBox);
    await box.put(key, {
      ...data,
      'cachedAt': DateTime.now().toIso8601String(),
    });
  }

  static Future<Map<String, dynamic>?> getCachedContent(String key) async {
    final box = Hive.box(offlineCacheBox);
    return box.get(key) as Map<String, dynamic>?;
  }

  static Future<void> clearExpiredCache({Duration maxAge = const Duration(days: 7)}) async {
    final box = Hive.box(offlineCacheBox);
    final keysToDelete = <String>[];
    final now = DateTime.now();

    for (var key in box.keys) {
      final value = box.get(key) as Map<String, dynamic>?;
      if (value != null && value.containsKey('cachedAt')) {
        final cachedAt = DateTime.parse(value['cachedAt'] as String);
        if (now.difference(cachedAt) > maxAge) {
          keysToDelete.add(key as String);
        }
      }
    }

    for (var key in keysToDelete) {
      await box.delete(key);
    }
  }

  // Preferences operations
  static Future<void> savePreference(String key, dynamic value) async {
    final box = Hive.box(userPreferencesBox);
    await box.put(key, value);
  }

  static Future<dynamic> getPreference(String key) async {
    final box = Hive.box(userPreferencesBox);
    return box.get(key);
  }

  // Sync operations for offline-first architecture
  static Future<List<Map<String, dynamic>>> getPendingSyncQueue() async {
    final box = Hive.box(offlineCacheBox);
    final pending = <Map<String, dynamic>>[];

    for (var key in box.keys) {
      final value = box.get(key) as Map<String, dynamic>?;
      if (value?['syncPending'] == true) {
        pending.add(value!);
      }
    }
    return pending;
  }

  static Future<void> markAsSynced(String key) async {
    final box = Hive.box(offlineCacheBox);
    final value = box.get(key) as Map<String, dynamic>?;
    if (value != null) {
      await box.put(key, {
        ...value,
        'syncPending': false,
        'syncedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  // Database maintenance
  static Future<void> clearAllData() async {
    await Future.wait([
      Hive.box(chatSessionsBox).clear(),
      Hive.box(chatMessagesBox).clear(),
      Hive.box(learningProgressBox).clear(),
      Hive.box(formResponsesBox).clear(),
      Hive.box(userPreferencesBox).clear(),
      Hive.box(offlineCacheBox).clear(),
    ]);
  }

  static Future<void> closeHive() async {
    await Hive.close();
  }
}

