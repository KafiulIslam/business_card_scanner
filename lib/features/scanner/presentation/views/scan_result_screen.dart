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
  String? selectedCategory = 'General';
  String? selectedTag = 'Prospects';
  final TextEditingController _whereYouMetController = TextEditingController();

  @override
  void dispose() {
    _whereYouMetController.dispose();
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
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              child: _buildTagsRow(),
            ),
            Gap(AppDimensions.spacing24),

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
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedCategory!,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: AppColors.secondary),
        ],
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
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing8),
      child: Column(
        children: [
          _buildField(
            icon: Icons.description_outlined,
            label: 'Where you met?',
            controllerValue: _whereYouMetController,
            hint: 'Where you met? there interest etc....',
            isEditable: true,
          ),
          _buildField(
            icon: Icons.person_outline,
            label: 'Name',
            textValue: widget.extracted['name'] ?? '',
          ),
          _buildField(
            icon: Icons.business_outlined,
            label: 'Job Title',
            textValue: widget.extracted['jobTitle'] ?? '',
            highlightText: 'Manager',
          ),
          _buildField(
            icon: Icons.domain_outlined,
            label: 'Company',
            textValue: widget.extracted['company'] ?? '',
          ),
          _buildField(
            icon: Icons.email_outlined,
            label: 'Email',
            textValue: widget.extracted['email'] ?? 'abc@xyz.com',
            showAddButton: true,
          ),
          _buildField(
            icon: Icons.phone_outlined,
            label: 'Phone',
            textValue: widget.extracted['phone'] ?? '',
            showAddButton: true,
          ),
          _buildField(
            icon: Icons.location_on_outlined,
            label: 'Address',
            textValue: widget.extracted['address'] ?? '',
          ),
          _buildField(
            icon: Icons.language_outlined,
            label: 'Website',
            textValue: widget.extracted['website'] ?? '',
            showAddButton: true,
          ),
          if (widget.extracted['website'] != null)
            _buildField(
              icon: Icons.language_outlined,
              label: 'Website',
              textValue: widget.extracted['website'] ?? '',
              showRemoveButton: true,
            ),
        ],
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    String? textValue,
    TextEditingController? controllerValue,
    String? hint,
    bool isEditable = false,
    String? highlightText,
    bool showAddButton = false,
    bool showRemoveButton = false,
  }) {
    final hasController = controllerValue != null;
    final displayValue = textValue ?? '';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.gray200, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.spacing8),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
            ),
            child: Icon(icon, size: 20, color: AppColors.gray600),
          ),
          Gap(AppDimensions.spacing12),
          Expanded(
            child: isEditable && hasController
                ? TextField(
                    controller: controllerValue,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: AppTextStyles.hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : _buildHighlightedText(displayValue, highlightText),
          ),
          if (showAddButton)
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.success),
              onPressed: () {},
              iconSize: 24,
            ),
          if (showRemoveButton)
            IconButton(
              icon: const Icon(Icons.remove_circle, color: AppColors.error),
              onPressed: () {},
              iconSize: 24,
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
