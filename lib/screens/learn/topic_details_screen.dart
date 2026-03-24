import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/voice_provider.dart';
import '../../utils/colors.dart';

class TopicDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> topic;
  final Color categoryColor;

  const TopicDetailsScreen({
    super.key,
    required this.topic,
    required this.categoryColor,
  });

  @override
  ConsumerState<TopicDetailsScreen> createState() => _TopicDetailsScreenState();
}

class _TopicDetailsScreenState extends ConsumerState<TopicDetailsScreen> {
  bool isPlaying = false;

  @override
  void dispose() {
    ref.read(voiceServiceProvider).stopSpeaking();
    super.dispose();
  }

  void _toggleSpeak() async {
    final service = ref.read(voiceServiceProvider);
    if (isPlaying) {
      await service.stopSpeaking();
      if (mounted) setState(() => isPlaying = false);
    } else {
      setState(() => isPlaying = true);
      await service.speak(widget.topic['content']);
      if (mounted) setState(() => isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: AppColors.textPrimary,
        ),
        title: const Text('Article', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textPrimary, letterSpacing: -0.5)),
        actions: [
          IconButton(
            icon: Icon(isPlaying ? Icons.stop_circle_rounded : Icons.volume_up_rounded),
            color: widget.categoryColor,
            onPressed: _toggleSpeak,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded, color: AppColors.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to bookmarks')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.topic['title'],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -1.0,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: AppColors.cardShadow,
                  border: Border.all(color: widget.categoryColor.withValues(alpha: 0.1), width: 1.5),
                ),
                child: Text(
                  widget.topic['content'],
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.categoryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: widget.categoryColor.withValues(alpha: 0.2), width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.categoryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.info_outline_rounded, color: widget.categoryColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Information provided is for educational purposes. For specific legal advice, consult a lawyer or use our AI Assistant.',
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.categoryColor,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
