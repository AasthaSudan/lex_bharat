import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'profile_setup_screen.dart';

class PermissionsScreen extends StatefulWidget {
  @override
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  Map<String, bool> permissions = {
    'microphone': false,
    'location': false,
    'storage': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permissions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We Need Your Permission',
                style: TextStyle(
                  fontSize: AppConstants.fontTitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'To provide you with the best experience',
                style: TextStyle(
                  fontSize: AppConstants.fontNormal,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 40),

              Expanded(
                child: ListView(
                  children: [
                    _buildPermissionCard(
                      icon: Icons.mic,
                      title: 'Microphone',
                      description: 'To enable voice commands and questions',
                      permission: 'microphone',
                    ),
                    SizedBox(height: 16),
                    _buildPermissionCard(
                      icon: Icons.location_on,
                      title: 'Location',
                      description: 'To find legal aid resources near you',
                      permission: 'location',
                    ),
                    SizedBox(height: 16),
                    _buildPermissionCard(
                      icon: Icons.folder,
                      title: 'Storage',
                      description: 'To save documents and forms',
                      permission: 'storage',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileSetupScreen(),
                          ),
                        );
                      },
                      child: Text('Skip for Now'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _allPermissionsGranted
                          ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileSetupScreen(),
                          ),
                        );
                      }
                          : null,
                      child: Text('Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required String permission,
  }) {
    final isGranted = permissions[permission] ?? false;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isGranted
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isGranted ? AppColors.success : AppColors.primary,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  permissions[permission] = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isGranted ? AppColors.success : AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(isGranted ? 'Granted' : 'Allow'),
            ),
          ],
        ),
      ),
    );
  }

  bool get _allPermissionsGranted {
    return permissions.values.every((granted) => granted);
  }
}