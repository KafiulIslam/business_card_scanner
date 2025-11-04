import 'dart:async';
import 'dart:io';
import 'package:business_card_scanner/core/widgets/buttons/save_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:screenshot/screenshot.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/dynamic_preview_card.dart';
import '../../../../core/widgets/inputFields/card_info_field.dart';
import '../../../network/domain/entities/network_model.dart';
import '../../../network/data/services/firebase_storage_service.dart';
import '../../domain/entities/my_card_model.dart';
import '../../presentation/cubit/my_card_cubit.dart';
import '../../presentation/cubit/my_card_state.dart';

class EditTemplateDetails extends StatefulWidget {
  final String imagePath;

  const EditTemplateDetails({super.key, required this.imagePath});

  @override
  State<EditTemplateDetails> createState() => _EditTemplateDetailsState();
}

class _EditTemplateDetailsState extends State<EditTemplateDetails> {
  // fields controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  // Screenshot controller for capturing the card preview widget
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _saveCard() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnack.warning('Please login to save cards', context);
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      CustomSnack.warning('Please enter a name', context);
      return;
    }

    final cubit = context.read<MyCardCubit>();

    try {
      cubit.reset();
      cubit.setLoading(true);

      // Wait for widget to be fully rendered before capturing
      await Future.delayed(const Duration(milliseconds: 100));
      await WidgetsBinding.instance.endOfFrame;

      // Capture the card preview widget as an image
      final imageFile = await _captureCardPreview();
      if (imageFile == null || !await imageFile.exists()) {
        cubit.setLoading(false);
        if (mounted) {
          CustomSnack.warning(
              'Failed to capture card image. Please try again.', context);
        }
        return;
      }

      // Generate card ID and upload image
      final cardId = DateTime.now().millisecondsSinceEpoch.toString();
      final storageService = context.read<FirebaseStorageService>();

      final imageUrl =
          await storageService.uploadMyCardImage(imageFile, cardId).timeout(
                const Duration(seconds: 30),
                onTimeout: () => throw TimeoutException('Upload timeout'),
              );

      // Create and save my card
      final myCard = MyCardModel(
        cardId: cardId,
        uid: user.uid,
        imageUrl: imageUrl,
        name: _nameController.text,
        title: _jobTitleController.text,
        company: _companyController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        website: _websiteController.text,
        createdAt: DateTime.now(),
        isCameraScanned: false,
      );

      await cubit.saveMyCard(myCard, setLoadingState: false);
      await cubit.fetchMyCards(user.uid);

      // Clean up temporary file
      try {
        await imageFile.delete();
      } catch (_) {}
    } on TimeoutException {
      cubit.setLoading(false);
      if (mounted) {
        CustomSnack.warning(
            'Network error: Please check your internet connection and try again',
            context);
      }
    } catch (e) {
      cubit.setLoading(false);
      if (mounted) {
        final errorMsg = e.toString().toLowerCase();
        if (errorMsg.contains('network') ||
            errorMsg.contains('timeout') ||
            errorMsg.contains('unavailable')) {
          CustomSnack.warning(
              'Network error: Please check your internet connection and try again',
              context);
        } else {
          CustomSnack.warning('Failed to save card: ${e.toString()}', context);
        }
      }
    }
  }

  /// Captures the card preview widget as an image file
  Future<File?> _captureCardPreview() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 200),
        pixelRatio: 2.0,
      );

      if (imageBytes == null || imageBytes.isEmpty) {
        return null;
      }

      final tempDir = Directory.systemTemp;
      if (!await tempDir.exists()) {
        await tempDir.create(recursive: true);
      }

      final imageFile = File(
        '${tempDir.path}/my_card_preview_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await imageFile.writeAsBytes(imageBytes);

      // Verify file was created and has content
      if (!await imageFile.exists() || await imageFile.length() == 0) {
        return null;
      }

      return imageFile;
    } catch (e) {
      debugPrint('Error capturing card preview: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Details',
          style: AppTextStyles.headline4,
        ),
        actions: [
          BlocListener<MyCardCubit, MyCardState>(
            listenWhen: (prev, curr) =>
                prev.isSuccess != curr.isSuccess || prev.error != curr.error,
            listener: (context, state) {
              if (state.isSuccess) {
                CustomSnack.success('Card saved successfully', context);
                context.read<MyCardCubit>().reset();
                context.pop();
              } else if (state.error != null) {
                CustomSnack.warning(state.error!, context);
                context.read<MyCardCubit>().reset();
              }
            },
            child: BlocBuilder<MyCardCubit, MyCardState>(
              builder: (context, state) {
                return SaveIconButton(
                    isLoading: state.isLoading,
                    onTap: () {
                      if (_nameController.text.isNotEmpty &&
                          _jobTitleController.text.isNotEmpty &&
                          _companyController.text.isNotEmpty) {
                        if (!state.isLoading) {
                          _saveCard();
                        }
                      } else {
                        CustomSnack.warning(
                            'Please enter name, title, company name & all available information!',
                            context);
                      }
                    });
              },
            ),
          ),
          const Gap(16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card Preview Section
            DynamicPreviewCard(
                screenshotController: _screenshotController,
                network: NetworkModel(
                    imageUrl: widget.imagePath,
                    name: _nameController.text,
                    title: _jobTitleController.text,
                    company: _companyController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    email: _emailController.text,
                    website: _websiteController.text)),
            Gap(AppDimensions.spacing16),
            _buildExtractedFields(),
            Gap(AppDimensions.spacing48 * 2), // Space for bottom buttons
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedFields() {
    return Column(
      children: [
        CardInfoField(
          icon: Icons.person_outline,
          controller: _nameController,
          hint: 'Name',
          onChanged: (value) {
            setState(() {});
          },
        ),
        CardInfoField(
          icon: Icons.work,
          controller: _jobTitleController,
          hint: 'Job Title',
          onChanged: (value) {
            setState(() {});
          },
        ),
        CardInfoField(
          icon: Icons.domain,
          controller: _companyController,
          hint: 'Company',
          onChanged: (value) {
            setState(() {});
          },
        ),
        CardInfoField(
          icon: Icons.email_outlined,
          controller: _emailController,
          hint: 'Email',
          onChanged: (value) {
            setState(() {});
          },
        ),
        CardInfoField(
          icon: Icons.phone_outlined,
          controller: _phoneController,
          hint: 'Phone',
          onChanged: (value) {
            setState(() {});
          },
        ),
        CardInfoField(
          icon: Icons.location_on_outlined,
          controller: _addressController,
          hint: 'Address',
          onChanged: (value) {
            setState(() {});
          },
        ),
        CardInfoField(
          icon: Icons.language_outlined,
          controller: _websiteController,
          hint: 'Website',
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }
}
