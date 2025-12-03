import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';

class WriteEmailScreen extends StatefulWidget {
  const WriteEmailScreen({super.key});

  @override
  State<WriteEmailScreen> createState() => _WriteEmailScreenState();
}

class _WriteEmailScreenState extends State<WriteEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _emailConceptController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool _isGenerating = false;

  @override
  void dispose() {
    _senderNameController.dispose();
    _emailConceptController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<String> generateResponse(String prompt) async {
    // Get API key from .env file
    final apiKey = dotenv.env['OPENAI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'OpenAI API key is not configured. Please add OPENAI_API_KEY to your .env file',
      );
    }

    final url = Uri.https("api.openai.com", "/v1/completions");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          "model": "gpt-3.5-turbo-instruct",
          "prompt": prompt,
          'temperature': 0,
          'max_tokens': 1000,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0,
        }),
      );

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['error']?['message'] ?? 'Unknown error';
        throw Exception('API Error: $errorMessage');
      }

      final responseData = jsonDecode(response.body);

      if (responseData['choices'] == null ||
          responseData['choices'].isEmpty ||
          responseData['choices'][0]['text'] == null) {
        throw Exception('Invalid response format from API');
      }

      return responseData['choices'][0]['text'] as String;
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  Future<void> _generateEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final prompt = '''
Write a professional email with the following details:
- Sender Name: ${_senderNameController.text}
- Email Concept: ${_emailConceptController.text}

Please provide:
1. A professional subject line
2. A complete email body that is well-structured, professional, and addresses the concept provided

Format the response as:
SUBJECT: [subject line here]
BODY: [email body here]
''';

      // Generate email using AI
      final response = await generateResponse(prompt);

      // Parse the response to extract subject and body
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

      // If parsing failed, try to extract from the response directly
      if (subject.isEmpty && body.isEmpty) {
        // Fallback: use the entire response as body and generate a default subject
        body = response.trim();
        subject = 'Email from ${_senderNameController.text}';
      }

      if (mounted) {
        setState(() {
          _subjectController.text = subject;
          _bodyController.text = body;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        CustomSnack.warning(
          'Failed to generate email: ${e.toString().replaceFirst('Exception: ', '')}',
          context,
        );
      }
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  void _copySubject() {
    _copyToClipboard(_subjectController.text);
  }

  void _copyBody() {
    _copyToClipboard(_bodyController.text);
  }

  void _shareEmail() {
    final emailContent =
        'Subject: ${_subjectController.text}\n\n${_bodyController.text}';
    Share.share(emailContent);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'AI Email Writer',
              style: AppTextStyles.headline4,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Details',
                          style: AppTextStyles.headline4,
                        ),
                        const SizedBox(height: 20),

                        // Sender Name Input
                        TextFormField(
                          controller: _senderNameController,
                          decoration: InputDecoration(
                            labelText: 'Sender Name',
                            hintText: 'Enter your name',
                            prefixIcon: const Icon(Icons.person,
                                color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter sender name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email Concept Input
                        TextFormField(
                          controller: _emailConceptController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Email Concept',
                            hintText:
                                'Describe what you want to write about...',
                            prefixIcon: const Icon(Icons.edit,
                                color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please describe your email concept';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Generate Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isGenerating ? null : _generateEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isGenerating
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    'Generate Email',
                                    style: AppTextStyles.buttonMedium,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Generated Email Section
                  if (_subjectController.text.isNotEmpty ||
                      _bodyController.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Generated Email',
                                style: AppTextStyles.headline4.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              IconButton(
                                onPressed: _shareEmail,
                                icon: const Icon(Icons.share,
                                    color: AppColors.primary),
                                tooltip: 'Share Email',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Subject
                          if (_subjectController.text.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subject:',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.gray700,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _copySubject,
                                  icon: const Icon(Icons.copy,
                                      color: AppColors.primary, size: 20),
                                  tooltip: 'Copy Subject',
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _subjectController,
                              maxLines: 2,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.gray50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.borderColor),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Body
                          if (_bodyController.text.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Body:',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.gray700,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _copyBody,
                                  icon: const Icon(Icons.copy,
                                      color: AppColors.primary, size: 20),
                                  tooltip: 'Copy Body',
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _bodyController,
                              maxLines: 8,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.black,
                                height: 1.5,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.gray50,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.borderColor),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )),
    );
  }
}
