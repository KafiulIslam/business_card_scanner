import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Terms & Conditions'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "These terms and conditions apply to the Cardigo app (hereby referred to as \"Application\") for mobile devices that was created by CoderTent (hereby referred to as \"Service Provider\") as a Free service. \n\nUpon downloading or utilizing the Application, you are automatically agreeing to the following terms. It is strongly advised that you thoroughly read and understand these terms prior to using the Application.\n\nUnauthorized copying, modification of the Application, any part of the Application, or our trademarks is strictly prohibited. Any attempts to extract the source code of the Application, translate the Application into other languages, or create derivative versions are not permitted. All trademarks, copyrights, database rights, and other intellectual property rights related to the Application remain the property of the Service Provider.\n\nThe Service Provider is dedicated to ensuring that the Application is as beneficial and efficient as possible. As such, they reserve the right to modify the Application or charge for their services at any time and for any reason. The Service Provider assures you that any charges for the Application or its services will be clearly communicated to you.\n\nThe Application stores and processes personal data that you have provided to the Service Provider in order to provide the Service. It is your responsibility to maintain the security of your phone and access to the Application. The Service Provider strongly advise against jailbreaking or rooting your phone, which involves removing software restrictions and limitations imposed by the official operating system of your device. Such actions could expose your phone to malware, viruses, malicious programs, compromise your phone's security features, and may result in the Application not functioning correctly or at all. Please note that the Application utilizes third-party services that have their own Terms and Conditions. Below are the links to the Terms and Conditions of the third-party service providers used by the Application:\n\n* Google Play Services\n * Google Analytics for Firebase \n\nPlease be aware that the Service Provider does not assume responsibility for certain aspects. Some functions of the Application require an active internet connection, which can be Wi-Fi or provided by your mobile network provider. The Service Provider cannot be held responsible if the Application does not function at full capacity due to lack of access to Wi-Fi or if you have exhausted your data allowance.\n\nIn terms of the Service Provider's responsibility for your use of the application, it is important to note that while they strive to ensure that it is updated and accurate at all times, they do rely on third parties to provide information to them so that they can make it available to you. The Service Provider accepts no liability for any loss, direct or indirect, that you experience as a result of relying entirely on this functionality of the application."),
              Gap(AppDimensions.spacing32),
              _buildTitle('Changes to These Terms and Conditions'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "The Service Provider may periodically update their Terms and Conditions. Therefore, you are advised to review this page regularly for any changes. The Service Provider will notify you of any changes by posting the new Terms and Conditions on this page.\n\nThese terms and conditions are effective as of 2025-11-18"),
              Gap(AppDimensions.spacing32),

              _buildTitle('Contact Us'),
              Gap(AppDimensions.spacing8),
              _buildContent(
                  "If you have any questions or suggestions about the Terms and Conditions, please do not hesitate to contact the Service Provider at codertent@gmail.com."),
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
