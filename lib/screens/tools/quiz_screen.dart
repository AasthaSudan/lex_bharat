import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _allQuizzes = [];
  Map<String, dynamic>? _selectedQuiz;
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _showExplanation = false;
  int _score = 0;
  bool _isLoading = true;
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/quiz_data.json');
      final data = json.decode(jsonStr);
      setState(() {
        _allQuizzes = List<Map<String, dynamic>>.from(data['quizzes']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _startQuiz(Map<String, dynamic> quiz) {
    setState(() {
      _selectedQuiz = quiz;
      _questions = List<Map<String, dynamic>>.from(quiz['questions']);
      _currentIndex = 0;
      _selectedAnswer = null;
      _showExplanation = false;
      _score = 0;
      _quizFinished = false;
    });
  }

  void _selectAnswer(int index) {
    if (_showExplanation) return;
    final correct = _questions[_currentIndex]['answer'] as int;
    setState(() {
      _selectedAnswer = index;
      _showExplanation = true;
      if (index == correct) _score++;
    });
  }

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
      });
    } else {
      setState(() => _quizFinished = true);
    }
  }

  void _resetToCategories() {
    setState(() {
      _selectedQuiz = null;
      _questions = [];
      _quizFinished = false;
    });
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
          onPressed: _selectedQuiz == null ? () => Navigator.pop(context) : _resetToCategories,
          color: AppColors.textPrimary,
        ),
        title: Text(
          _selectedQuiz == null ? 'Know Your Rights Quiz' : (_selectedQuiz!['category'] as String),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textPrimary, letterSpacing: -0.5),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedQuiz == null
              ? _buildCategoryPicker()
              : _quizFinished
                  ? _buildResults()
                  : _buildQuestion(),
    );
  }

  Widget _buildCategoryPicker() {
    final colors = [
      AppColors.accent, AppColors.info, AppColors.categoryPink,
      AppColors.error, AppColors.categoryTeal, AppColors.warning,
    ];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 40),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Test Your Legal Knowledge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 4),
                    Text('Pick a category and start the quiz', style: TextStyle(fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
        ...List.generate(_allQuizzes.length, (i) {
          final quiz = _allQuizzes[i];
          final color = colors[i % colors.length];
          final qCount = (quiz['questions'] as List).length;
          return GestureDetector(
            onTap: () => _startQuiz(quiz),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: Icon(Icons.quiz_rounded, color: color, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quiz['category'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('$qCount questions', style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color.withValues(alpha: 0.6)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuestion() {
    final q = _questions[_currentIndex];
    final options = List<String>.from(q['options']);
    final correctIdx = q['answer'] as int;
    final progress = (_currentIndex + 1) / _questions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          Row(
            children: [
              Text('${_currentIndex + 1}/${_questions.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.gray200,
                    color: AppColors.accent,
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Question
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              q['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white, height: 1.4),
            ),
          ),
          const SizedBox(height: 24),

          // Options
          ...List.generate(options.length, (i) {
            Color bgColor = AppColors.surface;
            Color borderColor = AppColors.gray200;
            Color textColor = AppColors.textPrimary;
            IconData? icon;

            if (_showExplanation) {
              if (i == correctIdx) {
                bgColor = AppColors.successLight;
                borderColor = AppColors.success;
                textColor = AppColors.textPrimary;
                icon = Icons.check_circle_rounded;
              } else if (i == _selectedAnswer && i != correctIdx) {
                bgColor = AppColors.errorLight;
                borderColor = AppColors.error;
                textColor = AppColors.error;
                icon = Icons.cancel_rounded;
              }
            } else if (_selectedAnswer == i) {
              borderColor = AppColors.accent;
            }

            return GestureDetector(
              onTap: () => _selectAnswer(i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: borderColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: icon != null
                          ? Icon(icon, color: i == correctIdx ? AppColors.success : AppColors.error, size: 20)
                          : Text(String.fromCharCode(65 + i), style: TextStyle(fontWeight: FontWeight.bold, color: borderColor)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Text(options[i], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor))),
                  ],
                ),
              ),
            );
          }),

          // Explanation
          if (_showExplanation) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_rounded, color: AppColors.info, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(q['explanation'], style: TextStyle(fontSize: 13, color: AppColors.info, height: 1.5, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _currentIndex < _questions.length - 1 ? 'Next Question →' : 'See Results',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final total = _questions.length;
    final pct = (_score / total * 100).round();
    final emoji = pct >= 80 ? '🏆' : pct >= 60 ? '👍' : '📚';
    final message = pct >= 80 ? 'Excellent! You know your rights!' : pct >= 60 ? 'Good job! Keep learning.' : 'Keep studying — knowledge protects you!';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text('$_score / $total', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -2)),
            const SizedBox(height: 8),
            Text('$pct% Score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent)),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startQuiz(_selectedQuiz!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _resetToCategories,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.gray300),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Try Another Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
