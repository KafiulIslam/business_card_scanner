/// Custom exception for OpenAI API errors
class OpenAIException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorType;

  const OpenAIException(
    this.message, {
    this.statusCode,
    this.errorType,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return 'OpenAIException [$statusCode${errorType != null ? ' - $errorType' : ''}]: $message';
    }
    return 'OpenAIException: $message';
  }
}

