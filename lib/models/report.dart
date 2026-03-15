class LegalReport {
  final String id;
  final String category; // labor, domestic_violence, consumer, etc
  final String title;
  final String description;
  final DateTime incidentDate;
  final String location;
  final List<String> evidenceFiles;
  final List<Person> peopleInvolved;
  final String status; // draft, submitted, in_progress, resolved
  final DateTime createdAt;
  final DateTime? submittedAt;
  final String? referenceNumber;

  LegalReport({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.incidentDate,
    required this.location,
    this.evidenceFiles = const [],
    this.peopleInvolved = const [],
    this.status = 'draft',
    required this.createdAt,
    this.submittedAt,
    this.referenceNumber,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'title': title,
    'description': description,
    'incidentDate': incidentDate.toIso8601String(),
    'location': location,
    'evidenceFiles': evidenceFiles,
    'peopleInvolved': peopleInvolved.map((p) => p.toJson()).toList(),
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'submittedAt': submittedAt?.toIso8601String(),
    'referenceNumber': referenceNumber,
  };

  factory LegalReport.fromJson(Map<String, dynamic> json) => LegalReport(
    id: json['id'],
    category: json['category'],
    title: json['title'],
    description: json['description'],
    incidentDate: DateTime.parse(json['incidentDate']),
    location: json['location'],
    evidenceFiles: List<String>.from(json['evidenceFiles'] ?? []),
    peopleInvolved: (json['peopleInvolved'] as List?)
        ?.map((p) => Person.fromJson(p))
        .toList() ??
        [],
    status: json['status'] ?? 'draft',
    createdAt: DateTime.parse(json['createdAt']),
    submittedAt: json['submittedAt'] != null ? DateTime.parse(json['submittedAt']) : null,
    referenceNumber: json['referenceNumber'],
  );
}

class Person {
  final String name;
  final String? contact;
  final String role; // victim, accused, witness

  Person({
    required this.name,
    this.contact,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'contact': contact,
    'role': role,
  };

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    name: json['name'],
    contact: json['contact'],
    role: json['role'],
  );
}