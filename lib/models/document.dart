class LegalDocument {
  final String id;
  final String name;
  final String type; // pdf, form, chat, evidence
  final String filePath;
  final int sizeInBytes;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final String? formId;
  final Map<String, dynamic>? metadata;

  LegalDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.filePath,
    required this.sizeInBytes,
    required this.createdAt,
    this.modifiedAt,
    this.formId,
    this.metadata,
  });

  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'filePath': filePath,
    'sizeInBytes': sizeInBytes,
    'createdAt': createdAt.toIso8601String(),
    'modifiedAt': modifiedAt?.toIso8601String(),
    'formId': formId,
    'metadata': metadata,
  };

  factory LegalDocument.fromJson(Map<String, dynamic> json) => LegalDocument(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    filePath: json['filePath'],
    sizeInBytes: json['sizeInBytes'],
    createdAt: DateTime.parse(json['createdAt']),
    modifiedAt: json['modifiedAt'] != null ? DateTime.parse(json['modifiedAt']) : null,
    formId: json['formId'],
    metadata: json['metadata'],
  );
}