import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../constants/app_borders.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? initialValue;
  final bool? isSuffix;
  final IconData? suffixIcon;
  final bool? isReadOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? maxLength;

  const CommonTextField(
      {super.key,
      required this.controller,
      required this.label,
      this.hintText,
      this.initialValue = '',
      this.isSuffix = false,
      this.suffixIcon,
      this.isReadOnly = false,
      this.onTap,
      this.maxLines,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.black)),
        Gap(AppDimensions.spacing8),
        TextFormField(
          controller: controller,
          onTap: onTap,
          autofocus: false,
          readOnly: isReadOnly ?? false,
          maxLines: maxLines,
          maxLength: maxLength,
          cursorColor: AppColors.primary,
          style: AppTextStyles.labelMedium.copyWith(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            hintText: hintText,
            hintStyle: AppTextStyles.hintText,
            suffixIcon: Icon(
              suffixIcon,
              color: AppColors.iconColor,
            ),
            focusedBorder: isReadOnly ?? false
                ? AppBorders.enableOutLineBorder
                : AppBorders.focusOutLineBorder,
            enabledBorder: AppBorders.enableOutLineBorder,
            errorBorder: AppBorders.outlineErrorBorder,
            focusedErrorBorder: AppBorders.outlineErrorBorder,
            focusColor: AppColors.borderColor,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        )
      ],
    );
  }
}
