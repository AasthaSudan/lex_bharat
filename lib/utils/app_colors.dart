import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF1F77D3);
const Color primaryDarkColor = Color(0xFF1560B0);
const Color accentColor = Color(0xFFFF6B6B);
const Color successColor = Color(0xFF2ECC71);
const Color warningColor = Color(0xFFFFA500);
const Color dangerColor = Color(0xFFE74C3C);
const Color infoColor = Color(0xFF3498DB);

const Color backgroundColor = Color(0xFFF5F6FA);
const Color surfaceColor = Color(0xFFFFFFFF);
const Color textPrimaryColor = Color(0xFF2C3E50);
const Color textSecondaryColor = Color(0xFF7F8C8D);
const Color dividerColor = Color(0xFFECF0F1);
const Color borderColor = Color(0xFFBDC3C7);

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

