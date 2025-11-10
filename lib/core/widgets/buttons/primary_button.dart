import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onTap;
  final bool isLoading;

  const PrimaryButton(
      {super.key,
      required this.onTap,
      required this.buttonTitle,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.buttonHeight56,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius8)),
          elevation: 0.0,
          backgroundColor: AppColors.primary,
          textStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        ),
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.white.withOpacity(0.5),
              ))
            : Text(
                buttonTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headline2
                    .copyWith(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}
