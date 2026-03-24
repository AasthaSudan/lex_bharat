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
      // Ideally flutter_tts provides completion callback. Simple toggle simulation.
      if (mounted) setState(() => isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic['title']),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isPlaying ? Icons.stop_circle : Icons.volume_up),
            color: AppColors.primary,
            onPressed: _toggleSpeak,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to bookmarks')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topic['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.topic['content'],
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.textSecondary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Information provided is for educational purposes. For specific legal advice, consult a lawyer or use our AI Assistant.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
