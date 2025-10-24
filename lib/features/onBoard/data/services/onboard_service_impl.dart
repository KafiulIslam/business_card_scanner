import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/onboard_entity.dart';
import 'onboard_service.dart';

class OnboardServiceImpl implements OnboardService {
  @override
  Future<List<OnboardEntity>> getOnboardData() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      const OnboardEntity(
        title: 'Your Card, Always Ready',
        description: 'User Business Card Scanner is free for life time. Scan and digitize your own professional card. Instantly share a pristine digital copy anytime, anywhere.',
        iconName: 'qr_code_2_rounded',
      ),
      const OnboardEntity(
        title: 'Never Lose a Contact',
        description: "Scan anyone's business card, and preserve the data life time. Our AI extracts names, emails, and numbers instantly, saving them securely to your digital rolodex.",
        iconName: 'document_scanner_rounded',
      ),
      const OnboardEntity(
        title: 'Design Your Brand',
        description: 'Create your own business card using our intuitive editor. Choose templates, customize colors, and generate a professional, shareable digital card instantly.',
        iconName: 'edit_note_rounded',
      ),
    ];
  }

  @override
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }
}
