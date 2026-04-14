import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/components/app_button.dart';
import '../../widgets/components/app_input_field.dart';

/// Production-grade form wizard component with multi-step form handling
class FormWizardStep {
  final String id;
  final String title;
  final String description;
  final List<FormField> fields;

  FormWizardStep({
    required this.id,
    required this.title,
    required this.description,
    required this.fields,
  });
}

/// Individual form field configuration
class FormField {
  final String id;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final bool isRequired;
  final String? Function(String?)? validator;
  final int maxLength;
  final int maxLines;
  final String? help;
  final List<String>? options; // For dropdown fields
  final bool isPassword;

  FormField({
    required this.id,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.validator,
    this.maxLength = 500,
    this.maxLines = 1,
    this.help,
    this.options,
    this.isPassword = false,
  });
}

/// Production-grade form wizard widget
class FormWizard extends StatefulWidget {
  final List<FormWizardStep> steps;
  final String formType;
  final Function(Map<String, dynamic> formData) onSubmit;
  final VoidCallback? onCancel;
  final bool allowDraftSave;
  final Map<String, dynamic>? initialDraftData;

  const FormWizard({
    required this.steps,
    required this.formType,
    required this.onSubmit,
    this.onCancel,
    this.allowDraftSave = true,
    this.initialDraftData,
    super.key,
  });

  @override
  State<FormWizard> createState() => _FormWizardState();
}

class _FormWizardState extends State<FormWizard> {
  late int _currentStep;
  late Map<String, TextEditingController> _controllers;
  late Map<String, String?> _fieldErrors;
  late Map<String, dynamic> _formData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentStep = 0;
    _initializeControllers();
    _fieldErrors = {};
  }

  void _initializeControllers() {
    _controllers = {};
    _formData = widget.initialDraftData ?? {};

    for (final step in widget.steps) {
      for (final field in step.fields) {
        final initialValue = _formData[field.id] ?? '';
        _controllers[field.id] = TextEditingController(text: initialValue);
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _validateCurrentStep() {
    final step = widget.steps[_currentStep];
    bool isValid = true;

    for (final field in step.fields) {
      final controller = _controllers[field.id]!;
      final error =
          field.validator?.call(controller.text) ??
          (field.isRequired && controller.text.isEmpty
              ? 'This field is required'
              : null);

      if (error != null) {
        _fieldErrors[field.id] = error;
        isValid = false;
      } else {
        _fieldErrors.remove(field.id);
      }
    }

    return isValid;
  }

  void _saveFormData() {
    final step = widget.steps[_currentStep];
    for (final field in step.fields) {
      _formData[field.id] = _controllers[field.id]!.text;
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      _saveFormData();

      if (_currentStep < widget.steps.length - 1) {
        setState(() => _currentStep++);
      } else {
        _submitForm();
      }
    } else {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors before proceeding'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _previousStep() {
    _saveFormData();
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitForm() {
    setState(() => _isLoading = true);

    try {
      widget.onSubmit(_formData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting form: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];
    final isFirstStep = _currentStep == 0;
    final isLastStep = _currentStep == widget.steps.length - 1;

    return WillPopScope(
      onWillPop: () async {
        widget.onCancel?.call();
        return true;
      },
      child: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of ${widget.steps.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${((_currentStep + 1) / widget.steps.length * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / widget.steps.length,
                    minHeight: 4,
                    backgroundColor: AppColors.gray200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step title and description
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form fields
                  ...step.fields.map((field) {
                    final controller = _controllers[field.id]!;
                    final error = _fieldErrors[field.id];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppInputField(
                            controller: controller,
                            label: field.label,
                            hint: field.hint,
                            keyboardType: field.keyboardType,
                            isRequired: field.isRequired,
                            maxLength: field.maxLength,
                            maxLines: field.maxLines,
                            errorText: error,
                            obscureText: field.isPassword,
                            semanticLabel: field.label,
                            onChanged: (value) {
                              setState(() {
                                _fieldErrors.remove(field.id);
                              });
                            },
                          ),
                          if (field.help != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              field.help!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textHint,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (!isFirstStep)
                  Expanded(
                    child: AppButton(
                      label: 'Previous',
                      onPressed: _previousStep,
                      variant: ButtonVariant.secondary,
                      isFullWidth: true,
                    ),
                  ),
                if (!isFirstStep) const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: isLastStep ? 'Submit' : 'Next',
                    onPressed: _nextStep,
                    isLoading: _isLoading,
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
