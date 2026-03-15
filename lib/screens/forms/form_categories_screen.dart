import 'package:flutter/material.dart';

class FormCategoriesScreen extends StatelessWidget {
  const FormCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formCategories = [
      {
        'title': 'Legal Notice',
        'description': 'Send formal legal notice',
        'icon': Icons.description,
        'color': Color(0xFF3498DB),
      },
      {
        'title': 'Complaint Letter',
        'description': 'File formal complaint',
        'icon': Icons.mail,
        'color': Color(0xFF2ECC71),
      },
      {
        'title': 'Affidavit',
        'description': 'Create sworn statement',
        'icon': Icons.verified,
        'color': Color(0xFFE91E63),
      },
      {
        'title': 'Application',
        'description': 'Submit government application',
        'icon': Icons.assignment,
        'color': Color(0xFFFFA500),
      },
      {
        'title': 'Power of Attorney',
        'description': 'Authorize representative',
        'icon': Icons.gavel,
        'color': Color(0xFF9C27B0),
      },
      {
        'title': 'Agreement',
        'description': 'Create legal agreement',
        'icon': Icons.handshake,
        'color': Color(0xFF00BCD4),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Assistant'),
        elevation: 0,
        backgroundColor: const Color(0xFF1F77D3),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: formCategories.length,
        itemBuilder: (context, index) {
          final form = formCategories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormDetailsScreen()),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      (form['color'] as Color).withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: (form['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        form['icon'] as IconData,
                        color: form['color'] as Color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            form['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            form['description'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FormDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Details')),
      body: const Center(child: Text('Form Details')),
    );
  }
}

