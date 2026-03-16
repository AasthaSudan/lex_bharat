class ComplaintReport {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String violationType;
  final String status;
  final List<String> evidenceUrls;
  final List<String> witnesses;
  final DateTime incidentDate;
  final DateTime createdAt;
  final DateTime? resolvedDate;
  final String? assignedOfficer;
  final String? caseNumber;
  final bool isAnonymous;
  final double severity;

  ComplaintReport({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.violationType,
    this.status = 'draft',
    this.evidenceUrls = const [],
    this.witnesses = const [],
    required this.incidentDate,
    required this.createdAt,
    this.resolvedDate,
    this.assignedOfficer,
    this.caseNumber,
    this.isAnonymous = false,
    this.severity = 3.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'violationType': violationType,
    'status': status,
    'evidenceUrls': evidenceUrls,
    'witnesses': witnesses,
    'incidentDate': incidentDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'resolvedDate': resolvedDate?.toIso8601String(),
    'assignedOfficer': assignedOfficer,
    'caseNumber': caseNumber,
    'isAnonymous': isAnonymous,
    'severity': severity,
  };

  factory ComplaintReport.fromJson(Map<String, dynamic> json) {
    return ComplaintReport(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      violationType: json['violationType'] as String,
      status: json['status'] as String? ?? 'draft',
      evidenceUrls: List<String>.from(json['evidenceUrls'] as List? ?? []),
      witnesses: List<String>.from(json['witnesses'] as List? ?? []),
      incidentDate: DateTime.parse(json['incidentDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedDate: json['resolvedDate'] != null ? DateTime.parse(json['resolvedDate'] as String) : null,
      assignedOfficer: json['assignedOfficer'] as String?,
      caseNumber: json['caseNumber'] as String?,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      severity: (json['severity'] as num?)?.toDouble() ?? 3.0,
    );
  }
}

