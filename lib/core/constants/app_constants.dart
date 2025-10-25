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

  // ==================== INPUT FIELD BORDERS ====================

  /// Default enabled border for input fields
  /// Used when the field is not focused but is enabled
  static final OutlineInputBorder enableOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.borderColor),
  );

  /// Focused border for input fields
  /// Used when the field is focused/selected
  static final OutlineInputBorder focusOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
  );

  /// Error border for input fields
  /// Used when the field has validation errors
  static final OutlineInputBorder outlineErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.error, width: 2.0),
  );

  /// Disabled border for input fields
  /// Used when the field is disabled
  static final OutlineInputBorder disabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.gray300),
  );

  // ==================== INPUT DECORATIONS ====================

  /// Standard input decoration for text fields
  static InputDecoration get standardInputDecoration => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: enableOutLineBorder,
        enabledBorder: enableOutLineBorder,
        focusedBorder: focusOutLineBorder,
        errorBorder: outlineErrorBorder,
        focusedErrorBorder: outlineErrorBorder,
        disabledBorder: disabledBorder,
      );

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

  // ==================== SPACING ====================

  /// Extra small spacing (4px)
  static const double spacingXS = 4.0;

  /// Small spacing (8px)
  static const double spacingS = 8.0;

  /// Medium spacing (16px)
  static const double spacingM = 16.0;

  /// Large spacing (24px)
  static const double spacingL = 24.0;

  /// Extra large spacing (32px)
  static const double spacingXL = 32.0;

  /// Extra extra large spacing (48px)
  static const double spacingXXL = 48.0;

  // ==================== BORDER RADIUS ====================

  /// Small border radius (4px)
  static const double radiusS = 4.0;

  /// Medium border radius (8px)
  static const double radiusM = 8.0;

  /// Large border radius (12px)
  static const double radiusL = 12.0;

  /// Extra large border radius (16px)
  static const double radiusXL = 16.0;

  /// Circular border radius (50%)
  static const double radiusCircular = 50.0;

  // ==================== ICON SIZES ====================

  /// Small icon size (16px)
  static const double iconS = 16.0;

  /// Medium icon size (24px)
  static const double iconM = 24.0;

  /// Large icon size (32px)
  static const double iconL = 32.0;

  /// Extra large icon size (48px)
  static const double iconXL = 48.0;

  // ==================== ELEVATION ====================

  /// Low elevation (2dp)
  static const double elevationLow = 2.0;

  /// Medium elevation (4dp)
  static const double elevationMedium = 4.0;

  /// High elevation (8dp)
  static const double elevationHigh = 8.0;

  // ==================== OPACITY ====================

  /// Low opacity (0.1)
  static const double opacityLow = 0.1;

  /// Medium opacity (0.5)
  static const double opacityMedium = 0.5;

  /// High opacity (0.8)
  static const double opacityHigh = 0.8;

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
