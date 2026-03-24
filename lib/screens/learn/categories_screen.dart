import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/sample_data.dart';
import 'topics_list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = SampleData.getLegalCategories();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Learn Your Rights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: -0.5)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final color = category['color'] as Color;
          final topicsCount = (category['topics'] as List).length;

          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TopicsListScreen(category: category)));
            },
            child: Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(category['icon'] as IconData, color: color, size: 28),
                  ),
                  const Spacer(),
                  Text(
                    category['title'] as String,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 14, color: color),
                      const SizedBox(width: 6),
                      Text(
                        '$topicsCount topics',
                        style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
