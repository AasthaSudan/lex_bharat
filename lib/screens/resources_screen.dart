import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
  final List<LegalResource> resources = [
    LegalResource(
      name: 'National Legal Services Authority',
      type: 'Legal Aid Organization',
      phone: '1800-11-4001',
      address: 'Sector 12, Dwarka, New Delhi',
      distance: 2.5,
    ),
    LegalResource(
      name: 'District Legal Services Authority',
      type: 'Government Office',
      phone: '011-2345-6789',
      address: 'Court Complex, Delhi',
      distance: 5.2,
    ),
    LegalResource(
      name: 'Women Legal Aid Center',
      type: 'NGO',
      phone: '1800-22-5757',
      address: 'Karol Bagh, New Delhi',
      distance: 3.8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Legal Help'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.business, color: Colors.blue),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resource.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              resource.type,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.location_on, color: Colors.green, size: 20),
                          Text('${resource.distance} km'),
                        ],
                      ),
                    ],
                  ),

                  Divider(height: 24),

                  Row(
                    children: [
                      Icon(Icons.phone, size: 18, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(resource.phone),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(child: Text(resource.address)),
                    ],
                  ),

                  SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.call, size: 18),
                          label: Text('Call'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Calling ${resource.phone}')),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.directions, size: 18),
                          label: Text('Directions'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Opening maps...')),
                            );
                          },
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
    );
  }
}

class LegalResource {
  final String name;
  final String type;
  final String phone;
  final String address;
  final double distance;

  LegalResource({
    required this.name,
    required this.type,
    required this.phone,
    required this.address,
    required this.distance,
  });
}