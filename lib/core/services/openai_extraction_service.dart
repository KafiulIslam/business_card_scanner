import 'package:cloud_functions/cloud_functions.dart';
import '../exceptions/openai_exception.dart';

/// Extracts business card fields by calling the extractCard Cloud Function.
class OpenAIExtractionService {
  static const Duration _timeout = Duration(seconds: 20);

  Future<Map<String, String?>> extractBusinessCardFields(String rawText) async {
    if (rawText.trim().isEmpty) {
      throw const OpenAIException('Raw text is empty');
    }

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('extractCard')
          .call({'rawText': rawText})
          .timeout(_timeout);
      final data = Map<String, dynamic>.from(result.data as Map);

      return {
        'name': _normalizeField(data['name']),
        'jobTitle': _normalizeField(data['jobTitle']),
        'company': _normalizeField(data['company']),
        'email': _normalizeField(data['email']),
        'phone': _normalizeField(data['phone']),
        'address': _normalizeField(data['address']),
        'website': _normalizeField(data['website']),
      };
    } on FirebaseFunctionsException catch (e) {
      throw OpenAIException(e.message ?? 'AI request failed');
    } catch (e) {
      if (e is OpenAIException) rethrow;
      throw OpenAIException('Unexpected error: ${e.toString()}');
    }
  }

  String? _normalizeField(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }
}
