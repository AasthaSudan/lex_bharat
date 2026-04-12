import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learning_models.dart';
import '../services/learning_service.dart';

// Categories provider
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return LearningService.getCategories();
});

// Topics by category provider
final topicsByCategoryProvider =
    FutureProvider.family<List<Topic>, String>((ref, categoryId) async {
  return LearningService.getTopicsByCategory(categoryId);
});

// All topics provider
final allTopicsProvider = FutureProvider<List<Topic>>((ref) async {
  return LearningService.getAllTopics();
});

// Lessons by topic provider
final lessonsByTopicProvider =
    FutureProvider.family<List<Lesson>, String>((ref, topicId) async {
  return LearningService.getLessonsByTopic(topicId);
});

final quizByTopicProvider =
    FutureProvider.family<Quiz?, String>((ref, topicId) async {
  return LearningService.getQuizByTopic(topicId);
});

final searchTopicsProvider =
    FutureProvider.family<List<Topic>, String>((ref, query) async {
  if (query.isEmpty) return [];
  return LearningService.searchTopics(query);
});

final userLearningProgressProvider =
    FutureProvider.family<LearningProgress?, ({String userId, String topicId})>(
  (ref, params) async {
    return LearningService.getUserLearningProgress(
      params.userId,
      params.topicId,
    );
  },
);

final userAllProgressProvider =
    FutureProvider.family<List<LearningProgress>, String>((ref, userId) async {
  return LearningService.getUserAllProgress(userId);
});

final learningStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  return LearningService.getLearningStats(userId);
});

final selectedTopicProvider = NotifierProvider<SelectedTopicNotifier, String?>(
  SelectedTopicNotifier.new,
);

class SelectedTopicNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectTopic(String topicId) => state = topicId;
  void clearSelection() => state = null;
}

final selectedLessonProvider = NotifierProvider<SelectedLessonNotifier, String?>(
  SelectedLessonNotifier.new,
);

class SelectedLessonNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectLesson(String lessonId) => state = lessonId;
  void clearSelection() => state = null;
}

final lessonCompletionProvider = NotifierProvider<LessonCompletionNotifier, Map<String, bool>>(
  LessonCompletionNotifier.new,
);

class LessonCompletionNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  void markLessonComplete(String lessonId, bool isComplete) {
    state = {...state, lessonId: isComplete};
  }

  bool isLessonComplete(String lessonId) => state[lessonId] ?? false;

  void clearCompletion() => state = {};
}

