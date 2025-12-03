import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/services/external_app_service.dart';
import '../../cubit/write_email_cubit.dart';
import '../../cubit/write_email_state.dart';

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

  @override
  void dispose() {
    _senderNameController.dispose();
    _emailConceptController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _generateEmail() {
    if (!_formKey.currentState!.validate()) return;

    context.read<WriteEmailCubit>().generateEmail(
          senderName: _senderNameController.text.trim(),
          emailConcept: _emailConceptController.text.trim(),
        );
  }

  void _copyToClipboard(String text) {
    try {
      final externalAppService = context.read<ExternalAppService>();
      externalAppService.copyToClipboard(text);
      if (mounted) {
        CustomSnack.success('Copied to clipboard', context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to copy: ${e.toString()}', context);
      }
    }
  }

  void _copySubject() {
    _copyToClipboard(_subjectController.text);
  }

  void _copyBody() {
    _copyToClipboard(_bodyController.text);
  }

  Future<void> _shareEmail() async {
    try {
      final emailContent =
          'Subject: ${_subjectController.text}\n\n${_bodyController.text}';
      final externalAppService = context.read<ExternalAppService>();
      await externalAppService.shareContent(emailContent);
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to share email: ${e.toString()}', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WriteEmailCubit, WriteEmailState>(
      listener: (context, state) {
        // Update text controllers when email is generated
        if (state.generatedSubject != null && state.generatedBody != null) {
          _subjectController.text = state.generatedSubject!;
          _bodyController.text = state.generatedBody!;
        }

        // Show error message
        if (state.error != null && mounted) {
          CustomSnack.warning(state.error!, context);
          context.read<WriteEmailCubit>().clearError();
        }
      },
      builder: (context, state) {
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
                              onPressed:
                                  state.isLoading ? null : _generateEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: state.isLoading
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

                    Gap(AppDimensions.spacing16),

                    // Generated Email Section
                    if (state.generatedSubject != null &&
                        state.generatedBody != null)
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
                            Gap(AppDimensions.spacing16),

                            // Subject
                            if (state.generatedSubject != null &&
                                state.generatedSubject!.isNotEmpty) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              Gap(AppDimensions.spacing8),
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
                              Gap(AppDimensions.spacing16),
                            ],

                            // Body
                            if (state.generatedBody != null &&
                                state.generatedBody!.isNotEmpty) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              Gap(AppDimensions.spacing8),
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
            ),
          ),
        );
      },
    );
  }
}
