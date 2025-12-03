import 'package:bloc/bloc.dart';
import '../../data/services/openai_email_service.dart';
import 'write_email_state.dart';

class WriteEmailCubit extends Cubit<WriteEmailState> {
  final OpenAIEmailService _openAIEmailService;

  WriteEmailCubit(this._openAIEmailService)
      : super(WriteEmailState.initial());

  /// Generate email using AI
  Future<void> generateEmail({
    required String senderName,
    required String emailConcept,
  }) async {
    emit(state.copyWith(isLoading: true, error: null, clearError: true));

    try {
      final response =
          await _openAIEmailService.generateEmail(
        senderName: senderName,
        emailConcept: emailConcept,
      );

      // Parse the response to extract subject and body
      final parsed = _parseEmailResponse(response, senderName);

      emit(state.copyWith(
        isLoading: false,
        generatedSubject: parsed['subject'],
        generatedBody: parsed['body'],
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('OpenAIException: ', ''),
      ));
    }
  }

  /// Parse the AI response to extract subject and body
  Map<String, String> _parseEmailResponse(String response, String senderName) {
    final lines = response.split('\n');
    String subject = '';
    String body = '';
    bool isBody = false;

    for (String line in lines) {
      if (line.trim().startsWith('SUBJECT:')) {
        subject = line
            .replaceFirst(RegExp(r'SUBJECT:\s*', caseSensitive: false), '')
            .trim();
      } else if (line.trim().startsWith('BODY:')) {
        body = line
            .replaceFirst(RegExp(r'BODY:\s*', caseSensitive: false), '')
            .trim();
        isBody = true;
      } else if (isBody && line.trim().isNotEmpty) {
        body += '\n${line.trim()}';
      }
    }

    // If parsing failed, use fallback
    if (subject.isEmpty && body.isEmpty) {
      body = response.trim();
      subject = 'Email from $senderName';
    }

    return {'subject': subject, 'body': body};
  }

  /// Reset the state
  void reset() {
    emit(WriteEmailState.initial());
  }

  /// Clear error
  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}

