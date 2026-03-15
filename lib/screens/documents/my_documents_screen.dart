import 'package:flutter/material.dart';

class MyDocumentsScreen extends StatelessWidget {
  const MyDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = [
      {
        'title': 'Court Order - Case #12345',
        'type': 'Court Document',
        'date': '15 Mar 2026',
        'icon': Icons.gavel,
      },
      {
        'title': 'Affidavit - Property Dispute',
        'type': 'Legal Document',
        'date': '10 Mar 2026',
        'icon': Icons.description,
      },
      {
        'title': 'Police Complaint #67890',
        'type': 'Police Report',
        'date': '05 Mar 2026',
        'icon': Icons.security,
      },
      {
        'title': 'Complaint Letter to Labour Commissioner',
        'type': 'Correspondence',
        'date': '01 Mar 2026',
        'icon': Icons.mail,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
        elevation: 0,
        backgroundColor: const Color(0xFF1F77D3),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1F77D3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  doc['icon'] as IconData,
                  color: Color(0xFF1F77D3),
                ),
              ),
              title: Text(
                doc['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(doc['type'] as String),
                  const SizedBox(height: 2),
                  Text(
                    doc['date'] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(child: Text('View')),
                  const PopupMenuItem(child: Text('Share')),
                  const PopupMenuItem(child: Text('Download')),
                  const PopupMenuItem(child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
