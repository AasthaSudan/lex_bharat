import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';
import '../onboarding/language_selection_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final isDarkMode = ref.watch(themeProvider);
    final currentLanguage = ref.watch(languageProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: topPadding + 20, left: 24, right: 24, bottom: 60),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user?.userMetadata?['name']?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.userMetadata?['name'] ?? 'Guest User',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      user?.email ?? 'Please sign in to sync data',
                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildSection(
                      title: 'App Settings',
                      children: [
                        _buildListTile(
                          icon: Icons.language_rounded,
                          iconColor: AppColors.info,
                          title: 'Language',
                          subtitle: currentLanguage == 'en' ? 'English' : 'हिंदी',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()));
                          },
                        ),
                        _buildDivider(),
                        _buildListTile(
                          icon: isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          iconColor: AppColors.warning,
                          title: 'Dark Mode',
                          trailing: Switch(
                            value: isDarkMode,
                            activeColor: AppColors.primary,
                            onChanged: (value) => ref.read(themeProvider.notifier).toggleTheme(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _buildSection(
                      title: 'Help & Support',
                      children: [
                        _buildListTile(
                          icon: Icons.contact_emergency_rounded,
                          iconColor: AppColors.error,
                          title: 'Emergency Contacts',
                          onTap: () => _showEmergencyDialog(context),
                        ),
                        _buildDivider(),
                        _buildListTile(
                          icon: Icons.info_outline_rounded,
                          iconColor: AppColors.primary,
                          title: 'About Lex Bharat',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildListTile(
                          icon: Icons.shield_outlined,
                          iconColor: AppColors.success,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await ref.read(authProvider.notifier).signOut();
                        },
                        icon: const Icon(Icons.logout_rounded, color: Colors.white),
                        label: const Text('Sign Out', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 16),
      child: Divider(color: AppColors.gray200, height: 1, thickness: 1),
    );
  }

  Widget _buildListTile({required IconData icon, required Color iconColor, required String title, String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary, letterSpacing: -0.2)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.gray400),
      onTap: onTap,
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.errorLight, shape: BoxShape.circle),
              child: const Icon(Icons.emergency_rounded, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Text('Emergency Contacts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEmergencyContact('National Emergency', '112'),
            _buildEmergencyContact('Police', '100'),
            _buildEmergencyContact('Domestic Abuse', '1091'),
            _buildEmergencyContact('Women Helpline', '181'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact(String title, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLighter,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(number, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(width: 8),
                const Icon(Icons.phone_rounded, color: AppColors.primary, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
