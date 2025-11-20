import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../core/constants/network_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/assets_path.dart';
import '../../../../core/utils/custom_snack.dart';
import '../../../../core/widgets/buttons/save_icon_button.dart';
import '../../../../core/widgets/dynamic_preview_card.dart';
import '../../../../core/widgets/inputFields/card_info_field.dart';
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

  Future<void> _updateCard() async {
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
      // Create updated NetworkModel with all current values
      final updatedNetwork = NetworkModel(
        cardId: widget.network.cardId,
        uid: widget.network.uid,
        imageUrl: widget.network.imageUrl,
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

      // Save to Firestore using the cubit (this will set isSuccess: true)
      await context.read<NetworkCubit>().saveNetworkCard(updatedNetwork);

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      // Fetch network list to update the cards in state
      await context.read<NetworkCubit>().fetchNetworkCards(user.uid);
    } catch (e) {
      if (!mounted) return;
      CustomSnack.warning('Failed to update network: ${e.toString()}', context);
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
          BlocListener<NetworkCubit, NetworkState>(
            listenWhen: (prev, curr) =>
                (prev.isLoading && !curr.isLoading && curr.isSuccess) ||
                (prev.error != curr.error && curr.error != null),
            listener: (context, state) {
              // Only trigger after loading completes (after fetchNetworkCards)
              if (!state.isLoading && state.isSuccess && state.cards.isNotEmpty) {
                CustomSnack.success('Card is updated successfully', context);
                context.read<NetworkCubit>().clearFlags();
                if (mounted) {
                  context.pop();
                }
              } else if (state.error != null) {
                CustomSnack.warning(state.error!, context);
                context.read<NetworkCubit>().clearFlags();
              }
            },
            child: BlocBuilder<NetworkCubit, NetworkState>(
              builder: (context, state) {
                return SaveIconButton(
                    isLoading: state.isLoading,
                    isEnabled: _hasChanges(),
                    onTap: () async {
                      if (!state.isLoading && _hasChanges()) {
                        await _updateCard();
                      }
                    });
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
            DynamicPreviewCard(
                screenshotController: _screenshotController,
                network: NetworkModel(
                    imageUrl: AssetsPath.manualCardBg,
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
