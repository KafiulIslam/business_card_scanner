import 'dart:ui';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../theme/app_colors.dart';

class CustomSnack {

  static void success(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: ContentCart(isSuccess: true, message: message),
    ));
  }

  static void warning(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: ContentCart(isSuccess: false, message: message),
    ));
  }

}

class ContentCart extends StatelessWidget {
  final bool isSuccess;
  final String message;

  const ContentCart(
      {super.key, required this.isSuccess, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.warning,
              color: isSuccess ? const Color(0xFF2AD6B7) : Colors.red,
            ),
            const Gap(16),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                message,
                style: AppTextStyles.labelMedium,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.clear,
              color: AppColors.iconColor,
            )
          ],
        ),
      ),
    );
  }
}
