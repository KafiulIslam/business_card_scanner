import 'package:cloud_functions/cloud_functions.dart';
import '../../../../core/exceptions/openai_exception.dart';

/// Drafts an email by calling the generateEmail Cloud Function.
class OpenAIEmailService {
  static const Duration _timeout = Duration(seconds: 30);

  Future<String> generateEmail({
    required String senderName,
    required String emailConcept,
  }) async {
    if (senderName.trim().isEmpty) {
      throw const OpenAIException('Sender name cannot be empty');
    }
    if (emailConcept.trim().isEmpty) {
      throw const OpenAIException('Email concept cannot be empty');
    }

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('generateEmail')
          .call({
            'senderName': senderName,
            'emailConcept': emailConcept,
          })
          .timeout(_timeout);
      final data = Map<String, dynamic>.from(result.data as Map);
      final text = data['text']?.toString().trim();
      if (text == null || text.isEmpty) {
        throw const OpenAIException('Empty response from AI');
      }
      return text;
    } on FirebaseFunctionsException catch (e) {
      throw OpenAIException(e.message ?? 'AI request failed');
    } catch (e) {
      if (e is OpenAIException) rethrow;
      throw OpenAIException('Unexpected error: ${e.toString()}');
    }
  }
}
