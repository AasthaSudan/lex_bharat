import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/form_submission_service.dart';
import '../../utils/colors.dart';
import '../../widgets/components/index.dart';

/// Example production-ready form screen using FormWizard and real API integration
class ProductionFormExampleScreen extends ConsumerStatefulWidget {
  final String formType; // 'fir', 'legal_aid', etc.

  const ProductionFormExampleScreen({required this.formType, super.key});

  @override
  ConsumerState<ProductionFormExampleScreen> createState() =>
      _ProductionFormExampleScreenState();
}

class _ProductionFormExampleScreenState
    extends ConsumerState<ProductionFormExampleScreen> {
  late FormSubmissionService _formService;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _formService = FormSubmissionService();
  }

  /// Create form steps based on form type
  List<FormWizardStep> _createFormSteps() {
    switch (widget.formType) {
      case 'fir':
        return _createFIRFormSteps();
      case 'legal_aid':
        return _createLegalAidFormSteps();
      case 'rti':
        return _createRTIFormSteps();
      default:
        return [];
    }
  }

  List<FormWizardStep> _createFIRFormSteps() {
    return [
      FormWizardStep(
        id: 'complainant_info',
        title: 'Complainant Information',
        description: 'Tell us about the person filing the complaint',
        fields: [
          FormField(
            id: 'complainant_name',
            label: 'Full Name',
            hint: 'Enter your full name',
            isRequired: true,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Name is required';
              if (value!.length < 3)
                return 'Name must be at least 3 characters';
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                return 'Name can only contain letters';
              }
              return null;
            },
            help: 'As per your ID proof',
          ),
          FormField(
            id: 'contact_number',
            label: 'Mobile Number',
            hint: '10-digit phone number',
            keyboardType: TextInputType.phone,
            isRequired: true,
            maxLength: 10,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Phone number is required';
              if (!RegExp(r'^\d{10}$').hasMatch(value!)) {
                return 'Enter a valid 10-digit number';
              }
              return null;
            },
          ),
          FormField(
            id: 'email',
            label: 'Email Address',
            hint: 'your.email@example.com',
            keyboardType: TextInputType.emailAddress,
            isRequired: false,
            validator: (value) {
              if (value?.isNotEmpty ?? false) {
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value!)) {
                  return 'Enter a valid email address';
                }
              }
              return null;
            },
          ),
        ],
      ),
      FormWizardStep(
        id: 'incident_details',
        title: 'Incident Details',
        description: 'Describe what happened in detail',
        fields: [
          FormField(
            id: 'incident_location',
            label: 'Location of Incident',
            hint: 'Street, area, landmark',
            isRequired: true,
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Location is required' : null,
          ),
          FormField(
            id: 'incident_date',
            label: 'Date of Incident',
            hint: 'DD-MM-YYYY',
            isRequired: true,
            keyboardType: TextInputType.datetime,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Date is required';
              // Basic date validation
              try {
                DateTime.parse(value!);
              } catch (e) {
                return 'Enter a valid date (DD-MM-YYYY)';
              }
              return null;
            },
          ),
          FormField(
            id: 'incident_description',
            label: 'Detailed Description',
            hint: 'Provide a comprehensive account of the incident',
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            maxLength: 1000,
            isRequired: true,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Description is required';
              if (value!.length < 50) {
                return 'Please provide at least 50 characters';
              }
              return null;
            },
            help: 'Include: what happened, when, where, who was involved',
          ),
        ],
      ),
      FormWizardStep(
        id: 'police_station',
        title: 'Police Station Details',
        description: 'Which police station will you file the complaint at?',
        fields: [
          FormField(
            id: 'police_station',
            label: 'Police Station Name',
            hint: 'Search or enter police station name',
            isRequired: true,
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Police station is required' : null,
            help: 'Select from nearby police stations',
          ),
          FormField(
            id: 'district',
            label: 'District',
            hint: 'Select district',
            isRequired: true,
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'District is required' : null,
          ),
        ],
      ),
      FormWizardStep(
        id: 'review',
        title: 'Review & Confirm',
        description: 'Please review your complaint before submitting',
        fields: [], // No fields for review step
      ),
    ];
  }

  List<FormWizardStep> _createLegalAidFormSteps() {
    return [
      FormWizardStep(
        id: 'applicant_info',
        title: 'Your Information',
        description: 'Tell us about yourself',
        fields: [
          FormField(
            id: 'applicant_name',
            label: 'Full Name',
            isRequired: true,
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Name is required' : null,
          ),
          FormField(
            id: 'age',
            label: 'Age',
            keyboardType: TextInputType.number,
            maxLength: 3,
            isRequired: true,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Age is required';
              final age = int.tryParse(value!);
              if (age == null || age < 18 || age > 120) {
                return 'Enter a valid age';
              }
              return null;
            },
          ),
        ],
      ),
      FormWizardStep(
        id: 'economic_info',
        title: 'Economic Information',
        description: 'Help us assess your eligibility',
        fields: [
          FormField(
            id: 'monthly_income',
            label: 'Monthly Income (₹)',
            hint: '0',
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Income is required' : null,
            help: 'Total household income per month',
          ),
          FormField(
            id: 'family_size',
            label: 'Family Size',
            hint: 'Number of dependents',
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Family size is required' : null,
          ),
        ],
      ),
      FormWizardStep(
        id: 'case_details',
        title: 'Case Details',
        description: 'Describe your legal case',
        fields: [
          FormField(
            id: 'case_description',
            label: 'Case Description',
            hint: 'Briefly explain your legal issue',
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            isRequired: true,
            validator: (value) => (value?.isEmpty ?? true)
                ? 'Case description is required'
                : null,
          ),
          FormField(
            id: 'case_type',
            label: 'Type of Case',
            hint: 'Civil, Criminal, Labour, etc.',
            isRequired: true,
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Case type is required' : null,
          ),
        ],
      ),
    ];
  }

  List<FormWizardStep> _createRTIFormSteps() {
    return [
      FormWizardStep(
        id: 'applicant',
        title: 'Applicant Details',
        description: 'Who is filing this RTI request?',
        fields: [
          FormField(id: 'applicant_name', label: 'Full Name', isRequired: true),
          FormField(
            id: 'contact_number',
            label: 'Contact Number',
            keyboardType: TextInputType.phone,
            isRequired: true,
          ),
        ],
      ),
      FormWizardStep(
        id: 'authority',
        title: 'Public Authority',
        description: 'Which government office should provide the information?',
        fields: [
          FormField(
            id: 'public_authority',
            label: 'Government Office/Authority',
            hint: 'e.g., Municipal Corporation, Revenue Department',
            isRequired: true,
          ),
        ],
      ),
      FormWizardStep(
        id: 'information',
        title: 'Information Sought',
        description: 'Describe the information you seek',
        fields: [
          FormField(
            id: 'information_sought',
            label: 'Detailed Information Request',
            hint: 'Be specific about what information you need',
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            isRequired: true,
          ),
        ],
      ),
    ];
  }

  Future<void> _handleFormSubmit(Map<String, dynamic> formData) async {
    setState(() => _isSubmitting = true);

    try {
      // Get current user (implement based on your auth system)
      final userId = ref.read(
        userIdProvider,
      ); // You'll need to create this provider

      // Submit form to backend
      final submissionId = await _formService.submitForm(
        userId: userId,
        formType: widget.formType,
        formData: formData,
      );

      if (!mounted) return;

      // Show success
      _showSuccessDialog(submissionId);
    } on FormSubmissionException catch (e) {
      if (!mounted) return;
      _showErrorDialog(e.message);
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSuccessDialog(String submissionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.successTint,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppColors.success,
            size: 32,
          ),
        ),
        title: const Text('Form Submitted Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Your form has been submitted for review.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Submission ID:',
                    style: TextStyle(fontSize: 12, color: AppColors.textHint),
                  ),
                  Text(
                    submissionId,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keep this ID for reference. You can track your application status in the "My Applications" section.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to form list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.errorTint,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 32,
          ),
        ),
        title: const Text('Submission Failed'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForFormType(widget.formType)),
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: FormWizard(
        steps: _createFormSteps(),
        formType: widget.formType,
        onSubmit: _handleFormSubmit,
        onCancel: () => Navigator.pop(context),
        allowDraftSave: true,
      ),
    );
  }

  String _getTitleForFormType(String formType) {
    switch (formType) {
      case 'fir':
        return 'Police Complaint (FIR)';
      case 'legal_aid':
        return 'Legal Aid Application';
      case 'rti':
        return 'Right to Information (RTI)';
      case 'consumer':
        return 'Consumer Complaint';
      case 'labor':
        return 'Labor Dispute';
      default:
        return 'Form';
    }
  }
}

// Placeholder provider - implement with your auth system
final userIdProvider = Provider<String>((ref) {
  // Return the current user ID from your auth system
  return 'user-id';
});
