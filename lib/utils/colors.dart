import 'package:flutter/material.dart';

class AppColors {
  static const Color primary     = Color(0xFF1A1A2E);
  static const Color accent      = Color(0xFF7B5CF8);
  static const Color accentLight = Color(0xFFE8E4FF);

  static const Color background  = Color(0xFFFAFAF8);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color surfaceDim  = Color(0xFFF0EFE9);

  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF5A5A6E);
  static const Color textHint      = Color(0xFF9B9B9B);

  // ── Borders ───────────────────────────────────────────────
  static const Color border     = Color(0xFFF0EFE9);
  static const Color borderMid  = Color(0xFFE2E0DA);

  // ── Status ───────────────────────────────────────────────
  static const Color success     = Color(0xFF3BF87B);
  static const Color successTint = Color(0xFFE8FFE8);
  static const Color warning     = Color(0xFFF89B3B);
  static const Color warningTint = Color(0xFFFFF4E8);
  static const Color error       = Color(0xFFFF4D4D);
  static const Color errorTint   = Color(0xFFFFECEC);
  static const Color info        = Color(0xFF3B9EF8);
  static const Color infoTint    = Color(0xFFE8F4FF);
  static const Color infoLight   = Color(0xFFE8F4FF);

  // ── Category icon tints ───────────────────────────────────
  static const Color categoryBlue   = Color(0xFF3B9EF8);
  static const Color categoryGreen  = Color(0xFF3BF87B);
  static const Color categoryOrange = Color(0xFFF89B3B);
  static const Color categoryPink   = Color(0xFFF87B9B);
  static const Color categoryPurple = Color(0xFF7B5CF8);
  static const Color categoryRed    = Color(0xFFFF4D4D);
  static const Color categoryTeal   = Color(0xFF3BF8D4);

  // ── Gray scale ────────────────────────────────────────────
  static const Color gray50  = Color(0xFFFAFAF8);
  static const Color gray100 = Color(0xFFF5F4F0);
  static const Color gray200 = Color(0xFFF0EFE9);
  static const Color gray300 = Color(0xFFE2E0DA);
  static const Color gray400 = Color(0xFFC0BEB5);
  static const Color gray500 = Color(0xFF9B9B9B);
  static const Color gray600 = Color(0xFF5A5A6E);
  static const Color gray700 = Color(0xFF3A3A4E);
  static const Color gray800 = Color(0xFF2A2A3E);
  static const Color gray900 = Color(0xFF1A1A2E);

  // ── Gradients ─────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF2D2B55)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF7B5CF8), Color(0xFF9B7CFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Shadows ───────────────────────────────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF1A1A2E).withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: const Color(0xFF7B5CF8).withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF1A1A2E).withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // ── Missing Legacy Support Colors ────────────────────────
  static const Color primaryDark   = Color(0xFF0F0F1B);
  static const Color primaryLight  = Color(0xFF2D2B55);
  static const Color primaryLighter = Color(0xFFE8E4FF);
  
  static const Color successLight = Color(0xFFE8FFE8);
  static const Color warningLight = Color(0xFFFFF4E8);
  static const Color errorLight   = Color(0xFFFFECEC);
  
  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0xFFFAFAF8), Color(0xFFF0EFE9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}