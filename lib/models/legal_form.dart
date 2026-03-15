import 'package:flutter/material.dart';

class LegalForm {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int fieldsCount;
  final int estimatedMinutes;
  final List<FormField> fields;
  final String category;

  LegalForm({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.fieldsCount,
    required this.estimatedMinutes,
    required this.fields,
    required this.category,
  });
}

class FormField {
  final String id;
  final String label;
  final String type; // text, email, phone, date, file, dropdown, textarea
  final bool required;
  final String? hint;
  final List<String>? options;
  final String? validationRegex;
  final int? maxLines;

  FormField({
    required this.id,
    required this.label,
    required this.type,
    this.required = true,
    this.hint,
    this.options,
    this.validationRegex,
    this.maxLines,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'type': type,
    'required': required,
    'hint': hint,
    'options': options,
    'validationRegex': validationRegex,
    'maxLines': maxLines,
  };

  factory FormField.fromJson(Map<String, dynamic> json) => FormField(
    id: json['id'],
    label: json['label'],
    type: json['type'],
    required: json['required'] ?? true,
    hint: json['hint'],
    options: json['options'] != null ? List<String>.from(json['options']) : null,
    validationRegex: json['validationRegex'],
    maxLines: json['maxLines'],
  );
}