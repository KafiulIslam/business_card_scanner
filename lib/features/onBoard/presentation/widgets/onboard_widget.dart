import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String iconName;
  
  const OnboardWidget({
    super.key, 
    required this.title,
    required this.description,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Graphic Area
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryLight.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getIconFromName(iconName),
                size: 100,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'qr_code_2_rounded':
        return Icons.qr_code_2_rounded;
      case 'document_scanner_rounded':
        return Icons.document_scanner_rounded;
      case 'edit_note_rounded':
        return Icons.edit_note_rounded;
      default:
        return Icons.info;
    }
  }
}