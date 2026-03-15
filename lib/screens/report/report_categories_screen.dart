import 'package:flutter/material.dart';

class ReportCategoriesScreen extends StatelessWidget {
  const ReportCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportTypes = [
      {
        'title': 'Harassment',
        'description': 'Report harassment or abuse',
        'icon': Icons.warning,
        'color': Color(0xFFE74C3C),
      },
      {
        'title': 'Labor Violation',
        'description': 'Report wage theft or unsafe conditions',
        'icon': Icons.work,
        'color': Color(0xFFF39C12),
      },
      {
        'title': 'Property Dispute',
        'description': 'Report property-related issues',
        'icon': Icons.home,
        'color': Color(0xFF95A5A6),
      },
      {
        'title': 'Domestic Violence',
        'description': 'Report domestic violence',
        'icon': Icons.security,
        'color': Color(0xFFC0392B),
      },
      {
        'title': 'Consumer Fraud',
        'description': 'Report fraud or defective products',
        'icon': Icons.shopping_cart,
        'color': Color(0xFFE67E22),
      },
      {
        'title': 'Discrimination',
        'description': 'Report discrimination',
        'icon': Icons.diversity_1,
        'color': Color(0xFF34495E),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('File a Complaint'),
        elevation: 0,
        backgroundColor: const Color(0xFF1F77D3),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reportTypes.length,
        itemBuilder: (context, index) {
          final report = reportTypes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailsScreen(),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      (report['color'] as Color).withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: (report['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        report['icon'] as IconData,
                        color: report['color'] as Color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report['title'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            report['description'] as String,
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

class ReportDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Details')),
      body: const Center(child: Text('Report Details')),
    );
  }
}
