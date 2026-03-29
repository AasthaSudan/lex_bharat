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

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    await ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  Future<void> _handleVoiceButton() async {
    final voiceState = ref.read(voiceStateProvider);

    if (voiceState.isListening) {
      await ref.read(voiceStateProvider.notifier).stopListening();
      return;
    }

    final transcript = await ref.read(voiceStateProvider.notifier).startListening();

    if (transcript != null && transcript.trim().isNotEmpty) {
      await ref.read(chatProvider.notifier).sendMessage(transcript);
      _scrollToBottom();
    }
  }

  Future<void> _exportChatToPdf() async {
    final messages = ref.read(chatProvider).messages;
    if (messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No chat history to export.')));
      return;
    }

    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Lex Bharat - Legal Consultation History', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
            ),
            pw.Paragraph(text: 'Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
            pw.Divider(),
            ...messages.map((m) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                alignment: m.isUser ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  constraints: const pw.BoxConstraints(maxWidth: 400),
                  decoration: pw.BoxDecoration(
                    color: m.isUser ? PdfColors.blue100 : PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    '${m.isUser ? "You" : "Legal Assistant"}:\n${m.text}',
                  ),
                ),
              );
            }).toList(),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'Legal_Chat_History_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  Widget _buildBotIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final voiceState = ref.watch(voiceStateProvider);

    if (chatState.messages.isNotEmpty) _scrollToBottom();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            _buildBotIcon(),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Legal Assistant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.5),
                ),
                Text(
                  chatState.isTyping ? 'Thinking...' : 'Powered by Groq AI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: chatState.isTyping ? AppColors.accent : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary),
            onPressed: () => _exportChatToPdf(),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: AppColors.textSecondary),
            onPressed: () {
              if (chatState.messages.isEmpty) return;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  title: const Text('Clear conversation?', style: TextStyle(fontWeight: FontWeight.bold)),
                  content: const Text('This will clear your chat history with the AI assistant.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(chatProvider.notifier).clearChat();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    itemCount: chatState.messages.length + (chatState.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length && chatState.isTyping) {
                        return _buildTypingIndicator();
                      }
                      return MessageBubble(
                        message: chatState.messages[index],
                        onSpeak: chatState.messages[index].isUser
                            ? null
                            : () {
                                ref.read(voiceStateProvider.notifier).speakResponse(chatState.messages[index].text);
                              },
                      );
                    },
                  ),
          ),

          if (voiceState.isListening)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryLighter,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      voiceState.liveTranscript.isEmpty ? 'Listening...' : voiceState.liveTranscript,
                      style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

          if (chatState.error != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.errorTint,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      chatState.error!,
                      style: const TextStyle(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _handleVoiceButton,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                            width: 12,
                            height: 20,
                            decoration: BoxDecoration(
                                color: voiceState.isListening ? AppColors.error : AppColors.surfaceDim,
                                borderRadius: BorderRadius.circular(6)
                            ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Ask anything...',
                          hintStyle: TextStyle(fontSize: 16, color: AppColors.textHint, fontWeight: FontWeight.w500),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),

                    const SizedBox(width: 12),

                    GestureDetector(
                      onTap: chatState.isTyping ? null : _sendMessage,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              'File an FIR?',
              'Minimum wage',
              'Eviction rules',
              'Consumer complaint',
              'Workplace harassment',
              'Free legal aid',
            ].map((q) => GestureDetector(
                  onTap: () {
                    _controller.text = q;
                    _sendMessage();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Text(
                      q,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ),
                )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text('Thinking...', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
