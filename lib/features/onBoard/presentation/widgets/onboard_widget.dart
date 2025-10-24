import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/onboard_data.dart';


class OnboardWidget extends StatelessWidget {
  final OnboardData data;
  const OnboardWidget({super.key, required this.data});

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
                data.icon,
                size: 100,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
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
            data.description,
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
}