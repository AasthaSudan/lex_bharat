import "package:flutter/foundation.dart" as foundation;import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/learning_models.dart';
import 'database_service.dart';

class LearningService {
  static const String _assetsPath = 'assets/data/legal_content.json';

  static Future<List<Category>> getCategories() async {
    try {
      final cached = await DatabaseService.getCachedContent('categories');
      if (cached != null) {
        final categories = (cached['data'] as List)
            .map((c) => Category.fromJson(c))
            .toList();
        return categories;
      }

      final jsonString = await rootBundle.loadString(_assetsPath);
      final jsonData = jsonDecode(jsonString);

      final categories = (jsonData['categories'] as List)
          .map((c) => Category.fromJson(c))
          .toList();

      await DatabaseService.cacheContent('categories', {
        'data': categories.map((c) => c.toJson()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      return categories;
    } catch (e) {
      foundation.debugPrint('Error loading categories: $e');
      return [];
    }
  }

  static Future<List<Topic>> getTopicsByCategory(String categoryId) async {
    try {
      final jsonString = await rootBundle.loadString(_assetsPath);
      final jsonData = jsonDecode(jsonString);

      final topics = (jsonData['topics'] as List)
          .where((t) => t['categoryId'] == categoryId)
          .map((t) => Topic.fromJson(t))
          .toList();

      return topics;
    } catch (e) {
      foundation.debugPrint('Error loading topics: $e');
      return [];
    }
  }

  static Future<List<Lesson>> getLessonsByTopic(String topicId) async {
    try {
      final jsonString = await rootBundle.loadString(_assetsPath);
      final jsonData = jsonDecode(jsonString);

      final lessons = (jsonData['lessons'] as List)
          .where((l) => l['topicId'] == topicId)
          .map((l) => Lesson.fromJson(l))
          .toList();

      return lessons;
    } catch (e) {
      foundation.debugPrint('Error loading lessons: $e');
      return [];
    }
  }

  static Future<Quiz?> getQuizByTopic(String topicId) async {
    try {
      final jsonString = await rootBundle.loadString(_assetsPath);
      final jsonData = jsonDecode(jsonString);

      final quizzes = jsonData['quizzes'] as List;
      final quiz = quizzes.firstWhere(
        (q) => q['topicId'] == topicId,
        orElse: () => null,
      );

      return quiz != null ? Quiz.fromJson(quiz) : null;
    } catch (e) {
      foundation.debugPrint('Error loading quiz: $e');
      return null;
    }
  }

  static Future<List<Topic>> searchTopics(String query) async {
    try {
      final jsonString = await rootBundle.loadString(_assetsPath);
      final jsonData = jsonDecode(jsonString);

      final topics = (jsonData['topics'] as List)
          .map((t) => Topic.fromJson(t))
          .toList();

      final lowerQuery = query.toLowerCase();
      return topics.where((topic) {
        return topic.title.toLowerCase().contains(lowerQuery) ||
            topic.description.toLowerCase().contains(lowerQuery) ||
            topic.keywords.any((k) => k.toLowerCase().contains(lowerQuery));
      }).toList();
    } catch (e) {
      foundation.debugPrint('Error searching topics: $e');
      return [];
    }
  }

  static Future<List<Topic>> getAllTopics() async {
    try {
      final jsonString = await rootBundle.loadString(_assetsPath);
      final jsonData = jsonDecode(jsonString);

      final topics = (jsonData['topics'] as List)
          .map((t) => Topic.fromJson(t))
          .toList();

      return topics;
    } catch (e) {
      foundation.debugPrint('Error loading all topics: $e');
      return [];
    }
  }

  static Future<void> saveLearningProgress(LearningProgress progress) async {
    final key = '${progress.userId}_${progress.topicId}';
    await DatabaseService.saveLearningProgress(key, progress.toJson());
  }

  static Future<LearningProgress?> getUserLearningProgress(
    String userId,
    String topicId,
  ) async {
    final key = '${userId}_$topicId';
    final data = await DatabaseService.getLearningProgress(key);
    return data != null ? LearningProgress.fromJson(data) : null;
  }

  static Future<List<LearningProgress>> getUserAllProgress(
    String userId,
  ) async {
    final data = await DatabaseService.getUserLearningProgress(userId);
    return data.map((d) => LearningProgress.fromJson(d)).toList();
  }

  static Future<Map<String, dynamic>> getLearningStats(String userId) async {
    final progress = await getUserAllProgress(userId);

    final completedTopics = progress.where((p) => p.topicCompleted).length;
    final totalTopics = progress.length;
    final averageScore = progress.isNotEmpty
        ? progress
                  .where((p) => p.quizScore != null)
                  .fold<int>(0, (sum, p) => sum + (p.quizScore ?? 0)) /
              progress.where((p) => p.quizScore != null).length
        : 0.0;

    return {
      'completedTopics': completedTopics,
      'totalTopics': totalTopics,
      'completionPercentage': totalTopics > 0
          ? (completedTopics / totalTopics * 100).toStringAsFixed(1)
          : '0',
      'averageQuizScore': averageScore.toStringAsFixed(1),
      'lastActivityDate': progress.isNotEmpty
          ? progress
                .map((p) => p.lastAccessedAt)
                .reduce((a, b) => a.isAfter(b) ? a : b)
          : null,
    };
  }
}
