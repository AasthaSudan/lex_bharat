import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../utils/constants.dart';
import '../chat/chat_screen.dart';
import '../forms/form_list_screen.dart';
import '../learn/categories_screen.dart';
import '../resources/resources_screen.dart';
import '../tools/ipc_bns_converter_screen.dart';
import '../tools/quiz_screen.dart';
import '../tools/bail_eligibility_checker_screen.dart';
import '../tools/case_status_tracker_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _SosFab(l10n: l10n),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Modern App Bar ────────────────────────────────────────
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              Helpers.getGreeting(context),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppColors.primaryGradient.createShader(bounds),
                              child: const Text(
                                'Lex Bharat',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _IconChip(icon: Icons.notifications_none_rounded),
                      const SizedBox(width: 12),
                      _AvatarCircle(),
                    ],
                  ),
                ),
              ),
            ),
            expandedHeight: 85,
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── AI Chat Banner (Redesigned) ────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: _AiChatBanner(),
                ),

                const SizedBox(height: 20),

                // ── Emergency Alert ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _EmergencyCard(l10n: l10n),
                ),

                const SizedBox(height: 32),

                // ── Quick Actions Section ──────────────────────────────
                _SectionHeader(
                  title: l10n.quickActions,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                ),
                _QuickActionsGrid(l10n: l10n),

                const SizedBox(height: 32),

                // ── Legal Tools Section ────────────────────────────────
                _SectionHeader(
                  title: 'Legal Tools',
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                ),
                _LegalToolsRow(),

                const SizedBox(height: 32),

                // ── Daily Tip Card ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _DailyTipCard(),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── SOS Floating Action Button ─────────────────────────────────────────────

class _SosFab extends StatefulWidget {
  final AppLocalizations l10n;
  const _SosFab({required this.l10n});

  @override
  State<_SosFab> createState() => _SosFabState();
}

class _SosFabState extends State<_SosFab> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton.extended(
        onPressed: () async {
          final Uri url = Uri(scheme: 'tel', path: '112');
          if (await canLaunchUrl(url)) await launchUrl(url);
        },
        backgroundColor: AppColors.error,
        elevation: 8,
        icon: const Icon(Icons.sos_rounded, color: Colors.white, size: 24),
        label: Text(
          widget.l10n.sos,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

// ── Avatar Circle ──────────────────────────────────────────────────────────

class _AvatarCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: AppColors.ctaGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.cta.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Text(
        'U',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Icon Chip ──────────────────────────────────────────────────────────────

class _IconChip extends StatelessWidget {
  final IconData icon;
  const _IconChip({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 22, color: AppColors.textSecondary),
    );
  }
}

// ── AI Chat Banner (Modern Design) ─────────────────────────────────────────

class _AiChatBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.heroGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // AI Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.gavel_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI Legal Assistant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Instant legal guidance 24/7',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Emergency Card (Modern Design) ─────────────────────────────────────────

class _EmergencyCard extends StatefulWidget {
  final AppLocalizations l10n;
  const _EmergencyCard({required this.l10n});

  @override
  State<_EmergencyCard> createState() => _EmergencyCardState();
}

class _EmergencyCardState extends State<_EmergencyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _dot;
  late Animation<double> _dotPulse;

  @override
  void initState() {
    super.initState();
    _dot = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _dotPulse = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _dot, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _dot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEmergencyDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.error.withValues(alpha: 0.08),
              AppColors.error.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Pulsing dot
            AnimatedBuilder(
              animation: _dotPulse,
              builder: (_, __) => Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: _dotPulse.value * 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.l10n.emergencyHelp,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.error,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.l10n.emergencyHelpSubtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.error.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                'View',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
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
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actionsPadding: const EdgeInsets.all(12),
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.emergency_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.helplinesTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppConstants.emergencyNumbers.entries
                .toList()
                .asMap()
                .entries
                .map((entry) {
              final isLast = entry.key == AppConstants.emergencyNumbers.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 16 : 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entry.value.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final Uri url =
                            Uri(scheme: 'tel', path: entry.value.value);
                        if (await canLaunchUrl(url)) launchUrl(url);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorTint,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              entry.value.value,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.call_rounded,
                              color: AppColors.error,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.closeButton,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.cta,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.padding,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 5,
            height: 24,
            decoration: BoxDecoration(
              gradient: AppColors.ctaGradient,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.cta,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Quick Actions Grid ─────────────────────────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  final AppLocalizations l10n;
  const _QuickActionsGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        title: l10n.learnRights,
        subtitle: l10n.lawsExplained,
        icon: Icons.school_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategoriesScreen()),
        ),
      ),
      _QuickAction(
        title: l10n.fillForms,
        subtitle: l10n.formsExplained,
        icon: Icons.description_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormListScreen()),
        ),
      ),
      _QuickAction(
        title: 'Chat Now',
        subtitle: 'Ask AI',
        icon: Icons.chat_bubble_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        ),
      ),
      _QuickAction(
        title: l10n.resources,
        subtitle: 'Legal Info',
        icon: Icons.library_books_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ResourcesScreen()),
        ),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
      children: actions,
    );
  }
}

// ── Quick Action Card ──────────────────────────────────────────────────────

class _QuickAction extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
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
}

// ── Legal Tools Row ────────────────────────────────────────────────────────

class _LegalToolsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tools = [
      _LegalTool(
        title: 'IPC to BNS',
        icon: Icons.transform_rounded,
        color: AppColors.categoryBlue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IPCBNSConverterScreen()),
        ),
      ),
      _LegalTool(
        title: 'Quiz',
        icon: Icons.quiz_rounded,
        color: AppColors.categoryGreen,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuizScreen()),
        ),
      ),
      _LegalTool(
        title: 'Bail Check',
        icon: Icons.gavel_rounded,
        color: AppColors.categoryOrange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BailEligibilityCheckerScreen()),
        ),
      ),
      _LegalTool(
        title: 'Case Status',
        icon: Icons.assignment_turned_in_rounded,
        color: AppColors.categoryPurple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CaseStatusTrackerScreen()),
        ),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (int i = 0; i < tools.length; i++) ...[
            tools[i],
            if (i < tools.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

// ── Legal Tool Card ────────────────────────────────────────────────────────

class _LegalTool extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _LegalTool({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_LegalTool> createState() => _LegalToolState();
}

class _LegalToolState extends State<_LegalTool>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Daily Tip Card ─────────────────────────────────────────────────────────

class _DailyTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tips = [
      'Know your rights: Every citizen has the right to legal representation.',
      'Document everything: Keep records of all important legal documents.',
      'Seek legal advice early: Consult a lawyer before signing contracts.',
      'Understand local laws: Different states have different legal systems.',
      'Use ADR: Alternative Dispute Resolution can be faster and cheaper.',
    ];

    final tip = tips[DateTime.now().day % tips.length];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.accent.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Daily Tip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            tip,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
