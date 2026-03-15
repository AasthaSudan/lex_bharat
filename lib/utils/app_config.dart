import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  static const String appName = 'Lex Bharat';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';

  // API Configuration
  static const String apiBaseUrl = 'https://api.lexbharat.in/v1';
  static const String apiTimeout = '30'; // seconds

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const bool enableOfflineMode = true;
  static const bool enableVoiceAssistant = true;

  // Supported Languages
  static const List<String> supportedLanguages = [
    'en',
    'hi',
    'ta',
    'te',
    'ka',
    'ml',
    'bn',
    'gu',
    'mr',
    'or',
    'pa',
    'ur',
  ];

  // Default Settings
  static const String defaultLanguage = 'en';
  static const bool defaultDarkMode = false;
  static const bool defaultNotifications = true;

  // Cache Configuration
  static const int cacheDurationDays = 7;
  static const int maxCacheSize = 100; // MB

  // Sync Configuration
  static const bool autoSync = true;
  static const int syncIntervalMinutes = 15;
}

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String message = 'An error occurred';

    if (error is FormatException) {
      message = 'Invalid format';
    } else if (error is TimeoutException) {
      message = 'Request timeout';
    } else {
      message = error.toString();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class Logger {
  static void debug(String tag, String message) {
    print('[$tag] DEBUG: $message');
  }

  static void info(String tag, String message) {
    print('[$tag] INFO: $message');
  }

  static void warning(String tag, String message) {
    print('[$tag] WARNING: $message');
  }

  static void error(String tag, String message, dynamic error) {
    print('[$tag] ERROR: $message');
    print('Details: $error');
  }
}

class AppConstants {
  // String constants
  static const String appTitle = 'Lex Bharat - Know Your Rights';
  static const String welcomeMessage = 'Welcome to Lex Bharat';
  static const String noInternetMessage = 'No internet connection. Using offline mode.';
  static const String loadingMessage = 'Loading...';
  static const String errorMessage = 'Something went wrong';

  // Time constants
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;
}

class DateTimeHelper {
  static String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(dateTime);
    }
  }
}

class StringHelper {
  static String capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String truncate(String text, int length) {
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }

  static bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  static bool isPhoneValid(String phone) {
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'\D'), ''));
  }
}

class ValidationHelper {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength) {
    if (value != null && value.length < minLength) {
      return 'Must be at least $minLength characters';
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Cannot exceed $maxLength characters';
    }
    return null;
  }
}

