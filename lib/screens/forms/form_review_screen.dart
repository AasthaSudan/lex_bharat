import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'form_success_screen.dart';

class FormReviewScreen extends StatelessWidget {
  final Map<String, String> formData;
  final String formTitle;

  const FormReviewScreen({
    Key? key,
    required this.formData,
    required this.formTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Form Complete!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Review your information before submitting'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            Text(
              formTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            ...formData.entries.map((entry) {
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatLabel(entry.key),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        entry.value,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            SizedBox(height: 24),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.amber.shade700),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please ensure all information is accurate.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Draft saved!')),
                      );
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save Draft'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormSuccessScreen(
                            formTitle: formTitle,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.send),
                    label: Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}