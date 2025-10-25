import 'package:business_card_scanner/core/constants/app_borders.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_style.dart';

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String label;

  const PasswordInputField(
      {super.key, required this.controller, this.hintText, required this.label});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late bool isPassObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.bodySmall.copyWith(color: Colors.black)),
        Gap(AppDimensions.spacing8),
        TextFormField(
          controller: widget.controller,
          obscureText: isPassObscure,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hintText,
            hintStyle: AppTextStyles.hintText,

            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPassObscure = !isPassObscure;
                  var index = 0;
                  if (!isPassObscure) {
                    index = 1;
                  }
                });
              },
              child: isPassObscure
                  ? const Icon(
                      Icons.visibility_off,
                      color: AppColors.iconColor,
                    )
                  : const Icon(
                      Icons.visibility,
                      color: AppColors.primary,
                    ),
            ),
            focusedBorder: AppBorders.focusOutLineBorder,
            enabledBorder: AppBorders.enableOutLineBorder,
            errorBorder: AppBorders.outlineErrorBorder,
            focusedErrorBorder: AppBorders.outlineErrorBorder,
            focusColor: AppColors.borderColor,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
