import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  final List<LegalCategory> categories = [
    LegalCategory(
      title: 'Labor Rights',
      icon: Icons.work,
      color: Colors.blue,
      topicsCount: 15,
      topics: [
        'Minimum Wage',
        'Overtime Pay',
        'Working Hours',
        'Wrongful Termination',
        'Workplace Safety',
      ],
    ),
    LegalCategory(
      title: 'Property Rights',
      icon: Icons.home,
      color: Colors.green,
      topicsCount: 12,
      topics: [
        'Rent Agreements',
        'Eviction Rules',
        'Property Disputes',
        'Land Rights',
      ],
    ),
    LegalCategory(
      title: 'Women\'s Rights',
      icon: Icons.female,
      color: Colors.pink,
      topicsCount: 18,
      topics: [
        'Domestic Violence Act',
        'Workplace Harassment',
        'Dowry Laws',
        'Maternity Benefits',
      ],
    ),
    LegalCategory(
      title: 'Consumer Rights',
      icon: Icons.shopping_cart,
      color: Colors.orange,
      topicsCount: 10,
      topics: [
        'Product Defects',
        'Refund Rights',
        'Service Quality',
        'Consumer Forum',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Your Rights'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(category.icon, color: category.color, size: 28),
              ),
              title: Text(
                category.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text('${category.topicsCount} topics'),
              children: category.topics.map((topic) {
                return ListTile(
                  leading: Icon(Icons.article, color: Colors.grey),
                  title: Text(topic),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopicDetailScreen(topic: topic),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class LegalCategory {
  final String title;
  final IconData icon;
  final Color color;
  final int topicsCount;
  final List<String> topics;

  LegalCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.topicsCount,
    required this.topics,
  });
}

class TopicDetailScreen extends StatelessWidget {
  final String topic;

  const TopicDetailScreen({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.school, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '5 min read',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'What is $topic?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. This is demo content about $topic.',
              style: TextStyle(fontSize: 15, height: 1.6),
            ),

            SizedBox(height: 24),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This is important information about $topic',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Your Rights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildBulletPoint('Right to information'),
            _buildBulletPoint('Right to fair treatment'),
            _buildBulletPoint('Right to legal representation'),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Quiz - Coming soon!')),
                  );
                },
                child: Text('Take Quiz'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 20)),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}