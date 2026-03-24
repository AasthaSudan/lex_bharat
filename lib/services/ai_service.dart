import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? ''; // get from console.groq.com
  final String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  final String _systemPrompt = '''You are Lex Bharat, an AI legal rights
assistant for India. Your job is to help ordinary people — farmers, workers,
women, students — understand their legal rights in simple language.

Rules:
- Answer in simple language a 10th grader can understand
- Keep answers under 150 words
- Be specific to Indian law (IPC, CrPC, Constitution, labor laws etc.)
- Always end with: "This is for educational purposes only. For legal advice,
  consult a qualified lawyer."
- If asked in Hindi, reply in Hindi
- Never make up laws or case numbers''';

  Future<String> getLegalAdvice(String question,
      {String language = 'en'}) async {
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
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': question},
          ],
          'max_tokens': 300,
          'temperature': 0.3,
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

  // Fallback when offline or API fails
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