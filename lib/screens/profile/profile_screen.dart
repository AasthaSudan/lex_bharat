import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';
import '../help/help_screen.dart';
import '../onboarding/language_selection_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider.notifier);
    final isLoggedIn = ref.watch(authProvider) != null;
    final isDarkMode = ref.watch(themeProvider);
    final currentLanguage = ref.watch(languageProvider);
    final isSecurityLocked = ref.watch(securityLockProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero Header ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              padding: EdgeInsets.only(
                top: topPadding + 20,
                left: 24,
                right: 24,
                bottom: 36,
              ),
              child: Column(
                children: [
                  // Row: title + settings icon
                  Row(
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const LanguageSelectionScreen()),
                        ),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.settings_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Avatar
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow ring
                      Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 3,
                          ),
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          auth.initials,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    auth.displayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      isLoggedIn
                          ? auth.email
                          : 'Guest mode — tap to sign in',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats row
                  Row(
                    children: [
                      _StatPill(
                          label: 'Sessions', value: '0', icon: '💬'),
                      _StatDivider(),
                      _StatPill(
                          label: 'Forms', value: '0', icon: '📄'),
                      _StatDivider(),
                      _StatPill(
                          label: 'Topics', value: '0', icon: '📚'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Body ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Settings
                  _SectionCard(
                    title: 'App Settings',
                    tiles: [
                      _SettingTile(
                        icon: Icons.language_rounded,
                        iconColor: AppColors.accent,
                        title: 'Language',
                        subtitle: currentLanguage == 'en'
                            ? 'English'
                            : 'हिंदी',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const LanguageSelectionScreen()),
                        ),
                      ),
                      _SettingTile(
                        icon: isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        iconColor: AppColors.warning,
                        title: 'Dark Mode',
                        trailing: Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: isDarkMode,
                            activeColor: AppColors.accent,
                            onChanged: (_) => ref
                                .read(themeProvider.notifier)
                                .toggleTheme(),
                          ),
                        ),
                      ),
                      _SettingTile(
                        icon: Icons.lock_outline_rounded,
                        iconColor: AppColors.success,
                        title: 'App Lock',
                        subtitle: 'Biometric security for documents',
                        trailing: Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: isSecurityLocked,
                            activeColor: AppColors.accent,
                            onChanged: (_) => ref
                                .read(securityLockProvider.notifier)
                                .toggleSecurityLock(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Help & Resources
                  _SectionCard(
                    title: 'Help & Resources',
                    tiles: [
                      _SettingTile(
                        icon: Icons.help_outline_rounded,
                        iconColor: AppColors.categoryPurple,
                        title: 'Find Legal Help',
                        subtitle:
                            'NGOs, emergency numbers, govt schemes',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HelpScreen()),
                        ),
                      ),
                      _SettingTile(
                        icon: Icons.contact_emergency_rounded,
                        iconColor: AppColors.error,
                        title: 'Emergency Contacts',
                        onTap: () =>
                            _showEmergencyDialog(context),
                      ),
                      _SettingTile(
                        icon: Icons.info_outline_rounded,
                        iconColor: AppColors.primary,
                        title: 'About Lex Bharat',
                        onTap: () => _showAboutDialog(context),
                      ),
                      _SettingTile(
                        icon: Icons.shield_outlined,
                        iconColor: AppColors.success,
                        title: 'Privacy Policy',
                        onTap: () => _showPrivacyPolicy(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Auth button
                  if (isLoggedIn)
                    _AuthButton(
                      label: 'Sign Out',
                      icon: Icons.logout_rounded,
                      color: AppColors.error,
                      onTap: () async {
                        await ref
                            .read(authProvider.notifier)
                            .signOut();
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    )
                  else
                    _AuthButton(
                      label: 'Sign In',
                      icon: Icons.login_rounded,
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      'Lex Bharat v${AppConstants.appVersion} · Legal info only',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textHint),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: AppColors.errorLight, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Icon(Icons.emergency_rounded,
                  color: AppColors.error, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('Emergency Contacts',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.emergencyNumbers.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key,
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.errorTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(entry.value,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.error)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.gavel_rounded,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lex Bharat',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 18)),
                Text('v1.0.0',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lex Bharat is an AI-powered legal rights assistant for Indian citizens. We help ordinary people understand their legal rights in simple language.',
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.6),
              ),
              SizedBox(height: 16),
              Text('Features:',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary)),
              SizedBox(height: 8),
              Text('• AI Legal Chat — ask any legal question',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.6)),
              Text('• Learn Your Rights — categorized legal education',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.6)),
              Text('• Legal Forms — FIR, RTI, consumer complaints',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.6)),
              Text('• Voice Input & Text-to-Speech',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.6)),
              Text('• Emergency Helplines & Legal Aid',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.6)),
              SizedBox(height: 14),
              Text(
                'Disclaimer: Legal information only — not legal advice. Always consult a qualified lawyer.',
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                    fontStyle: FontStyle.italic,
                    height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.shield_outlined,
                  color: AppColors.success, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('Privacy Policy',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.textPrimary)),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Data Collection',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary)),
              SizedBox(height: 6),
              Text(
                '• Chat conversations are processed by Groq AI. We do not store your conversations on external servers unless you are signed in.\n• Voice data is processed locally on your device.\n• Form data is stored locally.',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.6),
              ),
              SizedBox(height: 14),
              Text('Data Security',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary)),
              SizedBox(height: 6),
              Text(
                '• Biometric authentication protects your documents.\n• All data is encrypted in transit.\n• We do not sell or share your personal data.',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.6),
              ),
              SizedBox(height: 14),
              Text('Your Rights',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.textPrimary)),
              SizedBox(height: 6),
              Text(
                '• You can delete all your data at any time.\n• You can use the app without an account.\n• We comply with the DPDP Act 2023.',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.6),
              ),
              SizedBox(height: 12),
              Text('Last updated: April 2026',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const _StatPill(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const _SectionCard({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: List.generate(tiles.length * 2 - 1, (index) {
              if (index.isOdd) {
                return const Divider(
                    height: 1, color: AppColors.border,
                    indent: 60, endIndent: 16);
              }
              return tiles[index ~/ 2];
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint, size: 20)
              : null),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AuthButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
