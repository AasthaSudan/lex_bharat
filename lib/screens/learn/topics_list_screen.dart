import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index] as Map<String, dynamic>;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                topic['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
            ),
          );
        },
      ),
    );
  }
}
