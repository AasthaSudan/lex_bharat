import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../utils/spacing.dart';
import '../../utils/typography.dart';
import '../chat/chat_screen.dart';
import '../forms/form_list_screen.dart';
import '../learn/categories_screen.dart';
import '../../utils/constants.dart';
import '../resources/resources_screen.dart';
import '../tools/ipc_bns_converter_screen.dart';
import '../tools/quiz_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/feature_card.dart';
import '../../widgets/highlight_banner.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final Uri url = Uri(scheme: 'tel', path: '112');
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
        backgroundColor: AppColors.error,
        icon: const Icon(Icons.sos_rounded, color: Colors.white),
        label: Text(AppLocalizations.of(context)!.sos, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Greeting
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.screenPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Helpers.getGreeting(context)} 👋',
                          style: AppTypography.displaySmall,
                        ),
                        const SizedBox(height: AppSpacing.xs6),
                        Text(
                          AppLocalizations.of(context)!.howCanIHelpText,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDim,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.componentSpacing),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    ),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDim,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            AppLocalizations.of(context)!.askLegalQuestion,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Emergency Banner
              HighlightBanner(
                title: AppLocalizations.of(context)!.emergencyHelp,
                subtitle: AppLocalizations.of(context)!.emergencyHelpSubtitle,
                icon: Icons.emergency_rounded,
                backgroundColor: AppColors.error,
                textColor: Colors.white,
                actionLabel: 'Call Now',
                actionColor: Colors.white,
                onAction: () async {
                  final Uri url = Uri(scheme: 'tel', path: '112');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Quick Actions Section Header
              SectionHeader(
                title: AppLocalizations.of(context)!.quickActions,
                subtitle: 'Access key features',
              ),

              // Quick Actions Grid
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.componentSpacing,
                  crossAxisSpacing: AppSpacing.componentSpacing,
                  childAspectRatio: 0.95,
                  children: [
                    FeatureCard(
                      title: AppLocalizations.of(context)!.learnRights,
                      subtitle: AppLocalizations.of(context)!.lawsExplained,
                      icon: Icons.school_rounded,
                      iconColor: AppColors.accent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                      ),
                    ),
                    FeatureCard(
                      title: AppLocalizations.of(context)!.aiAssistant,
                      subtitle: AppLocalizations.of(context)!.askAnyLegalQuestion,
                      icon: Icons.chat_bubble_rounded,
                      iconColor: AppColors.info,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChatScreen()),
                      ),
                    ),
                    FeatureCard(
                      title: AppLocalizations.of(context)!.ipcBnsConverter,
                      subtitle: AppLocalizations.of(context)!.newLawSectionFinder,
                      icon: Icons.compare_arrows_rounded,
                      iconColor: AppColors.error,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const IPCBNSConverterScreen()),
                      ),
                    ),
                    FeatureCard(
                      title: AppLocalizations.of(context)!.rightsQuiz,
                      subtitle: AppLocalizations.of(context)!.testYourKnowledge,
                      icon: Icons.quiz_rounded,
                      iconColor: Colors.amber.shade700,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen()),
                      ),
                    ),
                    FeatureCard(
                      title: AppLocalizations.of(context)!.fillForms,
                      subtitle: AppLocalizations.of(context)!.firRtiLegalAid,
                      icon: Icons.description_rounded,
                      iconColor: AppColors.warning,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FormListScreen()),
                      ),
                    ),
                    FeatureCard(
                      title: AppLocalizations.of(context)!.findHelp,
                      subtitle: AppLocalizations.of(context)!.legalAidNearYou,
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.success,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResourcesScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: iconColor.withValues(alpha: 0.15), width: 1.5),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.errorLight, shape: BoxShape.circle),
              child: const Icon(Icons.emergency_rounded, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.helplinesTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.emergencyNumbers.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                  Container(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     decoration: BoxDecoration(
                       color: AppColors.surfaceDim,
                       borderRadius: BorderRadius.circular(100),
                     ),
                     child: Text(
                       entry.value,
                       style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                     ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeButton, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
