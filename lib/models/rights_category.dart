class RightsCategory {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<RightsTopic> topics;
  final int progressPercentage;

  RightsCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.topics,
    this.progressPercentage = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'topics': topics.map((e) => e.toJson()).toList(),
    'progressPercentage': progressPercentage,
  };

  factory RightsCategory.fromJson(Map<String, dynamic> json) {
    return RightsCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      topics: (json['topics'] as List<dynamic>?)
          ?.map((e) => RightsTopic.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      progressPercentage: json['progressPercentage'] as int? ?? 0,
    );
  }
}

class RightsTopic {
  final String id;
  final String title;
  final String content;
  final String audioUrl;
  final String videoUrl;
  final List<String> infographicUrls;
  final bool isCompleted;

  RightsTopic({
    required this.id,
    required this.title,
    required this.content,
    this.audioUrl = '',
    this.videoUrl = '',
    this.infographicUrls = const [],
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'audioUrl': audioUrl,
    'videoUrl': videoUrl,
    'infographicUrls': infographicUrls,
    'isCompleted': isCompleted,
  };

  factory RightsTopic.fromJson(Map<String, dynamic> json) {
    return RightsTopic(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      audioUrl: json['audioUrl'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      infographicUrls: List<String>.from(json['infographicUrls'] as List? ?? []),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

