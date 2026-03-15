class OfflineDataSync {
  final String id;
  final String entityType; // 'complaint', 'document', 'form'
  final String entityId;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final bool isSynced;
  final String status; // 'pending', 'synced', 'failed'

  OfflineDataSync({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.data,
    required this.createdAt,
    this.syncedAt,
    this.isSynced = false,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'entityType': entityType,
    'entityId': entityId,
    'data': data,
    'createdAt': createdAt.toIso8601String(),
    'syncedAt': syncedAt?.toIso8601String(),
    'isSynced': isSynced,
    'status': status,
  };

  factory OfflineDataSync.fromJson(Map<String, dynamic> json) {
    return OfflineDataSync(
      id: json['id'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      syncedAt: json['syncedAt'] != null ? DateTime.parse(json['syncedAt'] as String) : null,
      isSynced: json['isSynced'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending',
    );
  }
}

class CachedContent {
  final String id;
  final String contentType; // 'rights_category', 'procedure', 'form_template'
  final String title;
  final String description;
  final Map<String, dynamic> content;
  final DateTime cachedAt;
  final DateTime? expiresAt;
  final bool isOfflineAvailable;

  CachedContent({
    required this.id,
    required this.contentType,
    required this.title,
    required this.description,
    required this.content,
    required this.cachedAt,
    this.expiresAt,
    this.isOfflineAvailable = true,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'contentType': contentType,
    'title': title,
    'description': description,
    'content': content,
    'cachedAt': cachedAt.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'isOfflineAvailable': isOfflineAvailable,
  };

  factory CachedContent.fromJson(Map<String, dynamic> json) {
    return CachedContent(
      id: json['id'] as String,
      contentType: json['contentType'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as Map<String, dynamic>,
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
      isOfflineAvailable: json['isOfflineAvailable'] as bool? ?? true,
    );
  }
}

