import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// AppConstants - Centralized constants for the entire application
///
/// This file contains all reusable constants including:
/// - Border styles and decorations
/// - Input field configurations
/// - Button styles
/// - Spacing and dimensions
/// - Animation durations
/// - Common values used across the app
///
/// Benefits:
/// - Single source of truth for all constants
/// - Consistent UI/UX across the app
/// - Easy maintenance and updates
/// - Better code organization
///
/// Usage:
/// ```dart
/// import 'package:business_card_scanner/core/constants/app_constants.dart';
///
/// // Use in TextFormField
/// enabledBorder: AppConstants.enableOutLineBorder,
/// focusedBorder: AppConstants.focusOutLineBorder,
/// ```
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// Search input decoration
  static InputDecoration get searchInputDecoration => InputDecoration(
        filled: true,
        fillColor: AppColors.gray50,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintText: 'Search...',
        prefixIcon: const Icon(Icons.search, color: AppColors.gray500),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
      );

  // ==================== BUTTON STYLES ====================

  /// Primary button style
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
      );

  /// Secondary button style
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.primary),
        ),
        elevation: 0,
      );

  /// Outlined button style
  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: const BorderSide(color: AppColors.primary),
      );

  // ==================== CARD STYLES ====================

  /// Standard card decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  /// Elevated card decoration
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // ==================== ANIMATION DURATIONS ====================

  /// Short animation duration (200ms)
  static const Duration animationShort = Duration(milliseconds: 200);

  /// Medium animation duration (300ms)
  static const Duration animationMedium = Duration(milliseconds: 300);

  /// Long animation duration (500ms)
  static const Duration animationLong = Duration(milliseconds: 500);

  /// Page transition duration
  static const Duration pageTransition = Duration(milliseconds: 300);


  // ==================== COMMON VALUES ====================

  /// Standard padding for containers
  static const EdgeInsets standardPadding = EdgeInsets.all(16.0);

  /// Small padding for containers
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);

  /// Large padding for containers
  static const EdgeInsets largePadding = EdgeInsets.all(24.0);

  /// Standard margin for widgets
  static const EdgeInsets standardMargin = EdgeInsets.all(16.0);

  /// Small margin for widgets
  static const EdgeInsets smallMargin = EdgeInsets.all(8.0);

  /// Large margin for widgets
  static const EdgeInsets largeMargin = EdgeInsets.all(24.0);
}
