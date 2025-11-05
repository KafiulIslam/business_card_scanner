import 'package:business_card_scanner/core/widgets/buttons/save_icon_button.dart';
import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/dynamic_preview_card.dart';
import '../../../../core/widgets/inputFields/card_info_field.dart';
import '../../../network/domain/entities/network_model.dart';

class EditMyCardScreen extends StatefulWidget {
  final MyCardModel card;

  const EditMyCardScreen({super.key, required this.card});

  @override
  State<EditMyCardScreen> createState() => _EditMyCardScreenState();
}

class _EditMyCardScreenState extends State<EditMyCardScreen> {
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
    _nameController = TextEditingController(text: widget.card.name ?? '');
    _jobTitleController = TextEditingController(text: widget.card.title ?? '');
    _companyController = TextEditingController(text: widget.card.company ?? '');
    _emailController = TextEditingController(text: widget.card.email ?? '');
    _phoneController = TextEditingController(text: widget.card.phone ?? '');
    _addressController = TextEditingController(text: widget.card.address ?? '');
    _websiteController = TextEditingController(text: widget.card.website ?? '');
    super.initState();
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
          _nameController.text,
          style: AppTextStyles.headline4,
        ),
        actions: [
          SaveIconButton(isLoading: false, onTap: () {}),
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
