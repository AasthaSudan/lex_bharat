import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../utils/colors.dart';
import '../../providers/app_provider.dart';
import 'form_filling_wizard_screen.dart';

class FormListScreen extends ConsumerStatefulWidget {
  const FormListScreen({super.key});

  @override
  ConsumerState<FormListScreen> createState() => _FormListScreenState();
}

class _FormListScreenState extends ConsumerState<FormListScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;

  final List<Map<String, dynamic>> _forms = const [
    {
      'id': 'fir',
      'title': 'Police Complaint (FIR)',
      'description': 'File a First Information Report securely',
      'icon': Icons.local_police_rounded,
      'color': Color(0xFFEF4444),
      'category': 'Criminal',
      'fieldsCount': 8,
      'estimatedTime': 10,
      'popular': true,
    },
    {
      'id': 'legal_aid',
      'title': 'Legal Aid Application',
      'description': 'Apply for state-sponsored free legal assistance',
      'icon': Icons.gavel_rounded,
      'color': Color(0xFF4F46E5),
      'category': 'Legal Aid',
      'fieldsCount': 6,
      'estimatedTime': 8,
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
      'description': 'File a workplace complaint for unpaid wages, etc.',
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
      'description': 'Request information from a government body',
      'icon': Icons.info_rounded,
      'color': Color(0xFF7C3AED),
      'category': 'Government',
      'fieldsCount': 5,
      'estimatedTime': 5,
      'popular': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    final isLocked = ref.read(securityLockProvider);
    if (!isLocked) {
      if (mounted) setState(() => _isAuthenticated = true);
      return;
    }

    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        if (mounted) setState(() => _isAuthenticated = true);
        return;
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access your legal documents',
      );

      if (mounted) setState(() => _isAuthenticated = didAuthenticate);
      
      if (!didAuthenticate && mounted) {
        // Option: Don't pop, just stay on lock screen.
      }
    } catch (e) {
      if (mounted) setState(() => _isAuthenticated = true);
    }
  }
  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_rounded, size: 64, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Documents Locked',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Authentication required',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _checkAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Unlock Vault', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      );
    }
    final popularForms = _forms.where((f) => f['popular'] == true).toList();
    final allForms = _forms;

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
        title: const Text(
          'Legal Forms',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.softGradient,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
                boxShadow: AppColors.softShadow,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Voice Filling', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryDark)),
                        SizedBox(height: 4),
                        Text(
                          'Fill any form completely hands-free using our AI Voice Assistant.',
                          style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            const Text(
              'Most Popular',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.5),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: popularForms.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final form = popularForms[index];
                  return SizedBox(
                    width: 260,
                    child: _PopularFormCard(
                      form: form,
                      onTap: () => _navigateToWizard(context, form),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 36),

            const Text(
              'All Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.5),
            ),
            const SizedBox(height: 16),
            ...allForms.map((form) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _FormListTile(
                    form: form,
                    onTap: () => _navigateToWizard(context, form),
                  ),
                )),

            const SizedBox(height: 32),
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(form['icon'] as IconData, color: color, size: 28),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    form['category'],
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                  ),
                )
              ],
            ),
            const Spacer(),
            Text(
              form['title'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('~${form['estimatedTime']} min', style: const TextStyle(fontSize: 13, color: AppColors.textHint, fontWeight: FontWeight.w500)),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(form['icon'] as IconData, color: color, size: 28),
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
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.3),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                        child: Text(
                          form['category'],
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    form['description'],
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text('~${form['estimatedTime']} min', style: const TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 16),
                      Icon(Icons.list_alt_rounded, size: 14, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text('${form['fieldsCount']} fields', style: const TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
