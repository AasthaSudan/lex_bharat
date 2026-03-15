class LegalProcedure {
  final String id;
  final String title;
  final String description;
  final List<ProcedureStep> steps;
  final String estimatedDuration;
  final String difficulty; // easy, moderate, difficult
  final List<String> requiredDocuments;
  final List<String> authorities;
  final String category; // police_complaint, divorce, property, court, etc.

  LegalProcedure({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    this.estimatedDuration = '',
    this.difficulty = 'moderate',
    this.requiredDocuments = const [],
    this.authorities = const [],
    this.category = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'steps': steps.map((e) => e.toJson()).toList(),
    'estimatedDuration': estimatedDuration,
    'difficulty': difficulty,
    'requiredDocuments': requiredDocuments,
    'authorities': authorities,
    'category': category,
  };

  factory LegalProcedure.fromJson(Map<String, dynamic> json) {
    return LegalProcedure(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => ProcedureStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      estimatedDuration: json['estimatedDuration'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'moderate',
      requiredDocuments: List<String>.from(json['requiredDocuments'] as List? ?? []),
      authorities: List<String>.from(json['authorities'] as List? ?? []),
      category: json['category'] as String? ?? '',
    );
  }
}

class ProcedureStep {
  final int stepNumber;
  final String title;
  final String description;
  final String? voiceGuide;
  final String? documentTemplate;
  final List<String> requiredDocuments;
  final String estimatedDays;

  ProcedureStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.voiceGuide,
    this.documentTemplate,
    this.requiredDocuments = const [],
    this.estimatedDays = '',
  });

  Map<String, dynamic> toJson() => {
    'stepNumber': stepNumber,
    'title': title,
    'description': description,
    'voiceGuide': voiceGuide,
    'documentTemplate': documentTemplate,
    'requiredDocuments': requiredDocuments,
    'estimatedDays': estimatedDays,
  };

  factory ProcedureStep.fromJson(Map<String, dynamic> json) {
    return ProcedureStep(
      stepNumber: json['stepNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      voiceGuide: json['voiceGuide'] as String?,
      documentTemplate: json['documentTemplate'] as String?,
      requiredDocuments: List<String>.from(json['requiredDocuments'] as List? ?? []),
      estimatedDays: json['estimatedDays'] as String? ?? '',
    );
  }
}

