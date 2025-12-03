
class NetworkConstants {
  // Private constructor to prevent instantiation
  NetworkConstants._();

  // ==================== CARD CATEGORIES ====================

  /// List of available card categories
  /// These categories are used for organizing and filtering network cards
  static const List<String> categories = [
    'General',
    'Prospect',
    'Trial',
    'Customer',
    'Inactive',
    'Lead',
    'Partner',
  ];

  /// Default category when no category is selected
  static const String defaultCategory = 'General';

  // ==================== CARD TAGS ====================

  /// List of available card tags
  /// These tags can be used for additional categorization
  static const List<String> tags = [
    'Prospects',
    'Leads',
    'Conferences',
  ];

  /// Default tag when no tag is selected
  static const String defaultTag = 'Prospects';

  // ==================== VALIDATION ====================

  /// Check if a category is valid
  static bool isValidCategory(String category) {
    return categories.contains(category);
  }

  /// Check if a tag is valid
  static bool isValidTag(String tag) {
    return tags.contains(tag);
  }

  /// Get the first valid category (used as fallback)
  static String getFirstCategory() {
    return categories.isNotEmpty ? categories.first : defaultCategory;
  }
}

