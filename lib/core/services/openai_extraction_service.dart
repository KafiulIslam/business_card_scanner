import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../exceptions/openai_exception.dart';

/// Service for extracting business card information using OpenAI API
class OpenAIExtractionService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const Duration _timeout = Duration(seconds: 15);
  static const String _model = 'gpt-4o-mini';

  /// Get OpenAI API key from environment variables
  String? get _apiKey => dotenv.env['OPENAI_API_KEY'];

  /// Extract business card fields from raw OCR text using OpenAI
  /// 
  /// Returns a map with keys: name, jobTitle, company, email, phone, address, website
  /// Returns null if extraction fails
  Future<Map<String, String?>> extractBusinessCardFields(String rawText) async {
    if (rawText.trim().isEmpty) {
      throw OpenAIException('Raw text is empty');
    }

    final apiKey = _apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw OpenAIException(
        'OpenAI API key is not configured. Please add OPENAI_API_KEY to your .env file',
      );
    }

    try {
      final prompt = _buildPrompt(rawText);
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': _model,
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'You are an expert at extracting structured information from business card text. Always return valid JSON only, no explanations.',
                },
                {
                  'role': 'user',
                  'content': prompt,
                },
              ],
              'temperature': 0.1, // Low temperature for consistent extraction
              'max_tokens': 500,
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

  /// Build the extraction prompt
  String _buildPrompt(String rawText) {
    return """
You are an expert at extracting structured information from business card text.

Extract ONLY the following fields from the text below. Return a valid JSON object with these exact keys:
- name: Full name of the person (first and last name, typically 2-4 words)
- jobTitle: Job title or position (e.g., "Marketing Manager", "CEO")
- company: Company name (may include Inc, LLC, Corp, etc.)
- email: Email address
- phone: Phone number (include country code if present)
- address: Full address (street, city, state, zip)
- website: Website URL (without http:// if present)

Rules:
- If a field is not found, return empty string "" for that field
- Do NOT include any text outside the JSON object
- Do NOT add comments or explanations
- Return ONLY valid JSON
- Name should be person's name, not company name
- Company should be the business/organization name
- Job title should be the person's position/role

Text to extract from:
$rawText
""";
  }

  /// Parse the OpenAI API response
  Map<String, String?> _parseResponse(http.Response response) {
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

    final message = choices[0]['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;

    if (content == null || content.trim().isEmpty) {
      throw OpenAIException('Empty response from OpenAI API');
    }

    // Try to extract JSON from the response
    // Sometimes GPT returns text with JSON, so we need to extract it
    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
    if (jsonMatch == null) {
      throw OpenAIException('No JSON found in OpenAI response');
    }

    try {
      final jsonString = jsonMatch.group(0)!;
      final extracted = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate and normalize the response
      return {
        'name': _normalizeField(extracted['name']),
        'jobTitle': _normalizeField(extracted['jobTitle'] ?? extracted['job_title']),
        'company': _normalizeField(extracted['company']),
        'email': _normalizeField(extracted['email']),
        'phone': _normalizeField(extracted['phone']),
        'address': _normalizeField(extracted['address']),
        'website': _normalizeField(extracted['website']),
      };
    } catch (e) {
      throw OpenAIException('Failed to parse JSON response: ${e.toString()}');
    }
  }

  /// Normalize field value (convert to string, trim, return null if empty)
  String? _normalizeField(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }
}

