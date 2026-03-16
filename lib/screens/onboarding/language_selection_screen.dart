import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_provider.dart';
import '../../utils/colors.dart';
import '../home/home_screen.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String? selectedLanguage;

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇬🇧'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी', 'flag': '🇮🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // Logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.gavel_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Choose your\nlanguage',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'आपनी भाषा चुनें',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 40),

              // Language Options
              ...languages.map((lang) {
                final isSelected = selectedLanguage == lang['code'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLanguage = lang['code'];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.06)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.gray200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Flag circle
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.gray100,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                lang['flag']!,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Language name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang['nativeName']!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang['name']!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Check indicator
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: isSelected
                                ? Container(
                              key: const ValueKey('checked'),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                                : Container(
                              key: const ValueKey('unchecked'),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.gray300,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedLanguage != null
                      ? () async {
                    await ref
                        .read(languageProvider.notifier)
                        .setLanguage(selectedLanguage!);
                    await ref.read(setFirstTimeFalseProvider.future);

                    if (!mounted) return;

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.gray200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: selectedLanguage != null
                          ? Colors.white
                          : AppColors.textHint,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}