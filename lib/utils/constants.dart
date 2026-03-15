class AppConstants {
  // App Info
  static const String appName = 'Legal Rights Assistant';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your Voice, Your Rights';

  // API Keys (Replace with your actual keys)
  static const String claudeApiKey = 'YOUR_CLAUDE_API_KEY';
  static const String openAiApiKey = 'YOUR_OPENAI_API_KEY';

  // API Endpoints
  static const String claudeApiUrl = 'https://api.anthropic.com/v1/messages';
  static const String openAiApiUrl = 'https://api.openai.com/v1/chat/completions';

  // Spacing
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Font Sizes
  static const double fontXSmall = 10.0;
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontNormal = 16.0;
  static const double fontLarge = 18.0;
  static const double fontXLarge = 20.0;
  static const double fontXXLarge = 24.0;
  static const double fontTitle = 28.0;
  static const double fontHero = 32.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Emergency Numbers
  static const Map<String, String> emergencyNumbers = {
    'Police': '100',
    'Ambulance': '108',
    'Fire': '101',
    'Women Helpline': '1091',
    'Child Helpline': '1098',
    'Senior Citizen Helpline': '14567',
    'National Legal Services': '1800-11-4001',
    'National Consumer Helpline': '1800-11-4000',
  };

  // Legal Categories
  static const List<String> legalCategories = [
    'Labor Rights',
    'Property Rights',
    'Women\'s Rights',
    'Consumer Rights',
    'Family Law',
    'Criminal Law',
  ];

  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'हिंदी',
  };

  // Form Types
  static const List<String> formTypes = [
    'FIR',
    'Legal Aid Application',
    'Consumer Complaint',
    'Labor Grievance',
    'RTI Application',
  ];

  // Max Values
  static const int maxChatMessages = 100;
  static const int maxFormDrafts = 10;
  static const int maxBookmarks = 50;

  // Default Values
  static const String defaultLanguage = 'en';
  static const int defaultChatTimeout = 30; // seconds
  static const int maxRetries = 3;
}