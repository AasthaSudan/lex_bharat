import 'package:flutter/material.dart';

class AppColors {
  // Minimal color palette - Simple and clean
  static const Color primary     = Color(0xFF000000);  // Pure black for primary actions
  static const Color accent      = Color(0xFF0066FF);  // Clean blue for highlights
  static const Color accentLight = Color(0xFFE6F0FF);  // Light blue background

  static const Color background  = Color(0xFFFAFAFA);  // Off-white background
  static const Color surface     = Color(0xFFFFFFFF);  // Pure white
  static const Color surfaceDim  = Color(0xFFF5F5F5);  // Light gray

  static const Color textPrimary   = Color(0xFF000000);  // Black text
  static const Color textSecondary = Color(0xFF666666);  // Gray text
  static const Color textHint      = Color(0xFF999999);  // Light gray hint

  static const Color border     = Color(0xFFE5E5E5);  // Minimal gray border
  static const Color borderMid  = Color(0xFFDDDDDD);   // Medium gray border

  static const Color success     = Color(0xFF00B81A);  // Clean green
  static const Color successTint = Color(0xFFE6F7E6);  // Light green
  static const Color warning     = Color(0xFFFF9800);  // Clean orange
  static const Color warningTint = Color(0xFFFFF3E0);  // Light orange
  static const Color error       = Color(0xFFD32F2F);  // Clean red
  static const Color errorTint   = Color(0xFFFFEBEE);  // Light red
  static const Color info        = Color(0xFF0066FF);  // Same as accent
  static const Color infoTint    = Color(0xFFE6F0FF);  // Light blue

  static const Color categoryBlue   = Color(0xFF0066FF);
  static const Color categoryGreen  = Color(0xFF00B81A);
  static const Color categoryOrange = Color(0xFFFF9800);
  static const Color categoryPink   = Color(0xFFE91E63);
  static const Color categoryPurple = Color(0xFF9C27B0);
  static const Color categoryRed    = Color(0xFFD32F2F);
  static const Color categoryTeal   = Color(0xFF009688);

  static const Color gray50  = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF333333)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 1),
    ),
  ];

  static const Color primaryDark   = Color(0xFF000000);
  static const Color primaryLight  = Color(0xFF333333);
  static const Color primaryLighter = Color(0xFFE6F0FF);

  static const Color successLight = Color(0xFFE6F7E6);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color errorLight   = Color(0xFFFFEBEE);
  static const Color infoLight    = Color(0xFFE6F0FF);

  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}