import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  final String baseUrl = AppConstants.claudeApiUrl;
  final String apiKey = AppConstants.claudeApiKey;

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-3-sonnet-20240229',
          'max_tokens': 1024,
          'messages': [
            {
              'role': 'user',
              'content': '''You are a legal rights assistant for India. 
              Provide accurate, simple legal information.
              
              User question: $message
              
              Answer in simple language, maximum 150 words.'''
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'];
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get response: $e');
    }
  }

  Future<Map<String, dynamic>> analyzeDocument(String documentPath) async {
    // Implement document analysis
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> searchResources(String query) async {
    // Implement resource search
    throw UnimplementedError();
  }
}