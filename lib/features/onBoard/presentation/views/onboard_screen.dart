import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/onboard_widget.dart';


class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  // Controller for managing page transitions and navigation
  final PageController _pageController = PageController();

  // Current page index (0-based)
  int _currentPage = 0;

  // Static data for onboarding pages
  // Each page contains title, description, and icon information
  final List<Map<String, dynamic>> onboardPages = [
    {
      'title': 'Your Card, Always Ready',
      'description':
          'User Business Card Scanner is free for life time. Scan and digitize your own professional card. Instantly share a pristine digital copy anytime, anywhere.',
      'icon': Icons.qr_code_2_rounded,
    },
    {
      'title': 'Never Lose a Contact',
      'description':
          "Scan anyone's business card, and preserve the data life time. Our AI extracts names, emails, and numbers instantly, saving them securely to your digital rolodex.",
      'icon': Icons.document_scanner_rounded,
    },
    {
      'title': 'Design Your Brand',
      'description':
          'Create your own business card using our intuitive editor. Choose templates, customize colors, and generate a professional, shareable digital card instantly.',
      'icon': Icons.edit_note_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Listen for page changes to update current page index
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Main content area with PageView for onboarding slides
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardPages.length,
              itemBuilder: (context, index) {
                final page = onboardPages[index];
                return OnboardWidget(
                  title: page['title'] as String,
                  description: page['description'] as String,
                  icon: page['icon'] as IconData,
                );
              },
            ),
          ),
          // Navigation controls (dots, buttons)
          _buildNavigation(context),
           Gap(AppDimensions.spacing32),
        ],
      ),
    );
  }

  // Builds the navigation section with page indicators and control buttons

  Widget _buildNavigation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Page indicator dots
          _buildDotIndicator(),
          Gap(AppDimensions.spacing24),

          // Navigation buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip/Back Button - contextual based on current page
              if (_currentPage == 0)
                // Skip button (first page only)
                TextButton(
                  onPressed: () => context.go(Routes.login),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium,
                  ),
                )
              else
                // Back button (subsequent pages)
                TextButton(
                  onPressed: () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: Text(
                    'Back',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),

              // Next/Get Started Button - contextual based on current page
              ElevatedButton(
                onPressed: () {
                  if (_currentPage < onboardPages.length - 1) {
                    // Navigate to next page
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  } else {
                    // Navigate to main app (last page)
                    context.go(Routes.login);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: AppColors.primaryLight,
                ),
                child: Text(
                  _currentPage == onboardPages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style:
                      AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the page indicator dots
  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardPages.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _currentPage == index ? AppColors.primary : AppColors.gray500,
          ),
        ),
      ),
    );
  }

}
