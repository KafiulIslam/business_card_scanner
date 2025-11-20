import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../core/constants/network_constants.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/assets_path.dart';
import '../../../../core/utils/custom_snack.dart';
import '../../../../core/widgets/buttons/save_icon_button.dart';
import '../../../../core/widgets/dynamic_preview_card.dart';
import '../../../../core/widgets/inputFields/card_info_field.dart';
import '../../data/services/firebase_storage_service.dart';
import '../../domain/entities/network_model.dart';
import '../cubit/network_cubit.dart';
import '../cubit/network_state.dart';

class EditNetworkScreen extends StatefulWidget {
  final NetworkModel network;

  const EditNetworkScreen({super.key, required this.network});

  @override
  State<EditNetworkScreen> createState() => _EditNetworkScreenState();
}

class _EditNetworkScreenState extends State<EditNetworkScreen> {
  late String selectedCategory;
  late bool isCardUpdating = false;

  // Original values to compare against
  late String _originalNote;
  late String _originalName;
  late String _originalTitle;
  late String _originalCompany;
  late String _originalEmail;
  late String _originalPhone;
  late String _originalAddress;
  late String _originalWebsite;
  late String _originalCategory;

  // fields controllers
  final TextEditingController _whereYouMetController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  // Screenshot controller for capturing the card preview widget
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _updateCard(bool isManualCard) async {
    if (widget.network.cardId == null) {
      if (!mounted) return;
      CustomSnack.warning('Card ID is missing. Cannot update.', context);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      CustomSnack.warning('User not authenticated', context);
      return;
    }

    try {

      setState(() {
        isCardUpdating = true;
      });

      String? imageUrl = widget.network.imageUrl;
      //final isManualCard = widget.network.isCameraScanned == false;

      // If it's a manual card, capture screenshot and upload new image
      if (isManualCard) {
        try {
          // Wait for widget to be fully rendered before capturing
          await Future.delayed(const Duration(milliseconds: 100));
          await WidgetsBinding.instance.endOfFrame;

          // Capture the card preview widget as an image
          final imageFile = await _captureCardPreview();
          if (imageFile == null || !await imageFile.exists()) {
            if (mounted) {
              CustomSnack.warning(
                  'Failed to capture card image. Please try again.', context);
            }
            return;
          }

          // Upload new image to replace the old one (same path, overwrites)
          final storageService = context.read<FirebaseStorageService>();
          imageUrl = await storageService.updateCardImage(
            imageFile,
            widget.network.cardId!,
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Upload timeout'),
          );

          // Clean up temporary file
          try {
            await imageFile.delete();
          } catch (_) {
            // Ignore cleanup errors
          }
        } on TimeoutException {
          if (mounted) {
            CustomSnack.warning(
                'Network error: Please check your internet connection and try again',
                context);
          }
          return;
        } catch (e) {
          if (mounted) {
            CustomSnack.warning('Failed to upload image: ${e.toString()}', context);
          }
          return;
        }
      }
      // If camera scanned card, keep the same imageUrl (no change)

      // Create updated NetworkModel with all current values
      final updatedNetwork = NetworkModel(
        cardId: widget.network.cardId,
        uid: widget.network.uid,
        imageUrl: imageUrl,
        category: selectedCategory,
        note: _whereYouMetController.text.trim().isEmpty
            ? null
            : _whereYouMetController.text.trim(),
        name: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        title: _jobTitleController.text.trim().isEmpty
            ? null
            : _jobTitleController.text.trim(),
        company: _companyController.text.trim().isEmpty
            ? null
            : _companyController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        website: _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        createdAt: widget.network.createdAt,
        isCameraScanned: widget.network.isCameraScanned,
      );

      // Save to Firestore using the cubit
      await context.read<NetworkCubit>().saveNetworkCard(updatedNetwork);

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      // Fetch network list to update the cards in state
      await context.read<NetworkCubit>().fetchNetworkCards(user.uid);
      if (mounted) {
        context.go(Routes.dashboard);
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnack.warning('Failed to update network: ${e.toString()}', context);
    } finally{
      setState(() {
        isCardUpdating = false;
      });
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
        '${tempDir.path}/card_preview_${DateTime.now().millisecondsSinceEpoch}.png',
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
  void initState() {
    super.initState();
    // Store original values for comparison
    _originalNote = widget.network.note ?? '';
    _originalName = widget.network.name ?? '';
    _originalTitle = widget.network.title ?? '';
    _originalCompany = widget.network.company ?? '';
    _originalEmail = widget.network.email ?? '';
    _originalPhone = widget.network.phone ?? '';
    _originalAddress = widget.network.address ?? '';
    _originalWebsite = widget.network.website ?? '';
    _originalCategory =
        widget.network.category ?? NetworkConstants.defaultCategory;

    // Initialize controllers with network data
    _whereYouMetController.text = _originalNote;
    _nameController.text = _originalName;
    _jobTitleController.text = _originalTitle;
    _companyController.text = _originalCompany;
    _emailController.text = _originalEmail;
    _phoneController.text = _originalPhone;
    _addressController.text = _originalAddress;
    _websiteController.text = _originalWebsite;

    // Initialize category
    selectedCategory = _originalCategory;

    // Add listeners to update preview and check for changes when fields change
    _whereYouMetController.addListener(_checkForChanges);
    _nameController.addListener(_checkForChanges);
    _jobTitleController.addListener(_checkForChanges);
    _companyController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
    _addressController.addListener(_checkForChanges);
    _websiteController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      // This will trigger rebuild and check _hasChanges()
    });
  }

  bool _hasChanges() {
    // Compare current values with original values
    final currentNote = _whereYouMetController.text.trim();
    final currentName = _nameController.text.trim();
    final currentTitle = _jobTitleController.text.trim();
    final currentCompany = _companyController.text.trim();
    final currentEmail = _emailController.text.trim();
    final currentPhone = _phoneController.text.trim();
    final currentAddress = _addressController.text.trim();
    final currentWebsite = _websiteController.text.trim();

    // Check if any field has changed
    return currentNote != _originalNote ||
        currentName != _originalName ||
        currentTitle != _originalTitle ||
        currentCompany != _originalCompany ||
        currentEmail != _originalEmail ||
        currentPhone != _originalPhone ||
        currentAddress != _originalAddress ||
        currentWebsite != _originalWebsite ||
        selectedCategory != _originalCategory;
  }

  @override
  void dispose() {
    // Remove listeners before disposing controllers
    _whereYouMetController.removeListener(_checkForChanges);
    _nameController.removeListener(_checkForChanges);
    _jobTitleController.removeListener(_checkForChanges);
    _companyController.removeListener(_checkForChanges);
    _emailController.removeListener(_checkForChanges);
    _phoneController.removeListener(_checkForChanges);
    _addressController.removeListener(_checkForChanges);
    _websiteController.removeListener(_checkForChanges);

    // Dispose controllers
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
          _nameController.text.isEmpty ? 'Edit Network' : _nameController.text,
          style: AppTextStyles.headline4,
        ),
        actions: [
          BlocBuilder<NetworkCubit, NetworkState>(
            builder: (context, state) {
              return SaveIconButton(
                  isLoading: isCardUpdating,
                  isEnabled: _hasChanges(),
                  onTap: () async {
                    if (!isCardUpdating && _hasChanges()) {
                      await _updateCard(true);
                    }
                  });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Preview Section
            DynamicPreviewCard(
                screenshotController: _screenshotController,
                network: NetworkModel(
                    imageUrl: widget.network.isCameraScanned == true
                        ? widget.network.imageUrl ?? AssetsPath.manualCardBg
                        : AssetsPath.manualCardBg,
                    name: _nameController.text,
                    title: _jobTitleController.text,
                    company: _companyController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    email: _emailController.text,
                    website: _websiteController.text)),
            Gap(AppDimensions.spacing16),

            // Category Dropdown
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              child: _buildCategoryDropdown(),
            ),
            Gap(AppDimensions.spacing16),

            // Extracted Information Fields
            _buildExtractedFields(),
            Gap(AppDimensions.spacing48 * 2), // Space for bottom buttons
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radius32),
          color: AppColors.primaryLight.withOpacity(0.2)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          onChanged: (value) {
            setState(() {
              selectedCategory = value ?? '';
              // This will trigger _checkForChanges through setState
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
