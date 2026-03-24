import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'form_review_screen.dart';

class FormFillingWizardScreen extends StatefulWidget {
  final String formTitle;

  const FormFillingWizardScreen({super.key, required this.formTitle});

  @override
  State<FormFillingWizardScreen> createState() => _FormFillingWizardScreenState();
}

class _FormFillingWizardScreenState extends State<FormFillingWizardScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  late List<FormStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = _getStepsForForm(widget.formTitle);
  }

  List<FormStepData> _getStepsForForm(String title) {
    if (title.contains('FIR')) {
      return [
        FormStepData(
          title: 'Personal Information',
          fields: [
            FormFieldData(key: 'name', label: 'Full Name', hint: 'Enter your name'),
            FormFieldData(key: 'phone', label: 'Phone Number', hint: '10-digit number'),
            FormFieldData(key: 'address', label: 'Address', hint: 'Full address', maxLines: 2),
          ],
        ),
        FormStepData(
          title: 'Incident Details',
          fields: [
            FormFieldData(key: 'date', label: 'Date of Incident', hint: 'DD/MM/YYYY'),
            FormFieldData(key: 'time', label: 'Time of Incident', hint: 'HH:MM AM/PM'),
            FormFieldData(key: 'location', label: 'Location', hint: 'Where did it happen?'),
            FormFieldData(key: 'description', label: 'Description', hint: 'Describe the incident in detail', maxLines: 5),
          ],
        ),
      ];
    } else if (title.contains('Consumer')) {
      return [
        FormStepData(
          title: 'Personal Information',
          fields: [
            FormFieldData(key: 'name', label: 'Full Name', hint: 'Enter your name'),
            FormFieldData(key: 'phone', label: 'Phone Number', hint: '10-digit number'),
          ],
        ),
        FormStepData(
          title: 'Complaint Details',
          fields: [
            FormFieldData(key: 'seller', label: 'Seller/Company Name', hint: 'Name of the business'),
            FormFieldData(key: 'product', label: 'Product/Service', hint: 'What did you purchase?'),
            FormFieldData(key: 'issue', label: 'Issue Description', hint: 'Describe the defect or problem', maxLines: 5),
          ],
        ),
      ];
    } else {
      return [
        FormStepData(
          title: 'Personal Information',
          fields: [
            FormFieldData(key: 'name', label: 'Full Name', hint: 'Enter your name'),
            FormFieldData(key: 'phone', label: 'Phone Number', hint: '10-digit number'),
            FormFieldData(key: 'email', label: 'Email', hint: 'your@email.com'),
          ],
        ),
        FormStepData(
          title: 'Details',
          fields: [
            FormFieldData(key: 'address', label: 'Address', hint: 'Full address', maxLines: 3),
            FormFieldData(key: 'description', label: 'Description', hint: 'Describe the issue', maxLines: 5),
          ],
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: AppColors.textPrimary,
        ),
        title: Text(widget.formTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textPrimary, letterSpacing: -0.5)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _steps[_currentStep].title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Text(
                        'Step ${_currentStep + 1} of ${_steps.length}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / _steps.length,
                      backgroundColor: AppColors.gray200,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            // Form Fields
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: _steps[_currentStep].fields.map((field) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field.label,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _formData[field.key],
                          decoration: InputDecoration(
                            hintText: field.hint,
                            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppColors.gray200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppColors.gray200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.primary, width: 2),
                            ),
                          ),
                          maxLines: field.maxLines,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _formData[field.key] = value ?? '';
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: BorderSide(color: AppColors.gray300),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (_currentStep < _steps.length - 1) {
                            setState(() {
                              _currentStep++;
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FormReviewScreen(
                                  formData: _formData,
                                  formTitle: widget.formTitle,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        _currentStep < _steps.length - 1 ? 'Next Step' : 'Review Draft',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormStepData {
  final String title;
  final List<FormFieldData> fields;
  FormStepData({required this.title, required this.fields});
}

class FormFieldData {
  final String key;
  final String label;
  final String hint;
  final int maxLines;
  FormFieldData({required this.key, required this.label, required this.hint, this.maxLines = 1});
}