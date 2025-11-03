import 'dart:io';
import 'package:business_card_scanner/core/theme/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/constants/network_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_card.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_cubit.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_state.dart';
import 'package:business_card_scanner/features/network/data/services/firebase_storage_service.dart';
import '../../../../core/utils/assets_path.dart';

class CreateCardManuallyScreen extends StatefulWidget {
  const CreateCardManuallyScreen({super.key});

  @override
  State<CreateCardManuallyScreen> createState() =>
      _CreateCardManuallyScreenState();
}

class _CreateCardManuallyScreenState extends State<CreateCardManuallyScreen> {
  late String selectedCategory = NetworkConstants.defaultCategory;
  String? selectedTag = NetworkConstants.defaultTag;
  final TextEditingController _whereYouMetController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void dispose() {
    _whereYouMetController.dispose();
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
      appBar: AppBar(
        title: Text(
          'Create Manually',
          style: AppTextStyles.headline4,
        ),
        actions: [
          BlocListener<NetworkCubit, NetworkState>(
            listenWhen: (prev, curr) =>
                prev.isSuccess != curr.isSuccess || prev.error != curr.error,
            listener: (context, state) {
              if (state.isSuccess) {
                CustomSnack.success('Card saved successfully', context);
                context.read<NetworkCubit>().reset();
                context.pop(); // Use go_router's context.pop()
              } else if (state.error != null) {
                CustomSnack.warning(state.error!, context);
                context.read<NetworkCubit>().reset();
              }
            },
            child: BlocBuilder<NetworkCubit, NetworkState>(
              builder: (context, state) {
                return InkWell(
                  // onTap: state.isLoading ? null : _saveCard,
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: state.isLoading
                          ? AppColors.gray400
                          : AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius8),
                    ),
                    child: state.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.save_as_outlined,
                            color: Colors.white,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Preview Section
            _buildCardPreview(),
            Gap(AppDimensions.spacing16),

            // Category Dropdown
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              child: _buildCategoryDropdown(),
            ),
            Gap(AppDimensions.spacing16),

            // Tags Row
            // Padding(
            //   padding:
            //       EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
            //   child: _buildTagsRow(),
            // ),
            // Gap(AppDimensions.spacing24),

            // Extracted Information Fields
            _buildExtractedFields(),
            Gap(AppDimensions.spacing48 * 2), // Space for bottom buttons
          ],
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(AssetsPath.manualCardBg), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kafiul Islam',
                style: AppTextStyles.headline1
                    .copyWith(fontSize: 16, color: Colors.white),
              ),
              Text(
                'CEO & Founder',
                style: AppTextStyles.headline3
                    .copyWith(fontSize: 14, color: Colors.white),
              ),
              const Spacer(),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardInfoTile(Icons.phone, '+01628924397'),
                      const Gap(2),
                      _cardInfoTile(
                          Icons.location_on_outlined, 'Bogura, Rajshahi'),
                      const Gap(2),
                      _cardInfoTile(Icons.email, 'kafiulislam@gmail.com'),
                      const Gap(2),
                      _cardInfoTile(Icons.language_outlined, 'codertent.com'),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const Icon(
                        Icons.domain,
                        color: Colors.white,
                        size: 48,
                      ),
                      Text(
                        'CoderTent',
                        style: AppTextStyles.headline1
                            .copyWith(fontSize: 16, color: Colors.white),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radius32),
          color: AppColors.primaryLight.withOpacity(0.2)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          onChanged: (value) {
            setState(() {
              selectedCategory = value ?? '';
            });
          },
          iconEnabledColor: AppColors.primary,
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
          items: NetworkConstants.categories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExtractedFields() {
    return Column(
      children: [
        _buildField(
          icon: Icons.description_outlined,
          label: 'Where you met?',
          controllerValue: _whereYouMetController,
          hint: 'Where you met?',
        ),
        _buildField(
          icon: Icons.person_outline,
          label: 'Name',
          controllerValue: _nameController,
          hint: 'Name',
        ),
        _buildField(
          icon: Icons.work,
          label: 'Title',
          controllerValue: _jobTitleController,
          hint: 'Job Title',
        ),
        _buildField(
          icon: Icons.domain,
          label: 'Company',
          controllerValue: _companyController,
          hint: 'Company',
        ),
        _buildField(
          icon: Icons.email_outlined,
          label: 'Email',
          controllerValue: _emailController,
          hint: 'Email',
        ),
        _buildField(
          icon: Icons.phone_outlined,
          label: 'Phone',
          controllerValue: _phoneController,
          hint: 'Phone',
        ),
        _buildField(
          icon: Icons.location_on_outlined,
          label: 'Address',
          controllerValue: _addressController,
          hint: 'Address',
        ),
        _buildField(
          icon: Icons.language_outlined,
          label: 'Website',
          controllerValue: _websiteController,
          hint: 'Website',
        ),
      ],
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required TextEditingController controllerValue,
    String? hint,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.spacing8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          Gap(AppDimensions.spacing12),
          Expanded(
            child: TextField(
              controller: controllerValue,
              cursorColor: AppColors.primary,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.black),
              decoration: InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                hintText: hint,
                hintStyle: AppTextStyles.hintText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardInfoTile(IconData icon, String info) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
        const Gap(8),
        Text(
          info,
          style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
        )
      ],
    );
  }

// Future<void> _saveCard() async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     CustomSnack.warning('Please login to save cards', context);
//     return;
//   }
//
//   if (widget.imageFile == null) {
//     CustomSnack.warning('Image file is missing', context);
//     return;
//   }
//
//   final cubit = context.read<NetworkCubit>();
//
//   try {
//     // Reset state and set loading immediately so loader shows
//     cubit.reset();
//     cubit.setLoading(true);
//
//     // Generate card ID
//     final cardId = DateTime.now().millisecondsSinceEpoch.toString();
//
//     // First, upload the image to Firebase Storage
//     final storageService = context.read<FirebaseStorageService>();
//     String imageUrl = '';
//
//     try {
//       imageUrl =
//           await storageService.uploadCardImage(widget.imageFile!, cardId);
//     } catch (e) {
//       cubit.setLoading(false);
//       if (mounted) {
//         CustomSnack.warning('Failed to upload image: $e', context);
//       }
//       return;
//     }
//
//     // Create NetworkCard entity with uploaded image URL and createdAt
//     final networkCard = NetworkCard(
//       cardId: cardId,
//       uid: user.uid,
//       imageUrl: imageUrl,
//       category: selectedCategory,
//       note: _whereYouMetController.text,
//       name: _nameController.text,
//       title: _jobTitleController.text,
//       company: _companyController.text,
//       email: _emailController.text,
//       phone: _phoneController.text,
//       address: _addressController.text,
//       website: _websiteController.text,
//       createdAt: DateTime.now(), // Set current date time
//     );
//
//     // Save to Firestore - this will emit success state
//     // Don't set loading state again since we're already managing it
//     await cubit.saveNetworkCard(networkCard, setLoadingState: false);
//     // final user = FirebaseAuth.instance.currentUser;
//     await cubit.fetchNetworkCards(user.uid);
//   } catch (e) {
//     cubit.setLoading(false);
//     if (mounted) {
//       CustomSnack.warning('Failed to save card: $e', context);
//     }
//   }
// }
}
