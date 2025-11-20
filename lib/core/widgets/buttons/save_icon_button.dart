import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

class SaveIconButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final bool isEnabled;

  const SaveIconButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool canTap = isEnabled && !isLoading;
    
    return InkWell(
      onTap: canTap ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.gray400
              : (canTap ? AppColors.primary : AppColors.gray400),
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              )
            : Icon(
                Icons.save_as_outlined,
                color: canTap ? Colors.white : Colors.grey,
              ),
      ),
    );
  }
}
