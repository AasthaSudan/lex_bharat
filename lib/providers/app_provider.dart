import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Async language provider - properly loads language on startup
final languageProvider = NotifierProvider<LanguageNotifier, String>(
  LanguageNotifier.new,
);

class LanguageNotifier extends Notifier<String> {
  @override
  String build() {
    return 'en';
  }

  Future<void> setLanguage(String lang) async {
    state = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('language') ?? 'en';
    state = language;
    return language;
  }
}

// Future provider for async language loading
final languageLoadProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('language') ?? 'en';
});

final themeProvider =
NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadTheme();
    return false;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('dark_mode') ?? false;
  }

  Future<void> toggleTheme() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', state);
  }
}

final firstTimeProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('first_time') ?? true;
});

final setFirstTimeFalseProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('first_time', false);
});

final securityLockProvider =
NotifierProvider<SecurityLockNotifier, bool>(SecurityLockNotifier.new);

class SecurityLockNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadSecurityLock();
    return false;
  }

  Future<void> _loadSecurityLock() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('security_lock') ?? false;
  }

  Future<void> toggleSecurityLock() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('security_lock', state);
  }
}