import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'form_review_screen.dart';

class FormFillingWizardScreen extends StatefulWidget {
  final String formTitle;

  const FormFillingWizardScreen({Key? key, required this.formTitle})
      : super(key: key);

  @override
  _FormFillingWizardScreenState createState() =>
      _FormFillingWizardScreenState();
}

class _FormFillingWizardScreenState extends State<FormFillingWizardScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  final List<FormStepData> _steps = [
    FormStepData(
      title: 'Personal Information',
      fields: [
        FormFieldData(key: 'name', label: 'Full Name', hint: 'Enter your name'),
        FormFieldData(
            key: 'phone', label: 'Phone Number', hint: '10-digit number'),
        FormFieldData(key: 'email', label: 'Email', hint: 'your@email.com'),
      ],
    ),
    FormStepData(
      title: 'Details',
      fields: [
        FormFieldData(key: 'address', label: 'Address', hint: 'Full address', maxLines: 3),
        FormFieldData(
            key: 'description',
            label: 'Description',
            hint: 'Describe the issue',
            maxLines: 5),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formTitle),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${_currentStep + 1} of ${_steps.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _steps.length,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _steps[_currentStep].title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Fields
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: _steps[_currentStep].fields.map((field) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      initialValue: _formData[field.key],
                      decoration: InputDecoration(
                        labelText: field.label,
                        hintText: field.hint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                  );
                }).toList(),
              ),
            ),

            // Buttons
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        child: Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 16),
                  Expanded(
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
                      child: Text(
                        _currentStep < _steps.length - 1 ? 'Next' : 'Review',
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
  FormFieldData({
    required this.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });
}