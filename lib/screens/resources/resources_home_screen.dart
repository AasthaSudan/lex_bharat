import 'package:flutter/material.dart';

class ResourcesHomeScreen extends StatefulWidget {
  const ResourcesHomeScreen({super.key});

  @override
  State<ResourcesHomeScreen> createState() => _ResourcesHomeScreenState();
}

class _ResourcesHomeScreenState extends State<ResourcesHomeScreen> {
  final List<String> resourceTypes = [
    'All',
    'Legal Aid',
    'Government',
    'NGO',
    'Helpline',
  ];
  int selectedType = 0;

  @override
  Widget build(BuildContext context) {
    final resources = [
      {
        'title': 'National Legal Services Authority',
        'type': 'Legal Aid',
        'phone': '+91-11-2xxx-xxxx',
        'address': 'New Delhi',
        'isFree': true,
        'icon': Icons.gavel,
      },
      {
        'title': 'Women\'s Helpline',
        'type': 'Helpline',
        'phone': '+91-18002331497',
        'address': 'All India',
        'isFree': true,
        'icon': Icons.female,
      },
      {
        'title': 'Consumer Commission',
        'type': 'Government',
        'phone': '+91-11-xxxx-xxxx',
        'address': 'New Delhi',
        'isFree': true,
        'icon': Icons.shopping_bag,
      },
      {
        'title': 'Labour Commissioner Office',
        'type': 'Government',
        'phone': '+91-11-yyyy-yyyy',
        'address': 'New Delhi',
        'isFree': true,
        'icon': Icons.work,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Resources'),
        elevation: 0,
        backgroundColor: const Color(0xFF1F77D3),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: resourceTypes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(resourceTypes[index]),
                    selected: selectedType == index,
                    onSelected: (value) {
                      setState(() => selectedType = index);
                    },
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final resource = resources[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF1F77D3).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                resource['icon'] as IconData,
                                color: Color(0xFF1F77D3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    resource['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    resource['type'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (resource['isFree'] as bool)
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF2ECC71).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: const Text(
                                  'FREE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF2ECC71),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                resource['phone'] as String,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                resource['address'] as String,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text('Call'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Details'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

