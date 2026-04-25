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

  static const List<Map<String, dynamic>> _forms = [
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
      'description': 'Report defective products or poor service quality',
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
      'description': 'File a workplace complaint for unpaid wages etc.',
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
      'description': 'Request information from any government body',
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  Future<void> _checkAuth() async {
    final isLocked = ref.read(securityLockProvider);
    if (!isLocked) {
      if (mounted) setState(() => _isAuthenticated = true);
      return;
    }
    try {
      final canAuth = await _auth.canCheckBiometrics ||
          await _auth.isDeviceSupported();
      if (!canAuth) {
        if (mounted) setState(() => _isAuthenticated = true);
        return;
      }
      final ok = await _auth.authenticate(
        localizedReason:
            'Please authenticate to access your legal documents',
      );
      if (mounted) setState(() => _isAuthenticated = ok);
    } catch (_) {
      if (mounted) setState(() => _isAuthenticated = true);
    }
  }

  void _navigateToWizard(Map<String, dynamic> form) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormFillingWizardScreen(formTitle: form['title']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLighter,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.lock_rounded,
                      size: 40, color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Documents Locked',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Authenticate with biometrics to access your legal forms.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _checkAuth,
                    icon: const Icon(Icons.fingerprint_rounded, size: 22),
                    label: const Text('Unlock with Biometrics'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final popularForms = _forms.where((f) => f['popular'] == true).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 110,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Legal Forms',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              background: Container(color: AppColors.background),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Voice Banner ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppColors.elevatedShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.mic_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voice-Assisted Filling',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Fill any form hands-free with AI voice guidance.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Most Popular ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Most Popular',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: popularForms.length,
                    itemBuilder: (context, index) {
                      final form = popularForms[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: SizedBox(
                          width: 240,
                          child: _PopularFormCard(
                            form: form,
                            onTap: () => _navigateToWizard(form),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ── All Forms ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'All Forms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: _forms.length,
                  itemBuilder: (context, index) {
                    final form = _forms[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _FormListTile(
                        form: form,
                        onTap: () => _navigateToWizard(form),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularFormCard extends StatefulWidget {
  final Map<String, dynamic> form;
  final VoidCallback onTap;
  const _PopularFormCard({required this.form, required this.onTap});

  @override
  State<_PopularFormCard> createState() => _PopularFormCardState();
}

class _PopularFormCardState extends State<_PopularFormCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.form['color'] as Color;
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(widget.form['icon'] as IconData,
                        color: color, size: 22),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      widget.form['category'],
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.form['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 13, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(
                    '~${widget.form['estimatedTime']} min',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w500),
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

class _FormListTile extends StatefulWidget {
  final Map<String, dynamic> form;
  final VoidCallback onTap;
  const _FormListTile({required this.form, required this.onTap});

  @override
  State<_FormListTile> createState() => _FormListTileState();
}

class _FormListTileState extends State<_FormListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.form['color'] as Color;
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
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            children: [
              // Left accent line
              Container(
                width: 4,
                height: 52,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(widget.form['icon'] as IconData,
                    color: color, size: 22),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.form['title'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            widget.form['category'],
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.form['description'],
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Text('~${widget.form['estimatedTime']} min',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textHint)),
                        const SizedBox(width: 12),
                        const Icon(Icons.list_alt_rounded,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Text('${widget.form['fieldsCount']} fields',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textHint)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
