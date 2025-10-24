import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/onboard_data.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardData> onboardPages = [
    OnboardData(
      title: 'Your Card, Always Ready',
      description:
          'User Business Card Scanner is free for life time. Scan and digitize your own professional card. Instantly share a pristine digital copy anytime, anywhere.',
      icon: Icons.qr_code_2_rounded,
    ),
    OnboardData(
      title: 'Never Lose a Contact',
      description:
          "Scan anyone's business card, and preserve the data life time. Our AI extracts names, emails, and numbers instantly, saving them securely to your digital rolodex.",
      icon: Icons.document_scanner_rounded,
    ),
    OnboardData(
      title: 'Design Your Brand',
      description:
          'Create your own business card using our intuitive editor. Choose templates, customize colors, and generate a professional, shareable digital card instantly.',
      icon: Icons.edit_note_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
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

  void _onSkip() {
    context.go(Routes.login);
  }

  void _onGetStarted() {
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardPages.length,
                itemBuilder: (context, index) {
                  return OnboardPage(data: onboardPages[index]);
                },
              ),
            ),
            _buildNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildDotIndicator(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip/Back Button
              if (_currentPage == 0)
                TextButton(
                  onPressed: _onSkip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

              // Next/Get Started Button
              ElevatedButton(
                onPressed: () {
                  if (_currentPage < onboardPages.length - 1) {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  } else {
                    _onGetStarted();
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
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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

// --- SINGLE PAGE WIDGET ---
class OnboardPage extends StatelessWidget {
  final OnboardData data;

  const OnboardPage({super.key, required this.data});

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
              border: Border.all(
                  color: AppColors.primaryLight.withOpacity(0.3), width: 2),
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
