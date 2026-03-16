import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class FormSuccessScreen extends StatelessWidget {
  final String formTitle;

  const FormSuccessScreen({Key? key, required this.formTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 100,
              ),
              SizedBox(height: 32),
              Text(
                'Form Submitted Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your $formTitle has been submitted.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text('Back to Home'),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Download - Coming soon')),
                    );
                  },
                  icon: Icon(Icons.download),
                  label: Text('Download PDF'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}