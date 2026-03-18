import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Labor Rights', 'icon': Icons.work, 'color': Color(0xFF3498DB)},
      {'title': 'Property Rights', 'icon': Icons.home, 'color': Color(0xFF2ECC71)},
      {'title': "Women's Rights", 'icon': Icons.female, 'color': Color(0xFFE91E63)},
      {'title': 'Consumer Rights', 'icon': Icons.shopping_bag, 'color': Color(0xFFFFA500)},
      {'title': 'Child Rights', 'icon': Icons.child_care, 'color': Color(0xFF9C27B0)},
      {'title': 'Disability Rights', 'icon': Icons.accessibility, 'color': Color(0xFF00BCD4)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Your Rights'),
        elevation: 0,
        backgroundColor: const Color(0xFF1F77D3),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TopicsListScreen()),
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
                    colors: [(category['color'] as Color).withOpacity(0.1), Colors.white],
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      category['icon'] as IconData,
                      color: category['color'] as Color,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    category['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text('${5 + index} topics'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TopicsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topics')),
      body: const Center(child: Text('Topics List')),
    );
  }
}

