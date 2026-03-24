import 'package:flutter/material.dart';
import '../models/message.dart';
import '../utils/colors.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onSpeak;

  const MessageBubble({super.key, required this.message, this.onSpeak});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.surfaceDim,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : AppColors.textPrimary,
                fontSize: 15,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!message.isUser && onSpeak != null) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onSpeak,
                child: const Icon(Icons.volume_up, size: 16, color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}