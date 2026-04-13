class Category {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int topicCount;
  final List<String> keywords;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.topicCount,
    required this.keywords,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    icon: json['icon'] ?? '',
    color: json['color'] ?? '',
    topicCount: json['topicCount'] ?? 0,
    keywords: List<String>.from(json['keywords'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'color': color,
    'topicCount': topicCount,
    'keywords': keywords,
  };
}

class Topic {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String difficulty;
  final int estimatedTime;
  final List<String> keywords;
  final int lessonsCount;
  final double progressPercentage;
  final bool isCompleted;

  Topic({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedTime,
    required this.keywords,
    required this.lessonsCount,
    this.progressPercentage = 0.0,
    this.isCompleted = false,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json['id'] ?? '',
    categoryId: json['categoryId'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    difficulty: json['difficulty'] ?? 'Beginner',
    estimatedTime: json['estimatedTime'] ?? 0,
    keywords: List<String>.from(json['keywords'] ?? []),
    lessonsCount: json['lessonsCount'] ?? 0,
    progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
    isCompleted: json['isCompleted'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'title': title,
    'description': description,
    'difficulty': difficulty,
    'estimatedTime': estimatedTime,
    'keywords': keywords,
    'lessonsCount': lessonsCount,
    'progressPercentage': progressPercentage,
    'isCompleted': isCompleted,
  };

  Topic copyWith({
    double? progressPercentage,
    bool? isCompleted,
  }) =>
      Topic(
        id: id,
        categoryId: categoryId,
        title: title,
        description: description,
        difficulty: difficulty,
        estimatedTime: estimatedTime,
        keywords: keywords,
        lessonsCount: lessonsCount,
        progressPercentage: progressPercentage ?? this.progressPercentage,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class Lesson {
  final String id;
  final String topicId;
  final String title;
  final String content;
  final String contentType; // text, video, audio, interactive
  final String videoUrl;
  final String audioUrl;
  final List<KeyPoint> keyPoints;
  final int durationSeconds;
  final bool isCompleted;
  final DateTime? completedAt;

  Lesson({
    required this.id,
    required this.topicId,
    required this.title,
    required this.content,
    required this.contentType,
    required this.videoUrl,
    required this.audioUrl,
    required this.keyPoints,
    required this.durationSeconds,
    this.isCompleted = false,
    this.completedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['id'] ?? '',
    topicId: json['topicId'] ?? '',
    title: json['title'] ?? '',
    content: json['content'] ?? '',
    contentType: json['contentType'] ?? 'text',
    videoUrl: json['videoUrl'] ?? '',
    audioUrl: json['audioUrl'] ?? '',
    keyPoints: (json['keyPoints'] as List?)
        ?.map((k) => KeyPoint.fromJson(k))
        .toList() ?? [],
    durationSeconds: json['durationSeconds'] ?? 0,
    isCompleted: json['isCompleted'] ?? false,
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'topicId': topicId,
    'title': title,
    'content': content,
    'contentType': contentType,
    'videoUrl': videoUrl,
    'audioUrl': audioUrl,
    'keyPoints': keyPoints.map((k) => k.toJson()).toList(),
    'durationSeconds': durationSeconds,
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
  };

  Lesson copyWith({bool? isCompleted, DateTime? completedAt}) => Lesson(
    id: id,
    topicId: topicId,
    title: title,
    content: content,
    contentType: contentType,
    videoUrl: videoUrl,
    audioUrl: audioUrl,
    keyPoints: keyPoints,
    durationSeconds: durationSeconds,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt ?? this.completedAt,
  );
}

class KeyPoint {
  final String title;
  final String description;
  final List<String> details;
  final String icon;

  KeyPoint({
    required this.title,
    required this.description,
    required this.details,
    required this.icon,
  });

  factory KeyPoint.fromJson(Map<String, dynamic> json) => KeyPoint(
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    details: List<String>.from(json['details'] ?? []),
    icon: json['icon'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'details': details,
    'icon': icon,
  };
}

class Quiz {
  final String id;
  final String topicId;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int passingScore;
  final bool isCompleted;
  final int? score;
  final DateTime? completedAt;

  Quiz({
    required this.id,
    required this.topicId,
    required this.title,
    required this.description,
    required this.questions,
    required this.passingScore,
    this.isCompleted = false,
    this.score,
    this.completedAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    id: json['id'] ?? '',
    topicId: json['topicId'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    questions: (json['questions'] as List?)
        ?.map((q) => QuizQuestion.fromJson(q))
        .toList() ?? [],
    passingScore: json['passingScore'] ?? 70,
    isCompleted: json['isCompleted'] ?? false,
    score: json['score'],
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'topicId': topicId,
    'title': title,
    'description': description,
    'questions': questions.map((q) => q.toJson()).toList(),
    'passingScore': passingScore,
    'isCompleted': isCompleted,
    'score': score,
    'completedAt': completedAt?.toIso8601String(),
  };

  Quiz copyWith({int? score, bool? isCompleted, DateTime? completedAt}) =>
      Quiz(
        id: id,
        topicId: topicId,
        title: title,
        description: description,
        questions: questions,
        passingScore: passingScore,
        isCompleted: isCompleted ?? this.isCompleted,
        score: score ?? this.score,
        completedAt: completedAt ?? this.completedAt,
      );
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final int? selectedAnswerIndex;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.selectedAnswerIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    id: json['id'] ?? '',
    question: json['question'] ?? '',
    options: List<String>.from(json['options'] ?? []),
    correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
    explanation: json['explanation'],
    selectedAnswerIndex: json['selectedAnswerIndex'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
    'correctAnswerIndex': correctAnswerIndex,
    'explanation': explanation,
    'selectedAnswerIndex': selectedAnswerIndex,
  };

  bool get isCorrect =>
      selectedAnswerIndex != null && selectedAnswerIndex == correctAnswerIndex;

  QuizQuestion copyWith({int? selectedAnswerIndex}) => QuizQuestion(
    id: id,
    question: question,
    options: options,
    correctAnswerIndex: correctAnswerIndex,
    explanation: explanation,
    selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
  );
}

class LearningProgress {
  final String userId;
  final String topicId;
  final double progressPercentage;
  final List<String> completedLessonIds;
  final int? quizScore;
  final bool topicCompleted;
  final DateTime lastAccessedAt;
  final DateTime? completedAt;

  LearningProgress({
    required this.userId,
    required this.topicId,
    required this.progressPercentage,
    required this.completedLessonIds,
    this.quizScore,
    required this.topicCompleted,
    required this.lastAccessedAt,
    this.completedAt,
  });

  factory LearningProgress.fromJson(Map<String, dynamic> json) =>
      LearningProgress(
        userId: json['userId'] ?? '',
        topicId: json['topicId'] ?? '',
        progressPercentage:
            (json['progressPercentage'] ?? 0.0).toDouble(),
        completedLessonIds:
            List<String>.from(json['completedLessonIds'] ?? []),
        quizScore: json['quizScore'],
        topicCompleted: json['topicCompleted'] ?? false,
        lastAccessedAt: DateTime.parse(
          json['lastAccessedAt'] ??
              DateTime.now().toIso8601String(),
        ),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'topicId': topicId,
    'progressPercentage': progressPercentage,
    'completedLessonIds': completedLessonIds,
    'quizScore': quizScore,
    'topicCompleted': topicCompleted,
    'lastAccessedAt': lastAccessedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };
}

