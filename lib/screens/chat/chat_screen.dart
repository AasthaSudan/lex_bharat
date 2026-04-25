import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chat_provider.dart';
import '../../providers/voice_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/message_bubble.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _voiceController;
  late Animation<double> _voicePulse;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _voiceController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
    _voicePulse = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _voiceController, curve: Curves.easeInOut),
    );
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _voiceController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    setState(() => _hasText = false);
    await ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  Future<void> _handleVoiceButton() async {
    final voiceState = ref.read(voiceStateProvider);
    if (voiceState.isListening) {
      await ref.read(voiceStateProvider.notifier).stopListening();
      return;
    }
    final transcript =
        await ref.read(voiceStateProvider.notifier).startListening();
    if (transcript != null && transcript.trim().isNotEmpty) {
      await ref.read(chatProvider.notifier).sendMessage(transcript);
      _scrollToBottom();
    }
  }

  Future<void> _exportChatToPdf() async {
    final messages = ref.read(chatProvider).messages;
    if (messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.exportNoHistory)));
      return;
    }
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) => [
          pw.Header(
            level: 0,
            child: pw.Text('Lex Bharat — Legal Consultation',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 22)),
          ),
          pw.Paragraph(
              text:
                  'Generated: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}'),
          pw.Divider(),
          ...messages.map((m) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                alignment: m.isUser
                    ? pw.Alignment.centerRight
                    : pw.Alignment.centerLeft,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  constraints: const pw.BoxConstraints(maxWidth: 400),
                  decoration: pw.BoxDecoration(
                    color: m.isUser ? PdfColors.blue100 : PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                      '${m.isUser ? "You" : "Legal Assistant"}:\n${m.text}'),
                ),
              )),
        ],
      ),
    );
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'LexBharat_Chat_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final voiceState = ref.watch(voiceStateProvider);
    final l10n = AppLocalizations.of(context)!;

    if (chatState.messages.isNotEmpty) _scrollToBottom();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            children: [
              // AI avatar
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.gavel_rounded,
                        color: Colors.white, size: 20),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chatTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    chatState.isTyping
                        ? l10n.chatSubtitleThinking
                        : l10n.chatSubtitlePowered,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: chatState.isTyping
                          ? AppColors.accent
                          : AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined,
                color: AppColors.textSecondary, size: 22),
            onPressed: _exportChatToPdf,
            tooltip: 'Export PDF',
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded,
                color: AppColors.textSecondary, size: 22),
            onPressed: () {
              if (chatState.messages.isEmpty) return;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  title: Text(l10n.clearChatTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  content: Text(l10n.clearChatContent),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel,
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600)),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(chatProvider.notifier).clearChat();
                        Navigator.pop(context);
                      },
                      child: Text(l10n.clear,
                          style: const TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Messages ───────────────────────────────────────────────
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState(l10n)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    itemCount: chatState.messages.length +
                        (chatState.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length &&
                          chatState.isTyping) {
                        return _TypingIndicator();
                      }
                      return MessageBubble(
                        message: chatState.messages[index],
                        onSpeak: chatState.messages[index].isUser
                            ? null
                            : () {
                                ref
                                    .read(voiceStateProvider.notifier)
                                    .speakResponse(
                                        chatState.messages[index].text);
                              },
                      );
                    },
                  ),
          ),

          // ── Voice Banner ───────────────────────────────────────────
          if (voiceState.isListening)
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  ScaleTransition(
                    scale: _voicePulse,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      voiceState.liveTranscript.isEmpty
                          ? l10n.listening
                          : voiceState.liveTranscript,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Error Banner ───────────────────────────────────────────
          if (chatState.error != null)
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.errorTint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      chatState.error!,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.error,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

          // ── Input Bar ─────────────────────────────────────────────
          SafeArea(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                children: [
                  // Voice button
                  GestureDetector(
                    onTap: _handleVoiceButton,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: voiceState.isListening
                            ? AppColors.error
                            : AppColors.primaryLighter,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        voiceState.isListening
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        color: voiceState.isListening
                            ? Colors.white
                            : AppColors.accent,
                        size: 22,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Text field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: AppColors.border, width: 1),
                      ),
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: l10n.askAnythingHint,
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textHint,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Send button
                  GestureDetector(
                    onTap:
                        (chatState.isTyping || !_hasText) ? null : _sendMessage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: (_hasText && !chatState.isTyping)
                            ? AppColors.accentGradient
                            : null,
                        color: (!_hasText || chatState.isTyping)
                            ? AppColors.gray200
                            : null,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.send_rounded,
                        color: (_hasText && !chatState.isTyping)
                            ? Colors.white
                            : AppColors.textHint,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    final suggestions = [
      'How to file an FIR?',
      'My rights if arrested',
      'Consumer complaint process',
      'Minimum wage laws',
      'Workplace harassment',
      'Free legal aid',
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      children: [
        // Hero icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppColors.elevatedShadow,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.gavel_rounded,
                color: Colors.white, size: 40),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'How can I help you?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Ask any legal question in plain language.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 32),
        // Suggestions
        const Text(
          'Try asking:',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textHint,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: suggestions
              .map((q) => GestureDetector(
                    onTap: () {
                      _controller.text = q;
                      _sendMessage();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: AppColors.border, width: 1.5),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Text(
                        q,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _anims = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final c = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
      final a = Tween<double>(begin: 0.0, end: -6.0).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      );
      _controllers.add(c);
      _anims.add(a);
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) c.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.gavel_rounded, color: Colors.white, size: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.softShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _anims[i],
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _anims[i].value),
                    child: Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
