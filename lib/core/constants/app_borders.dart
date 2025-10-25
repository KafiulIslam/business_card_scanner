import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// AppBorders - Centralized border and input decoration constants

class AppBorders {
  // Private constructor to prevent instantiation
  AppBorders._();

  // ==================== INPUT FIELD BORDERS ====================

  /// Default enabled border Used when the field is not focused but is enabled
  static final OutlineInputBorder enableOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDimensions.radius12),
    borderSide: const BorderSide(color: AppColors.borderColor),
  );


  /// Focused border, Used when the field is focused/selected
  static final OutlineInputBorder focusOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDimensions.radius12),
    borderSide: const BorderSide(color: AppColors.primary),
  );


  /// Error border, Used when the field has validation errors
  static final OutlineInputBorder outlineErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDimensions.radius12),
    borderSide: const BorderSide(color: AppColors.error),
  );


  /// Disabled border, Used when the field is disabled
  static final OutlineInputBorder disabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDimensions.radius12),
    borderSide: const BorderSide(color: AppColors.gray300),
  );

  // ==================== CARD BORDERS ====================

  /// Standard card border
  /// Used for cards and containers
  static final Border cardBorder = Border.all(
    color: AppColors.borderColor,
    width: 1.0,
  );

  /// Primary card border
  /// Used for highlighted or selected cards
  static final Border primaryCardBorder = Border.all(
    color: AppColors.primary
  );

  /// Error card border
  /// Used for cards with errors or warnings
  static final Border errorCardBorder = Border.all(
    color: AppColors.error,
    width: 1.0,
  );

  // ==================== BUTTON BORDERS ====================

  /// Primary button border
  /// Used for primary action buttons
  static const BorderSide primaryButtonBorder = BorderSide(
    color: AppColors.primary,
    width: 2.0,
  );

  /// Secondary button border
  /// Used for secondary action buttons
  static const BorderSide secondaryButtonBorder = BorderSide(
    color: AppColors.borderColor,
    width: 1.0,
  );

  /// Outlined button border
  /// Used for outlined buttons
  static const BorderSide outlinedButtonBorder = BorderSide(
    color: AppColors.primary,
    width: 1.5,
  );

  // ==================== CONTAINER BORDERS ====================

  /// Standard container border
  /// Used for general containers
  static final BoxBorder containerBorder = Border.all(
    color: AppColors.borderColor,
    width: 1.0,
  );

  /// Thick container border
  /// Used for emphasis or important containers
  static final BoxBorder thickContainerBorder = Border.all(
    color: AppColors.borderColor,
    width: 2.0,
  );

  /// Rounded container border
  /// Used for rounded containers with border
  static final BoxBorder roundedContainerBorder = Border.all(
    color: AppColors.borderColor,
    width: 1.0,
  );

  // ==================== DIVIDER BORDERS ====================

  /// Standard divider border
  /// Used for section dividers
  static const BorderSide dividerBorder = BorderSide(
    color: AppColors.borderColor,
    width: 1.0,
  );

  /// Thick divider border
  /// Used for major section dividers
  static const BorderSide thickDividerBorder = BorderSide(
    color: AppColors.borderColor,
    width: 2.0,
  );


}
