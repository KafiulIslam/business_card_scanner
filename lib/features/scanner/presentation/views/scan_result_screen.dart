import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';

class ScanResultScreen extends StatefulWidget {
  final String rawText;
  final Map<String, String?> extracted;
  final File? imageFile;

  const ScanResultScreen({
    super.key,
    required this.rawText,
    required this.extracted,
    this.imageFile,
  });

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  late String selectedCategory = 'General';
  String? selectedTag = 'Prospects';
  late final TextEditingController _whereYouMetController;
  late final TextEditingController _nameController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _companyController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _websiteController;

  final List<String> categories = [
    'General',
    'Prospect',
    'Trial',
    'Customer',
    'Inactive',
    'Lead',
    'Partner'
  ];

  @override
  void initState() {
    super.initState();
    _whereYouMetController = TextEditingController();
    _nameController = TextEditingController(text: widget.extracted['name'] ?? '');
    _jobTitleController = TextEditingController(text: widget.extracted['jobTitle'] ?? '');
    _companyController = TextEditingController(text: widget.extracted['company'] ?? '');
    _emailController = TextEditingController(text: widget.extracted['email'] ?? '');
    _phoneController = TextEditingController(text: widget.extracted['phone'] ?? '');
    _addressController = TextEditingController(text: widget.extracted['address'] ?? '');
    _websiteController = TextEditingController(text: widget.extracted['website'] ?? '');
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
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: Text(
          'Scanned Details',
          style: AppTextStyles.headline4,
        ),
        actions: const [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          Gap(16)
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
          items: categories.map((String value) {
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
          label: 'Job Title',
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

  Widget _buildHighlightedText(String text, String? highlightText) {
    if (highlightText == null || !text.contains(highlightText)) {
      return Text(text, style: AppTextStyles.bodyMedium);
    }

    final parts = text.split(highlightText);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: parts[0], style: AppTextStyles.bodyMedium),
          TextSpan(
            text: highlightText,
            style: AppTextStyles.bodyMedium.copyWith(
              backgroundColor: AppColors.success.withOpacity(0.3),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (parts.length > 1)
            TextSpan(text: parts[1], style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
