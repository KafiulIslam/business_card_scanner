import 'dart:io';
import 'package:business_card_scanner/core/routes/routes.dart';
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/widgets/buttons/save_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:screenshot/screenshot.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/network_source_type.dart';
import '../../../../core/widgets/dynamic_preview_card.dart';
import '../../../../core/widgets/inputFields/card_info_field.dart';
import '../../../network/domain/entities/network_model.dart';
import '../../domain/entities/my_card_model.dart';
import '../../presentation/cubit/my_card_cubit.dart';
import '../../presentation/cubit/my_card_state.dart';
import '../../../network/data/services/firebase_storage_service.dart';

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

  // Company logo state
  File? _selectedLogoFile;

  Future<void> _pickCompanyLogo() async {
    try {
      final externalAppService = context.read<ExternalAppService>();
      final imageFile = await externalAppService.pickImage(ImageSource.gallery);

      if (imageFile != null && mounted) {
        setState(() {
          _selectedLogoFile = imageFile;
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to pick image: $e', context);
      }
    }
  }

  Future<void> _saveMyCard() async {
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
      // Don't reset here - it clears the cards. Just set loading state
      cubit.setLoading(true);

      // Generate card ID
      final cardId = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload company logo if selected
      String? logoUrl;
      if (_selectedLogoFile != null) {
        final storageService = FirebaseStorageService();
        logoUrl =
            await storageService.uploadCompanyLogo(_selectedLogoFile!, cardId);
      }

      // Create and save my card using widget.imagePath directly as imageUrl
      final myCard = MyCardModel(
        cardId: cardId,
        uid: user.uid,
        imageUrl: widget.imagePath,
        name: _nameController.text,
        title: _jobTitleController.text,
        company: _companyController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        website: _websiteController.text,
        logoUrl: logoUrl,
        createdAt: DateTime.now(),
        isCameraScanned: false,
      );

      await cubit.saveMyCard(myCard, setLoadingState: false);
      // Fetch cards to update the state before navigating back
      await cubit.fetchMyCards(user.uid);

      if (mounted) {
        context.go(
          Routes.dashboard,
          extra: 1,
        );
        CustomSnack.success('Your card is saved successfully!', context);
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
          BlocBuilder<MyCardCubit, MyCardState>(
            builder: (context, state) {
              return SaveIconButton(
                  isLoading: state.isLoading,
                  isEnabled: _nameController.text.isEmpty ? false : true,
                  onTap: () {
                    if (_nameController.text.isNotEmpty &&
                        _jobTitleController.text.isNotEmpty &&
                        _companyController.text.isNotEmpty) {
                      if (!state.isLoading) {
                        _saveMyCard();
                      }
                    } else {
                      CustomSnack.warning(
                          'Please enter name, title, company name & all available information!',
                          context);
                    }
                  });
            },
          ),
          const Gap(16),
        ],
      ),
      body: Column(
        children: [
          // Card Preview Section - Fixed at top
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
                website: _websiteController.text,
                sourceType: NetworkSourceType.manual),
            isEditable: true,
            imagePath: _selectedLogoFile,
          ),
          // Scrollable fields section - takes remaining space
          Expanded(
            child: _buildExtractedFields(),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedFields() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Gap(AppDimensions.spacing16),
          // Company logo picker
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _pickCompanyLogo,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.gray300,
                        width: 1,
                      ),
                    ),
                    child: _selectedLogoFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedLogoFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: AppColors.gray400,
                              ),
                              Gap(AppDimensions.spacing8),
                              Text(
                                'Tap to add company logo',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                if (_selectedLogoFile != null) ...[
                  Gap(AppDimensions.spacing8),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLogoFile = null;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.red,
                        ),
                        const Gap(4),
                        Text(
                          'Remove logo',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          //name
          CardInfoField(
            icon: Icons.person_outline,
            controller: _nameController,
            hint: 'Name',
            onChanged: (value) {
              setState(() {});
            },
          ),

          // title
          CardInfoField(
            icon: Icons.work,
            controller: _jobTitleController,
            hint: 'Job Title',
            onChanged: (value) {
              setState(() {});
            },
          ),

          // company name
          CardInfoField(
            icon: Icons.domain,
            controller: _companyController,
            hint: 'Company',
            onChanged: (value) {
              setState(() {});
            },
          ),

          // phone
          CardInfoField(
            icon: Icons.phone_outlined,
            controller: _phoneController,
            hint: 'Phone',
            onChanged: (value) {
              setState(() {});
            },
          ),

          //email
          CardInfoField(
            icon: Icons.email_outlined,
            controller: _emailController,
            hint: 'Email',
            onChanged: (value) {
              setState(() {});
            },
          ),

          //website
          CardInfoField(
            icon: Icons.language_outlined,
            controller: _websiteController,
            hint: 'Website',
            onChanged: (value) {
              setState(() {});
            },
          ),

          // address
          CardInfoField(
            icon: Icons.location_on_outlined,
            controller: _addressController,
            hint: 'Address',
            onChanged: (value) {
              setState(() {});
            },
          ),

          Gap(AppDimensions.spacing48), // Space for bottom buttons
        ],
      ),
    );
  }
}
