import 'dart:io';
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
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_cubit.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_state.dart';
import 'package:business_card_scanner/features/network/data/services/firebase_storage_service.dart';
import '../../../../core/widgets/inputFields/card_info_field.dart';

class ScanResultScreen extends StatefulWidget {
  final String rawText;
  final Map<String, String?> extracted;
  final File? imageFile;
  final bool isCameraScanned;

  const ScanResultScreen({
    super.key,
    required this.rawText,
    required this.extracted,
    this.imageFile,
    this.isCameraScanned = false,
  });

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  late String selectedCategory = NetworkConstants.defaultCategory;
  String? selectedTag = NetworkConstants.defaultTag;

  // field controllers
  late final TextEditingController _whereYouMetController;
  late final TextEditingController _nameController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _companyController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _websiteController;

  // upload data to firestore network collection
  Future<void> _saveCard() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnack.warning('Please login to save cards', context);
      return;
    }

    if (widget.imageFile == null) {
      CustomSnack.warning('Image file is missing', context);
      return;
    }

    final cubit = context.read<NetworkCubit>();

    try {
      // Reset state and set loading immediately so loader shows
      cubit.reset();
      cubit.setLoading(true);

      // Generate card ID
      final cardId = DateTime.now().millisecondsSinceEpoch.toString();

      // First, upload the image to Firebase Storage
      final storageService = context.read<FirebaseStorageService>();
      String imageUrl = '';

      try {
        imageUrl =
            await storageService.uploadCardImage(widget.imageFile!, cardId);
      } catch (e) {
        cubit.setLoading(false);
        if (mounted) {
          CustomSnack.warning('Failed to upload image: $e', context);
        }
        return;
      }

      // Create NetworkModel entity with uploaded image URL and createdAt
      final networkCard = NetworkModel(
        cardId: cardId,
        uid: user.uid,
        imageUrl: imageUrl,
        category: selectedCategory,
        note: _whereYouMetController.text,
        name: _nameController.text,
        title: _jobTitleController.text,
        company: _companyController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        website: _websiteController.text,
        createdAt: DateTime.now(),
        isCameraScanned: widget.isCameraScanned,
      );

      // Save to Firestore - this will emit success state
      // Don't set loading state again since we're already managing it
      await cubit.saveNetworkCard(networkCard, setLoadingState: false);
      await cubit.fetchNetworkCards(user.uid);
    } catch (e) {
      cubit.setLoading(false);
      if (mounted) {
        CustomSnack.warning('Failed to save card: $e', context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _whereYouMetController = TextEditingController();
    _nameController =
        TextEditingController(text: widget.extracted['name'] ?? '');
    _jobTitleController =
        TextEditingController(text: widget.extracted['jobTitle'] ?? '');
    _companyController =
        TextEditingController(text: widget.extracted['company'] ?? '');
    _emailController =
        TextEditingController(text: widget.extracted['email'] ?? '');
    _phoneController =
        TextEditingController(text: widget.extracted['phone'] ?? '');
    _addressController =
        TextEditingController(text: widget.extracted['address'] ?? '');
    _websiteController =
        TextEditingController(text: widget.extracted['website'] ?? '');
  }

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
          'Scanned Details',
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
                  onTap: state.isLoading ? null : _saveCard,
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
      child: SizedBox(
        height: 200.h,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          child: Image.file(
            widget.imageFile ?? File(''),
            fit: BoxFit.cover,
            // helpful guards
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
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

  Widget _buildTagsRow() {
    return Row(
      children: [
        _buildTag('Prospects', isSelected: selectedTag == 'Prospects'),
        Gap(AppDimensions.spacing8),
        _buildTag('Leads', isSelected: selectedTag == 'Leads'),
        Gap(AppDimensions.spacing8),
        _buildTag('Conferences', isSelected: selectedTag == 'Conferences'),
        const Spacer(),
        Container(
          padding: EdgeInsets.all(AppDimensions.spacing8),
          decoration: BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildTag(String label, {required bool isSelected}) {
    return InkWell(
      onTap: () => setState(() => selectedTag = label),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryLight.withOpacity(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radius20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.gray300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 16,
              color: isSelected ? AppColors.secondary : AppColors.gray400,
            ),
            Gap(AppDimensions.spacing4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.secondary : AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedFields() {
    return Column(
      children: [
        CardInfoField(
            icon: Icons.description_outlined,
            controller: _whereYouMetController,
            hint: 'Where you met?'),
        CardInfoField(
          icon: Icons.person_outline,
          controller: _nameController,
          hint: 'Name',
        ),
        CardInfoField(
          icon: Icons.work,
          controller: _jobTitleController,
          hint: 'Job Title',
        ),
        CardInfoField(
          icon: Icons.domain,
          controller: _companyController,
          hint: 'Company',
        ),
        CardInfoField(
          icon: Icons.email_outlined,
          controller: _emailController,
          hint: 'Email',
        ),
        CardInfoField(
          icon: Icons.phone_outlined,
          controller: _phoneController,
          hint: 'Phone',
        ),
        CardInfoField(
          icon: Icons.location_on_outlined,
          controller: _addressController,
          hint: 'Address',
        ),
        CardInfoField(
          icon: Icons.language_outlined,
          controller: _websiteController,
          hint: 'Website',
        ),
      ],
    );
  }

}
