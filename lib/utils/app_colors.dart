import 'package:flutter/material.dart';

// Primary Colors - Blue theme (Jobee style)
const Color primaryColor = Color(0xFF3B82F6);
const Color primaryDarkColor = Color(0xFF2563EB);
const Color accentColor = Color(0xFF60A5FA);
const Color successColor = Color(0xFF10B981);
const Color warningColor = Color(0xFFF59E0B);
const Color dangerColor = Color(0xFFEF4444);
const Color infoColor = Color(0xFF3B82F6);

// Background & Surface
const Color backgroundColor = Color(0xFFFAFAFA);
const Color surfaceColor = Color(0xFFFFFFFF);
const Color textPrimaryColor = Color(0xFF111827);
const Color textSecondaryColor = Color(0xFF6B7280);
const Color dividerColor = Color(0xFFE5E7EB);
const Color borderColor = Color(0xFFD1D5DB);

const Color emergencySosColor = Color(0xFFE74C3C);
const Color successGreenColor = Color(0xFF27AE60);
const Color warningOrangeColor = Color(0xFFE67E22);
const Color infoBlueColor = Color(0xFF3498DB);

class AppColorScheme {
  static const Map<String, Color> categoryColors = {
    'Labor Rights': Color(0xFF3498DB),
    'Property Rights': Color(0xFF2ECC71),
    "Women's Rights": Color(0xFFE91E63),
    'Consumer Rights': Color(0xFFFFA500),
    'Child Rights': Color(0xFF9C27B0),
    'Disability Rights': Color(0xFF00BCD4),
    'Minority Rights': Color(0xFFFF5722),
  };

  static const Map<String, Color> violationColors = {
    'Harassment': Color(0xFFE74C3C),
    'Labor Violation': Color(0xFFF39C12),
    'Property Dispute': Color(0xFF95A5A6),
    'Domestic Violence': Color(0xFFC0392B),
    'Consumer Fraud': Color(0xFFE67E22),
    'Discrimination': Color(0xFF34495E),
    'Workplace Harassment': Color(0xFFD35400),
    'Wage Theft': Color(0xFF16A085),
  };
}

