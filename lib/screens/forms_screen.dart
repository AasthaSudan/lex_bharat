import 'package:flutter/material.dart';

class FormsScreen extends StatelessWidget {
  final List<LegalForm> forms = [
    LegalForm(
      title: 'Police Complaint (FIR)',
      icon: Icons.local_police,
      color: Colors.red,
      description: 'File a First Information Report',
    ),
    LegalForm(
      title: 'Legal Aid Application',
      icon: Icons.gavel,
      color: Colors.blue,
      description: 'Apply for free legal assistance',
    ),
    LegalForm(
      title: 'Consumer Complaint',
      icon: Icons.shopping_bag,
      color: Colors.orange,
      description: 'Report product or service issues',
    ),
    LegalForm(
      title: 'Labor Grievance',
      icon: Icons.work,
      color: Colors.green,
      description: 'File workplace complaint',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fill Forms'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: forms.length,
        itemBuilder: (context, index) {
          final form = forms[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: form.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(form.icon, color: form.color, size: 28),
              ),
              title: Text(
                form.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(form.description),
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Form wizard - Coming soon!')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class LegalForm {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  LegalForm({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}