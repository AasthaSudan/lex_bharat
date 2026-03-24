import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'topic_details_screen.dart';

class TopicsListScreen extends StatelessWidget {
  final Map<String, dynamic> category;

  const TopicsListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final title = category['title'] as String;
    final color = category['color'] as Color;
    final topics = category['topics'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: AppColors.textPrimary,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.textPrimary, letterSpacing: -0.5)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: topics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final topic = topics[index] as Map<String, dynamic>;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicDetailsScreen(
                    topic: topic,
                    categoryColor: color,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.article_rounded, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      topic['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary, letterSpacing: -0.2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color.withValues(alpha: 0.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
