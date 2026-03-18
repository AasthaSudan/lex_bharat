import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'form_filling_wizard_screen.dart';

class FormListScreen extends StatelessWidget {
  const FormListScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _forms = const [
    {
      'id': 'fir',
      'title': 'Police Complaint (FIR)',
      'description': 'File a First Information Report',
      'icon': Icons.local_police_rounded,
      'color': Color(0xFFEF4444),
      'category': 'Criminal',
      'fieldsCount': 8,
      'estimatedTime': 15,
      'popular': true,
    },
    {
      'id': 'legal_aid',
      'title': 'Legal Aid Application',
      'description': 'Apply for free legal assistance',
      'icon': Icons.gavel_rounded,
      'color': Color(0xFF3B82F6),
      'category': 'Legal Aid',
      'fieldsCount': 6,
      'estimatedTime': 10,
      'popular': true,
    },
    {
      'id': 'consumer',
      'title': 'Consumer Complaint',
      'description': 'Report defective products or poor service',
      'icon': Icons.shopping_bag_rounded,
      'color': Color(0xFFF59E0B),
      'category': 'Consumer',
      'fieldsCount': 7,
      'estimatedTime': 12,
      'popular': false,
    },
    {
      'id': 'labor',
      'title': 'Labor Grievance',
      'description': 'File a workplace complaint',
      'icon': Icons.work_rounded,
      'color': Color(0xFF10B981),
      'category': 'Labor',
      'fieldsCount': 9,
      'estimatedTime': 15,
      'popular': false,
    },
    {
      'id': 'rti',
      'title': 'RTI Application',
      'description': 'Request information from government',
      'icon': Icons.info_rounded,
      'color': Color(0xFF8B5CF6),
      'category': 'Government',
      'fieldsCount': 5,
      'estimatedTime': 8,
      'popular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final popularForms = _forms.where((f) => f['popular'] == true).toList();
    final allForms = _forms;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: AppColors.textPrimary,
        ),
        title: const Text(
          'Legal Forms',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.mic_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Fill any form using your voice — just tap the mic button.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Popular forms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: popularForms.map((form) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: popularForms.last == form ? 0 : 12,
                    ),
                    child: _PopularFormCard(
                      form: form,
                      onTap: () => _navigateToWizard(context, form),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            const Text(
              'All forms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            ...allForms.map((form) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FormListTile(
                form: form,
                onTap: () => _navigateToWizard(context, form),
              ),
            )),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _navigateToWizard(BuildContext context, Map<String, dynamic> form) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormFillingWizardScreen(
          formTitle: form['title'],
        ),
      ),
    );
  }
}

class _PopularFormCard extends StatelessWidget {
  final Map<String, dynamic> form;
  final VoidCallback onTap;

  const _PopularFormCard({required this.form, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color color = form['color'] as Color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(form['icon'] as IconData, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              form['title'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(
                  '~${form['estimatedTime']} min',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FormListTile extends StatelessWidget {
  final Map<String, dynamic> form;
  final VoidCallback onTap;

  const _FormListTile({required this.form, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color color = form['color'] as Color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(form['icon'] as IconData, color: color, size: 24),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          form['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          form['category'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    form['description'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 13, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        '~${form['estimatedTime']} min',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textHint),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.list_alt_rounded,
                          size: 13, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        '${form['fieldsCount']} fields',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textHint),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}