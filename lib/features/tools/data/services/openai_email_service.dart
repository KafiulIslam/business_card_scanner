import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../../../core/exceptions/openai_exception.dart';

/// Service for generating emails using OpenAI API
class OpenAIEmailService {
  static const String _baseUrl = 'https://api.openai.com/v1/completions';
  static const Duration _timeout = Duration(seconds: 30);
  static const String _model = 'gpt-3.5-turbo-instruct';

  /// Get OpenAI API key from environment variables
  String? get _apiKey => dotenv.env['OPENAI_API_KEY'];

  /// Generate email content using OpenAI
  /// 
  /// Returns the generated email response as a string
  Future<String> generateEmail({
    required String senderName,
    required String emailConcept,
  }) async {
    if (senderName.trim().isEmpty) {
      throw OpenAIException('Sender name cannot be empty');
    }

    if (emailConcept.trim().isEmpty) {
      throw OpenAIException('Email concept cannot be empty');
    }

    final apiKey = _apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw OpenAIException(
        'OpenAI API key is not configured. Please add OPENAI_API_KEY to your .env file',
      );
    }

    try {
      final prompt = _buildPrompt(senderName, emailConcept);
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': _model,
              'prompt': prompt,
              'temperature': 0,
              'max_tokens': 1000,
              'top_p': 1,
              'frequency_penalty': 0.0,
              'presence_penalty': 0.0,
            }),
          )
          .timeout(_timeout);

      return _parseResponse(response);
    } on http.ClientException catch (e) {
      throw OpenAIException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw OpenAIException('Invalid response format: ${e.message}');
    } catch (e) {
      if (e is OpenAIException) rethrow;
      throw OpenAIException('Unexpected error: ${e.toString()}');
    }
  }

  /// Build the email generation prompt
  String _buildPrompt(String senderName, String emailConcept) {
    return '''
Write a professional email with the following details:
- Sender Name: $senderName
- Email Concept: $emailConcept

Please provide:
1. A professional subject line
2. A complete email body that is well-structured, professional, and addresses the concept provided

Format the response as:
SUBJECT: [subject line here]
BODY: [email body here]
''';
  }

  /// Parse the OpenAI API response
  String _parseResponse(http.Response response) {
    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      final errorMessage = errorBody['error']?['message'] ?? 'Unknown error';
      final errorType = errorBody['error']?['type'] as String?;
      throw OpenAIException(
        errorMessage,
        statusCode: response.statusCode,
        errorType: errorType,
      );
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = responseBody['choices'] as List<dynamic>?;

    if (choices == null || choices.isEmpty) {
      throw OpenAIException('No response from OpenAI API');
    }

    final text = choices[0]['text'] as String?;

    if (text == null || text.trim().isEmpty) {
      throw OpenAIException('Empty response from OpenAI API');
    }

    return text.trim();
  }
}

