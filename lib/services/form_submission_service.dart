import 'package:flutter/services.dart';
import 'dart:convert';
import 'database_service.dart';

// Model classes
class FormSubmissionStatus {
  final String id;
  final String userId;
  final String formType;
  final String status; // submitted, under_review, approved, rejected
  final DateTime submittedAt;
  final DateTime updatedAt;
  final String? adminNotes;
  final int? caseNumber; // For FIR forms

  FormSubmissionStatus({
    required this.id,
    required this.userId,
    required this.formType,
    required this.status,
    required this.submittedAt,
    required this.updatedAt,
    this.adminNotes,
    this.caseNumber,
  });

  factory FormSubmissionStatus.fromJson(Map<String, dynamic> json) {
    return FormSubmissionStatus(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      formType: json['form_type'] ?? '',
      status: json['status'] ?? 'submitted',
      submittedAt: DateTime.parse(
        json['submitted_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      adminNotes: json['admin_notes'],
      caseNumber: json['case_number'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'form_type': formType,
    'status': status,
    'submitted_at': submittedAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'admin_notes': adminNotes,
    'case_number': caseNumber,
  };
}

class FormTemplate {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<FormFieldTemplate> fields;
  final String instructions;

  FormTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.fields,
    required this.instructions,
  });

  factory FormTemplate.fromJson(Map<String, dynamic> json) {
    return FormTemplate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      fields: (json['fields'] as List?)
          ?.map((f) => FormFieldTemplate.fromJson(f))
          .toList() ?? [],
      instructions: json['instructions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'category': category,
    'fields': fields.map((f) => f.toJson()).toList(),
    'instructions': instructions,
  };
}

class FormFieldTemplate {
  final String id;
  final String label;
  final String type;
  final String? placeholder;
  final bool required;
  final String? helperText;
  final List<String>? options;

  FormFieldTemplate({
    required this.id,
    required this.label,
    required this.type,
    this.placeholder,
    this.required = false,
    this.helperText,
    this.options,
  });

  factory FormFieldTemplate.fromJson(Map<String, dynamic> json) {
    return FormFieldTemplate(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      type: json['type'] ?? 'text',
      placeholder: json['placeholder'],
      required: json['required'] ?? false,
      helperText: json['helperText'],
      options: List<String>.from(json['options'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'type': type,
    'placeholder': placeholder,
    'required': required,
    'helperText': helperText,
    'options': options,
  };
}

class FormSubmissionException implements Exception {
  final String message;
  final Exception? originalException;

  FormSubmissionException({
    required this.message,
    this.originalException,
  });

  @override
  String toString() => message;
}

/// Production-grade form submission service with offline-first architecture
class FormSubmissionService {
  static const String _formTemplatesPath = 'assets/data/form_templates.json';

  /// Submit a form with validation and error handling (offline-first)
  Future<String> submitForm({
    required String userId,
    required String formType, // 'fir', 'legal_aid', 'rti', 'consumer', 'labor'
    required Map<String, dynamic> formData,
    List<String>? attachmentUrls,
  }) async {
    try {
      // Validate form data
      _validateFormData(formType, formData);

      // Create submission ID
      final submissionId = DateTime.now().millisecondsSinceEpoch.toString();

      // Save to local database
      await DatabaseService.saveFormResponse(submissionId, {
        'id': submissionId,
        'user_id': userId,
        'form_type': formType,
        'form_data': formData,
        'attachment_urls': attachmentUrls ?? [],
        'status': 'submitted',
        'submitted_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return submissionId;
    } catch (e) {
      throw FormSubmissionException(
        message: 'Failed to submit form: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Validate form data based on form type
  void _validateFormData(String formType, Map<String, dynamic> formData) {
    switch (formType) {
      case 'fir':
        _validateFIRForm(formData);
        break;
      case 'legal_aid':
        _validateLegalAidForm(formData);
        break;
      case 'rti':
        _validateRTIForm(formData);
        break;
      case 'consumer':
        _validateConsumerForm(formData);
        break;
      case 'labor':
        _validateLaborForm(formData);
        break;
      default:
        throw FormSubmissionException(message: 'Unknown form type: $formType');
    }
  }

  void _validateFIRForm(Map<String, dynamic> data) {
    final required = [
      'complainant_name',
      'incident_description',
      'incident_date',
      'police_station',
    ];
    for (final field in required) {
      if (data[field]?.toString().isEmpty ?? true) {
        throw FormSubmissionException(
          message: 'Missing required field: $field',
        );
      }
    }
  }

  void _validateLegalAidForm(Map<String, dynamic> data) {
    final required = [
      'applicant_name',
      'monthly_income',
      'case_description',
      'contact_number',
    ];
    for (final field in required) {
      if (data[field]?.toString().isEmpty ?? true) {
        throw FormSubmissionException(
          message: 'Missing required field: $field',
        );
      }
    }
  }

  void _validateRTIForm(Map<String, dynamic> data) {
    final required = [
      'applicant_name',
      'information_sought',
      'public_authority',
    ];
    for (final field in required) {
      if (data[field]?.toString().isEmpty ?? true) {
        throw FormSubmissionException(
          message: 'Missing required field: $field',
        );
      }
    }
  }

  void _validateConsumerForm(Map<String, dynamic> data) {
    final required = [
      'complainant_name',
      'complaint_description',
      'amount_involved',
      'opposite_party',
    ];
    for (final field in required) {
      if (data[field]?.toString().isEmpty ?? true) {
        throw FormSubmissionException(
          message: 'Missing required field: $field',
        );
      }
    }
  }

  void _validateLaborForm(Map<String, dynamic> data) {
    final required = [
      'worker_name',
      'employer_name',
      'complaint_type',
      'complaint_description',
    ];
    for (final field in required) {
      if (data[field]?.toString().isEmpty ?? true) {
        throw FormSubmissionException(
          message: 'Missing required field: $field',
        );
      }
    }
  }

  /// Get form submission status (offline-first)
  Future<FormSubmissionStatus> getFormStatus(String submissionId) async {
    try {
      final response = await DatabaseService.getFormResponse(submissionId);

      if (response == null) {
        throw FormSubmissionException(
          message: 'Form submission not found',
        );
      }

      return FormSubmissionStatus.fromJson(response);
    } catch (e) {
      throw FormSubmissionException(
        message: 'Failed to fetch form status: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Get user's form submissions (offline-first)
  Future<List<FormSubmissionStatus>> getUserFormSubmissions(
    String userId,
  ) async {
    try {
      final responses = await DatabaseService.getUserFormResponses(userId);

      return responses
          .map((item) => FormSubmissionStatus.fromJson(item))
          .toList();
    } catch (e) {
      throw FormSubmissionException(
        message: 'Failed to fetch submissions: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Update form submission status (offline-first)
  Future<void> updateFormStatus(
    String submissionId,
    String newStatus, {
    String? notes,
  }) async {
    try {
      final existing = await DatabaseService.getFormResponse(submissionId);

      if (existing == null) {
        throw FormSubmissionException(
          message: 'Form submission not found',
        );
      }

      // Update in local database
      await DatabaseService.saveFormResponse(submissionId, {
        ...existing,
        'status': newStatus,
        'admin_notes': notes,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw FormSubmissionException(
        message: 'Failed to update form: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }

  /// Get form templates available offline
  Future<List<FormTemplate>> getFormTemplates() async {
    try {
      final jsonString = await rootBundle.loadString(_formTemplatesPath);
      final jsonData = jsonDecode(jsonString);

      final templates = (jsonData['templates'] as List?)
          ?.map((json) => FormTemplate.fromJson(json))
          .toList() ?? [];

      return templates;
    } catch (e) {
      throw FormSubmissionException(
        message: 'Failed to load templates: ${e.toString()}',
        originalException: e as Exception?,
      );
    }
  }
}
