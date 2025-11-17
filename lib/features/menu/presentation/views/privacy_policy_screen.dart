import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Privacy Policy'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  'This privacy policy applies to the Cardigo app (hereby referred to as "Application") for mobile devices that was created by CoderTent (hereby referred to as "Service Provider") as a Free service. This service is intended for use "AS IS".'),
              Gap(AppDimensions.spacing32),
              _buildTitle('Information Collection and Use'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "The Application collects information when you download and use it. This information may include information such as \n\n* Your device's Internet Protocol address (e.g. IP address \n* The pages of the Application that you visit, the time and date ofyour visit, the time spent on those pages \n* The time spent on the Application \n* The operating system you use on your mobile device. \n\nThe Application does not gather precise information about the location of your mobile device.The Service Provider may use the information you provided to contact you from time to time to provide you with important information,required notices and marketing promotions.For a better experience, while using the Application, the Service Provider may require you to provide us with certain personally identifiable information. The information that the Service Provider request will be retained by them and used as described in this privacy policy."),
              Gap(AppDimensions.spacing32),
              _buildTitle('Third Party Access'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  'Only aggregated, anonymized data is periodically transmitted to external services to aid the Service Provider in improving the Application and their service. The Service Provider may share your information with third parties in the ways that are described in this privacy statement. \n\nPlease note that the Application utilizes third-party services that have their own Privacy Policy about handling data. Below are the links to the Privacy Policy of the third-party service providers used by the Application: \n\n * Google Play Services \n* Google Analytics for Firebase'),
              Gap(AppDimensions.spacing32),
              _buildTitle('Opt-Out Rights'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  'You can stop all collection of information by the Application easily by uninstalling it. You may use the standard uninstall processes as may be available as part of your mobile device or via the mobile application marketplace or network.'),
              Gap(AppDimensions.spacing32),
              _buildTitle('Data Retention Policy'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "The Service Provider will retain User Provided data for as long as you use the Application and for a reasonable time thereafter. If you'd like them to delete User Provided Data that you have provided via the Application, please contact them at codertent@gmail.com and they will respond in a reasonable time."),
              Gap(AppDimensions.spacing32),
              _buildTitle('Security'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "The Service Provider is concerned about safeguarding the confidentiality of your information. The Service Provider provides physical, electronic, and procedural safeguards to protect information the Service Provider processes and maintains."),
              Gap(AppDimensions.spacing32),
              _buildTitle('Changes'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "This Privacy Policy may be updated from time to time for any reason. The Service Provider will notify you of any changes to the Privacy Policy by updating this page with the new Privacy Policy. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes. \n\nThis privacy policy is effective as of 2025-11-17"),
              Gap(AppDimensions.spacing32),
              _buildTitle('Your Consent'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "By using the Application, you are consenting to the processing of your information as set forth in this Privacy Policy now and as amended by us"),
              Gap(AppDimensions.spacing32),
              _buildTitle('Contact Us'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "If you have any questions regarding privacy while using the Application, or have questions about the practices, please contact the Service Provider via email at codertent@gmail.com."),
              Gap(AppDimensions.spacing32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style:
          AppTextStyles.headline3.copyWith(color: Colors.black, fontSize: 18),
    );
  }

  Widget _buildContent(String content) {
    return Text(
      content,
      style: AppTextStyles.bodySmall,
    );
  }
}
