import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_style.dart';

class CardInfoField extends StatefulWidget {
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hint;

  const CardInfoField(
      {super.key,
      required this.icon,
      required this.controller,
      this.onChanged,
      required this.hint});

  @override
  State<CardInfoField> createState() => _CardInfoFieldState();
}

class _CardInfoFieldState extends State<CardInfoField> {
  @override
  Widget build(BuildContext context) {
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
            child: Icon(widget.icon, size: 20, color: AppColors.primary),
          ),
          Gap(AppDimensions.spacing12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              cursorColor: AppColors.primary,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.black),
              decoration: InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                hintText: widget.hint,
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
}
