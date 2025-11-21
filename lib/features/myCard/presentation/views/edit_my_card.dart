import 'package:business_card_scanner/core/constants/network_source_type.dart';
import 'package:business_card_scanner/core/widgets/buttons/save_icon_button.dart';
import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/custom_snack.dart';
import '../../../../core/widgets/dynamic_preview_card.dart';
import '../../../../core/widgets/inputFields/card_info_field.dart';
import '../../../network/domain/entities/network_model.dart';
import '../../presentation/cubit/my_card_cubit.dart';
import '../../presentation/cubit/my_card_state.dart';

class EditMyCardScreen extends StatefulWidget {
  final MyCardModel card;

  const EditMyCardScreen({super.key, required this.card});

  @override
  State<EditMyCardScreen> createState() => _EditMyCardScreenState();
}

class _EditMyCardScreenState extends State<EditMyCardScreen> {
  late bool isCardUpdating = false;

  // Original values to compare against
  late String _originalName;
  late String _originalTitle;
  late String _originalCompany;
  late String _originalEmail;
  late String _originalPhone;
  late String _originalAddress;
  late String _originalWebsite;

  // fields controllers
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;

  // Screenshot controller for capturing the card preview widget
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    // Store original values for comparison
    _originalName = widget.card.name ?? '';
    _originalTitle = widget.card.title ?? '';
    _originalCompany = widget.card.company ?? '';
    _originalEmail = widget.card.email ?? '';
    _originalPhone = widget.card.phone ?? '';
    _originalAddress = widget.card.address ?? '';
    _originalWebsite = widget.card.website ?? '';

    // Initialize controllers with card data
    _nameController = TextEditingController(text: _originalName);
    _jobTitleController = TextEditingController(text: _originalTitle);
    _companyController = TextEditingController(text: _originalCompany);
    _emailController = TextEditingController(text: _originalEmail);
    _phoneController = TextEditingController(text: _originalPhone);
    _addressController = TextEditingController(text: _originalAddress);
    _websiteController = TextEditingController(text: _originalWebsite);

    // Add listeners to check for changes when fields change
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
    final currentName = _nameController.text.trim();
    final currentTitle = _jobTitleController.text.trim();
    final currentCompany = _companyController.text.trim();
    final currentEmail = _emailController.text.trim();
    final currentPhone = _phoneController.text.trim();
    final currentAddress = _addressController.text.trim();
    final currentWebsite = _websiteController.text.trim();

    // Check if any field has changed
    return currentName != _originalName ||
        currentTitle != _originalTitle ||
        currentCompany != _originalCompany ||
        currentEmail != _originalEmail ||
        currentPhone != _originalPhone ||
        currentAddress != _originalAddress ||
        currentWebsite != _originalWebsite;
  }

  Future<void> _updateCard() async {
    if (widget.card.cardId == null) {
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

      // Create updated MyCardModel with all current values
      final updatedCard = MyCardModel(
        cardId: widget.card.cardId,
        uid: widget.card.uid,
        imageUrl: widget.card.imageUrl,
        category: widget.card.category,
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
        createdAt: widget.card.createdAt,
        isCameraScanned: widget.card.isCameraScanned,
      );

      // Update document in Firestore using the cubit with documentId
      await context
          .read<MyCardCubit>()
          .updateMyCard(widget.card.cardId!, updatedCard);

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      // Fetch my cards list to update the cards in state
      await context.read<MyCardCubit>().fetchMyCards(user.uid);
      if (mounted) {
        context.go(Routes.dashboard, extra: 1);
        CustomSnack.success('Card updated successfully!', context);
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnack.warning('Failed to update card: ${e.toString()}', context);
    } finally {
      setState(() {
        isCardUpdating = false;
      });
    }
  }

  @override
  void dispose() {
    // Remove listeners before disposing controllers
    _nameController.removeListener(_checkForChanges);
    _jobTitleController.removeListener(_checkForChanges);
    _companyController.removeListener(_checkForChanges);
    _emailController.removeListener(_checkForChanges);
    _phoneController.removeListener(_checkForChanges);
    _addressController.removeListener(_checkForChanges);
    _websiteController.removeListener(_checkForChanges);

    // Dispose controllers
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
          _nameController.text,
          style: AppTextStyles.headline4,
        ),
        actions: [
          BlocBuilder<MyCardCubit, MyCardState>(
            builder: (context, state) {
              return SaveIconButton(
                isLoading: isCardUpdating,
                isEnabled: _hasChanges(),
                onTap: () async {
                  if (!isCardUpdating && _hasChanges()) {
                    await _updateCard();
                  }
                },
              );
            },
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
                    imageUrl: widget.card.imageUrl,
                    name: _nameController.text,
                    title: _jobTitleController.text,
                    company: _companyController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    email: _emailController.text,
                    website: _websiteController.text,
                    sourceType: NetworkSourceType.manual)),
            Gap(AppDimensions.spacing16),
            _buildExtractedFields(),
            Gap(AppDimensions.spacing48), // Space for bottom buttons
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
