import 'package:flutter/material.dart';

class FormFillingWizardScreen extends StatefulWidget {
  const FormFillingWizardScreen({super.key});

  @override
  State<FormFillingWizardScreen> createState() =>
      _FormFillingWizardScreenState();
}

class _FormFillingWizardScreenState extends State<FormFillingWizardScreen> {
  int currentStep = 0;
  final formData = {
    'fullName': '',
    'address': '',
    'phone': '',
    'email': '',
    'description': '',
  };

  @override
  Widget build(BuildContext context) {
    final steps = [
      StepModel(
        title: 'Personal Information',
        description: 'Enter your basic details',
      ),
      StepModel(
        title: 'Contact Details',
        description: 'Provide contact information',
      ),
      StepModel(
        title: 'Complaint Details',
        description: 'Describe your complaint',
      ),
      StepModel(
        title: 'Review & Submit',
        description: 'Review and submit form',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Filling Wizard'),
        elevation: 0,
        backgroundColor: const Color(0xFF1F77D3),
      ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    steps.length,
                    (index) => Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index <= currentStep
                                  ? Color(0xFF1F77D3)
                                  : Colors.grey[300],
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: index <= currentStep
                                      ? Colors.white
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            steps[index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    steps[currentStep].title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    steps[currentStep].description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  _buildStepContent(currentStep),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => currentStep--);
                      },
                      child: const Text('Previous'),
                    ),
                  ),
                if (currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentStep < steps.length - 1) {
                        setState(() => currentStep++);
                      } else {
                        // Submit form
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form submitted!')),
                        );
                      }
                    },
                    child: Text(
                      currentStep == steps.length - 1 ? 'Submit' : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      case 2:
        return TextField(
          decoration: InputDecoration(
            labelText: 'Complaint Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: 6,
        );
      case 3:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Review Your Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _ReviewField(label: 'Name', value: 'Raj Kumar'),
              _ReviewField(label: 'Address', value: '123 Street, City'),
              _ReviewField(label: 'Phone', value: '+91-98765-43210'),
              _ReviewField(label: 'Email', value: 'raj@email.com'),
              _ReviewField(
                label: 'Complaint',
                value: 'I am facing wage theft issues...',
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

class StepModel {
  final String title;
  final String description;

  StepModel({required this.title, required this.description});
}

class _ReviewField extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(value),
        const SizedBox(height: 12),
      ],
    );
  }
}

