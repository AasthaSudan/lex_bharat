import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../chat/chat_screen.dart';
import '../forms/form_list_screen.dart';
import '../learn/categories_screen.dart';
import '../../utils/constants.dart';
import '../resources/resources_screen.dart';
import '../tools/ipc_bns_converter_screen.dart';
import '../tools/quiz_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
        label: const Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        Helpers.getGreeting(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('👋', style: TextStyle(fontSize: 28)),
                    ],
                  ),
                  const Icon(Icons.notifications_none_rounded, size: 30, color: AppColors.textPrimary),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'How can I help you today?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),

              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDim,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.gray400,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Ask a legal question...',
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => _showEmergencyDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Emergency Help',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Helplines • Police • Women',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.5), size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              
              const Text(
                'Quick actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 16),
              
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildQuickActionCard(
                    context,
                    title: 'Learn\nRights',
                    subtitle: 'Laws explained simply',
                    icon: Icons.school_rounded,
                    iconColor: AppColors.accent,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen())),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'AI\nAssistant',
                    subtitle: 'Ask any legal question',
                    icon: Icons.chat_bubble_rounded,
                    iconColor: AppColors.info,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'IPC↔BNS\nConverter',
                    subtitle: 'New law section finder',
                    icon: Icons.compare_arrows_rounded,
                    iconColor: AppColors.error,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IPCBNSConverterScreen())),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Rights\nQuiz',
                    subtitle: 'Test your knowledge',
                    icon: Icons.quiz_rounded,
                    iconColor: Colors.amber.shade700,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Fill\nForms',
                    subtitle: 'FIR, RTI, Legal Aid',
                    icon: Icons.description_rounded,
                    iconColor: AppColors.warning,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormListScreen())),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Find\nHelp',
                    subtitle: 'Legal aid near you',
                    icon: Icons.location_on_rounded,
                    iconColor: AppColors.success,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 32),
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
            const Text('Helplines', style: TextStyle(fontWeight: FontWeight.bold)),
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
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
