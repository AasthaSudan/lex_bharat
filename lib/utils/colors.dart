import 'package:flutter/material.dart';

class AppColors {
  // ── Primary Palette ─────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF1E3A5F);  // Deep navy blue
  static const Color primaryDark    = Color(0xFF0F2241);  // Darker navy
  static const Color primaryLight   = Color(0xFF2D5F94);  // Lighter navy
  static const Color primaryLighter = Color(0xFFEBF4FF);  // Very light blue tint

  // ── Accent ──────────────────────────────────────────────────────────────
  static const Color accent         = Color(0xFF3B82F6);  // Electric blue
  static const Color accentDark     = Color(0xFF2563EB);  // Darker electric blue
  static const Color accentLight    = Color(0xFFDBEAFE);  // Light blue tint

  // ── Amber / Gold (CTA + Highlight) ──────────────────────────────────────
  static const Color gold           = Color(0xFFF59E0B);  // Amber gold
  static const Color goldLight      = Color(0xFFFEF3C7);  // Light amber

  // ── Backgrounds ─────────────────────────────────────────────────────────
  static const Color background     = Color(0xFFF8FAFC);  // Off-white
  static const Color surface        = Color(0xFFFFFFFF);  // White
  static const Color surfaceDim     = Color(0xFFF1F5F9);  // Muted surface
  static const Color surfaceCard    = Color(0xFFFFFFFF);  // Card white

  // ── Text ────────────────────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF0F172A);  // Near-black
  static const Color textSecondary  = Color(0xFF475569);  // Slate gray
  static const Color textHint       = Color(0xFF94A3B8);  // Light slate
  static const Color textOnDark     = Color(0xFFFFFFFF);  // White text

  // ── Borders ─────────────────────────────────────────────────────────────
  static const Color border         = Color(0xFFE2E8F0);  // Soft border
  static const Color borderMid      = Color(0xFFCBD5E1);  // Medium border

  // ── Semantic ────────────────────────────────────────────────────────────
  static const Color success        = Color(0xFF10B981);  // Emerald green
  static const Color successLight   = Color(0xFFD1FAE5);  // Light green
  static const Color successTint    = Color(0xFFECFDF5);

  static const Color warning        = Color(0xFFF59E0B);  // Amber
  static const Color warningLight   = Color(0xFFFEF3C7);  // Light amber
  static const Color warningTint    = Color(0xFFFFFBEB);

  static const Color error          = Color(0xFFEF4444);  // Red
  static const Color errorLight     = Color(0xFFFEE2E2);  // Light red
  static const Color errorTint      = Color(0xFFFFF1F2);

  static const Color info           = Color(0xFF3B82F6);  // Blue
  static const Color infoLight      = Color(0xFFDBEAFE);  // Light blue
  static const Color infoTint       = Color(0xFFEFF6FF);

  // ── Category Colors ──────────────────────────────────────────────────────
  static const Color categoryBlue   = Color(0xFF3B82F6);
  static const Color categoryGreen  = Color(0xFF10B981);
  static const Color categoryOrange = Color(0xFFF59E0B);
  static const Color categoryPink   = Color(0xFFEC4899);
  static const Color categoryPurple = Color(0xFF8B5CF6);
  static const Color categoryRed    = Color(0xFFEF4444);
  static const Color categoryTeal   = Color(0xFF14B8A6);
  static const Color categoryIndigo = Color(0xFF6366F1);

  // ── Grays ────────────────────────────────────────────────────────────────
  static const Color gray50   = Color(0xFFF8FAFC);
  static const Color gray100  = Color(0xFFF1F5F9);
  static const Color gray200  = Color(0xFFE2E8F0);
  static const Color gray300  = Color(0xFFCBD5E1);
  static const Color gray400  = Color(0xFF94A3B8);
  static const Color gray500  = Color(0xFF64748B);
  static const Color gray600  = Color(0xFF475569);
  static const Color gray700  = Color(0xFF334155);
  static const Color gray800  = Color(0xFF1E293B);
  static const Color gray900  = Color(0xFF0F172A);

  // ── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E3A5F), Color(0xFF2D5F94)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E3A5F), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlassGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Shadows ──────────────────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF1E3A5F).withValues(alpha: 0.08),
      blurRadius: 16,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: const Color(0xFF1E3A5F).withValues(alpha: 0.15),
      blurRadius: 32,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get accentShadow => [
    BoxShadow(
      color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get errorShadow => [
    BoxShadow(
      color: const Color(0xFFEF4444).withValues(alpha: 0.35),
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get goldShadow => [
    BoxShadow(
      color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
      blurRadius: 16,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];
}