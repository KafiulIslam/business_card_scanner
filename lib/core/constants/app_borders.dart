import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// AppBorders - Centralized border and input decoration constants

class AppBorders {
  // Private constructor to prevent instantiation
  AppBorders._();

  // ==================== INPUT FIELD BORDERS ====================

  /// Default enabled border Used when the field is not focused but is enabled
  static final OutlineInputBorder enableOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.borderColor),
  );


  /// Focused border, Used when the field is focused/selected
  static final OutlineInputBorder focusOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
  );


  /// Error border, Used when the field has validation errors
  static final OutlineInputBorder outlineErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: AppColors.error, width: 2.0),
  );


  /// Disabled border, Used when the field is disabled
  static final OutlineInputBorder disabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
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
    color: AppColors.primary,
    width: 2.0,
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
  static final BorderSide primaryButtonBorder = const BorderSide(
    color: AppColors.primary,
    width: 2.0,
  );

  /// Secondary button border
  /// Used for secondary action buttons
  static final BorderSide secondaryButtonBorder = const BorderSide(
    color: AppColors.borderColor,
    width: 1.0,
  );

  /// Outlined button border
  /// Used for outlined buttons
  static final BorderSide outlinedButtonBorder = const BorderSide(
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
  static final BorderSide dividerBorder = const BorderSide(
    color: AppColors.borderColor,
    width: 1.0,
  );

  /// Thick divider border
  /// Used for major section dividers
  static final BorderSide thickDividerBorder = const BorderSide(
    color: AppColors.borderColor,
    width: 2.0,
  );

  // ==================== BORDER RADIUS ====================

  /// Small border radius (4px)
  static const double radiusSmall = 4.0;

  /// Medium border radius (8px)
  static const double radiusMedium = 8.0;

  /// Large border radius (12px)
  static const double radiusLarge = 12.0;

  /// Extra large border radius (16px)
  static const double radiusXLarge = 16.0;

  /// Circular border radius (50%)
  static const double radiusCircular = 50.0;

  // ==================== BORDER WIDTHS ====================

  /// Thin border width (0.5px)
  static const double widthThin = 0.5;

  /// Normal border width (1px)
  static const double widthNormal = 1.0;

  /// Thick border width (2px)
  static const double widthThick = 2.0;

  /// Extra thick border width (3px)
  static const double widthXThick = 3.0;
}
