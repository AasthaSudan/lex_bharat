import 'package:flutter/material.dart';
import '../utils/colors.dart';

class VoiceButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onPressed;

  const VoiceButton({
    required this.isListening,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isListening ? AppColors.error : AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: isListening
            ? [
          BoxShadow(
            color: AppColors.error.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: CircleBorder(),
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}