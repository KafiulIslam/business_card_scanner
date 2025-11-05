import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomFloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CustomFloatingButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(48),
              topLeft: Radius.circular(48),
              bottomLeft: Radius.circular(48),
            )),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}