import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  final String _systemPrompt = '''You are Lex Bharat, an AI legal rights
assistant for India. Your job is to help ordinary people — farmers, workers,
women, students — understand their legal rights in simple language.

Rules:
- Answer in simple language a 10th grader can understand
- Keep answers under 150-200 words
- Be specific to Indian law (IPC, CrPC, Constitution, labor laws etc.)
- Always end with: "This is for educational purposes only. For legal advice, consult a qualified lawyer."
- If asked in Hindi, reply in Hindi
- Never make up laws or case numbers
- Provide step-by-step guidance when asked
- Consider context from conversation history
- Warn about time-sensitive matters (statutes of limitations)''';

  // Multi-turn conversation support
  Future<String> getLegalAdvice(
    String question, {
    String language = 'en',
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _systemPrompt},
      ];

      // Add conversation history if provided
      if (conversationHistory != null) {
        messages.addAll(conversationHistory);
      }

      // Add current question
      messages.add({
        'role': 'user',
        'content': 'Language: $language\n\nQuestion: $question'
      });

      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 10),
        ),
        data: {
          'model': 'llama-3.3-70b-versatile',
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.3,
          'top_p': 0.7,
        },
      );
      return response.data['choices'][0]['message']['content'] as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return 'API key error. Please check your Groq API key.';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Request timed out. Please check your internet connection.';
      }
      return _getFallbackResponse(question);
    } catch (e) {
      return _getFallbackResponse(question);
    }
  }

  // Case assessment feature
  Future<Map<String, dynamic>> assessCase(
    String situationDescription, {
    String language = 'en',
  }) async {
    const caseAssessmentPrompt = '''Analyze this legal situation and provide:
1. Relevant laws/sections (if any)
2. Possible outcomes (brief)
3. Recommended immediate actions
4. Case strength (Weak/Moderate/Strong)
5. Time-sensitive deadlines to know
6. Warnings or things to avoid

Format as JSON with keys: identifiedLaws, possibleOutcomes, recommendedActions, caseStrength, timeDeadlines, warnings''';

    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 10),
        ),
        data: {
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': caseAssessmentPrompt},
            {
              'role': 'user',
              'content':
                  'Language: $language\n\nSituation: $situationDescription'
            },
          ],
          'max_tokens': 800,
          'temperature': 0.3,
        },
      );

      final content = response.data['choices'][0]['message']['content'] as String;
      return _parseCaseAssessment(content);
    } catch (e) {
      return {
        'error': 'Unable to assess case. Please try again.',
        'fallbackAdvice': _getFallbackResponse(situationDescription),
      };
    }
  }

  Map<String, dynamic> _parseCaseAssessment(String responseText) {
    try {
      // Try to extract JSON from response
      final jsonStart = responseText.indexOf('{');
      final jsonEnd = responseText.lastIndexOf('}') + 1;

      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonStr = responseText.substring(jsonStart, jsonEnd);
        // Parse would happen here with proper JSON library
        return {
          'rawResponse': jsonStr,
          'success': true,
        };
      }
      return {'rawResponse': responseText, 'success': true};
    } catch (e) {
      return {
        'rawResponse': responseText,
        'success': false,
        'error': 'Could not parse response',
      };
    }
  }

  String _getFallbackResponse(String question) {
    final q = question.toLowerCase();
    if (q.contains('fir') || q.contains('police')) {
      return 'You can file an FIR at any police station under Section 154 CrPC. Police cannot refuse. If refused, contact the SP or use your state\'s online FIR portal.\n\nThis is for educational purposes only.';
    } else if (q.contains('minimum wage') || q.contains('salary')) {
      return 'Every worker has the right to minimum wage under the Minimum Wages Act 1948. Rates vary by state and industry. Contact your state Labour Commissioner for exact rates.\n\nThis is for educational purposes only.';
    } else if (q.contains('rent') || q.contains('evict')) {
      return 'A landlord must give written notice before eviction. Illegal eviction (changing locks, cutting utilities) is a criminal offense. Approach Rent Control Court if harassed.\n\nThis is for educational purposes only.';
    } else if (q.contains('domestic violence') || q.contains('harassment')) {
      return 'The Protection of Women from Domestic Violence Act 2005 protects you. Call Women Helpline 1091 immediately. You can also approach a Protection Officer or Magistrate for a protection order.\n\nThis is for educational purposes only.';
    }
    return 'I\'m currently offline. For legal help, call the National Legal Services Helpline: 1800-11-4001 (free).\n\nThis is for educational purposes only.';
  }
}