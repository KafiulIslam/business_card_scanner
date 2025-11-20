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
  String? selectedTag = NetworkConstants.defaultTag;

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


  void _saveCard() {
    if (widget.network.cardId == null) {
      CustomSnack.warning('Card ID is missing. Cannot update.', context);
      return;
    }

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
      createdAt: widget.network.createdAt, // Preserve original creation date
      isCameraScanned: widget.network.isCameraScanned,
    );

    // Save to Firestore using the cubit
    context.read<NetworkCubit>().saveNetworkCard(updatedNetwork);
  }


  @override
  void initState() {
    super.initState();
    // Initialize controllers with network data
    _whereYouMetController.text = widget.network.note ?? '';
    _nameController.text = widget.network.name ?? '';
    _jobTitleController.text = widget.network.title ?? '';
    _companyController.text = widget.network.company ?? '';
    _emailController.text = widget.network.email ?? '';
    _phoneController.text = widget.network.phone ?? '';
    _addressController.text = widget.network.address ?? '';
    _websiteController.text = widget.network.website ?? '';

    // Initialize category
    selectedCategory = widget.network.category ?? NetworkConstants.defaultCategory;

    // Add listeners to update preview when fields change
    _nameController.addListener(_updatePreview);
    _jobTitleController.addListener(_updatePreview);
    _companyController.addListener(_updatePreview);
    _emailController.addListener(_updatePreview);
    _phoneController.addListener(_updatePreview);
    _addressController.addListener(_updatePreview);
    _websiteController.addListener(_updatePreview);
  }

  void _updatePreview() {
    setState(() {});
  }

  @override
  void dispose() {
    // Remove listeners before disposing controllers
    _nameController.removeListener(_updatePreview);
    _jobTitleController.removeListener(_updatePreview);
    _companyController.removeListener(_updatePreview);
    _emailController.removeListener(_updatePreview);
    _phoneController.removeListener(_updatePreview);
    _addressController.removeListener(_updatePreview);
    _websiteController.removeListener(_updatePreview);

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
                prev.isSuccess != curr.isSuccess || prev.error != curr.error,
            listener: (context, state) {
              if (state.isSuccess) {
                CustomSnack.success('Network updated successfully', context);
                context.read<NetworkCubit>().reset();
                context.pop();
              } else if (state.error != null) {
                CustomSnack.warning(state.error!, context);
                context.read<NetworkCubit>().reset();
              }
            },
            child: BlocBuilder<NetworkCubit, NetworkState>(
              builder: (context, state) {
                return SaveIconButton(
                    isLoading: state.isLoading,
                    onTap: () {
                      if (!state.isLoading) {
                        _saveCard();
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
        CardInfoField(
            icon: Icons.description_outlined,
            controller: _whereYouMetController,
            hint: 'Where you met?'),
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
