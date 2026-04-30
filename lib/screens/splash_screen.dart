import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/colors.dart';
import '../providers/app_provider.dart';
import '../main.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotate;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _logoFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotate = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _pulse = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _logoController.forward().then((_) => _textController.forward());
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final isFirstTime = await ref.read(firstTimeProvider.future);

    Widget destination;
    if (isFirstTime) {
      destination = const HomeNavigation();
    } else {
      try {
        final _ = FirebaseAuth.instance.currentUser;
        destination = const HomeNavigation();
      } catch (_) {
        destination = const HomeNavigation();
      }
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Animated Logo ───────────────────────────────────────
                FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: ScaleTransition(
                      scale: _pulse,
                      child: Transform.rotate(
                        angle: _logoRotate.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow ring
                            AnimatedBuilder(
                              animation: _pulse,
                              builder: (context, _) => Container(
                                width: 130 * _pulse.value,
                                height: 130 * _pulse.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.accent.withValues(alpha: 0.2),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Logo container
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                gradient: AppColors.ctaGradient,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.cta.withValues(alpha: 0.4),
                                    blurRadius: 32,
                                    offset: const Offset(0, 12),
                                  ),
                                  BoxShadow(
                                    color: AppColors.cta.withValues(alpha: 0.2),
                                    blurRadius: 60,
                                    offset: const Offset(0, 24),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.gavel_rounded,
                                size: 52,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // ── App Name & Tagline ──────────────────────────────────
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Column(
                      children: [
                        const Text(
                          'Lex Bharat',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Legal Rights, Your Language',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.85),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // ── Loading Indicator ────────────────────────────────────
                FadeTransition(
                  opacity: _textFade,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.6),
                          ),
                          strokeWidth: 2.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Connecting...',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
