import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
//import 'package:url_launcher/url_launcher.dart';

class NetworkDetailsScreen extends StatelessWidget {
  final NetworkModel network;

  const NetworkDetailsScreen({super.key, required this.network});

//   Future<void> _makePhoneCall(String? phone) async {
//     if (phone == null || phone.isEmpty) return;
//     final uri = Uri.parse('tel:$phone');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }
//
//   Future<void> _sendSMS(String? phone) async {
//     if (phone == null || phone.isEmpty) return;
//     final uri = Uri.parse('sms:$phone');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }
//
//   Future<void> _openWhatsApp(String? phone) async {
//     if (phone == null || phone.isEmpty) return;
//     // Remove any non-digit characters for WhatsApp
//     final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
//     final uri = Uri.parse('https://wa.me/$cleanPhone');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   Future<void> _sendEmail(String? email) async {
//     if (email == null || email.isEmpty) return;
//     final uri = Uri.parse('mailto:$email');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }
//
//   Future<void> _shareCard() async {
//     final text = '''
// ${network.name ?? ''}
// ${network.title ?? ''}
// ${network.company ?? ''}
// ${network.phone ?? ''}
// ${network.email ?? ''}
// ${network.address ?? ''}
// ${network.website ?? ''}
// ''';
//     await Share.share(text);
//   }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          network.name ?? 'Network Details',
          style: AppTextStyles.headline4,
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.star_outline, color: Colors.black),
        //     onPressed: () {
        //       // TODO: Implement favorite functionality
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Card Image
            if (network.imageUrl != null && network.imageUrl!.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacing16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  child: CachedNetworkImage(
                    imageUrl: network.imageUrl!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200.h,
                      color: AppColors.gray200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200.h,
                      color: AppColors.gray200,
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),

            // Action Buttons Row
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.phone,
                    label: 'Call',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.message,
                    label: 'SMS',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.chat,
                    label: 'What',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Gap(AppDimensions.spacing16),

            // Customer Dropdown/Tag
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing12,
                  vertical: AppDimensions.spacing8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      network.category ?? 'Customer',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Gap(AppDimensions.spacing8),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primary,
                      size: AppDimensions.icon20,
                    ),
                  ],
                ),
              ),
            ),

            Gap(AppDimensions.spacing16),

            // Add Tags Section
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.iconColor,
                    size: AppDimensions.icon20,
                  ),
                  Gap(AppDimensions.spacing8),
                  Text(
                    'Add Tags Here...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.iconColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                      size: AppDimensions.icon24,
                    ),
                    onPressed: () {
                      // TODO: Implement add tag functionality
                    },
                  ),
                ],
              ),
            ),

            Gap(AppDimensions.spacing16),

            // Contact Information List
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
              child: Column(
                children: [
                  // Card Name
                  if (network.name != null && network.name!.isNotEmpty)
                    _buildContactItem(
                      icon: Icons.description_outlined,
                      label: '${network.name} Card',
                      value: network.name,
                    ),

                  // Name with Social Icons
                  if (network.name != null && network.name!.isNotEmpty)
                    _buildContactItem(
                      icon: Icons.person_outline,
                      label: network.name!,
                      value: network.name,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSocialIcon('in', () {
                            // TODO: Open LinkedIn
                          }),
                          Gap(AppDimensions.spacing8),
                          _buildSocialIcon('f', () {
                            // TODO: Open Facebook
                          }),
                        ],
                      ),
                    ),

                  // Title
                  if (network.title != null && network.title!.isNotEmpty)
                    _buildContactItem(
                      icon: Icons.work_outline,
                      label: network.title!,
                      value: network.title,
                    ),

                  // Company
                  if (network.company != null && network.company!.isNotEmpty)
                    _buildContactItem(
                      icon: Icons.business_outlined,
                      label: network.company!,
                      value: network.company,
                    ),

                  // Email
                  if (network.email != null && network.email!.isNotEmpty)
                    _buildContactItem(
                      icon: Icons.alternate_email,
                      label: network.email!,
                      value: network.email,
                    ),

                  // Phone
                  if (network.phone != null && network.phone!.isNotEmpty)
                    _buildContactItem(
                      icon: Icons.phone_outlined,
                      label: network.phone!,
                      value: network.phone,
                    ),

                  // Address
                  if (network.address != null && network.address!.isNotEmpty)
                    _buildContactItem(
                      icon: Icons.location_on_outlined,
                      label: network.address!,
                      value: network.address,
                    ),

                  // Website
                  if (network.website != null && network.website!.isNotEmpty)
                    _buildContactItem(
                      icon: Icons.language,
                      label: network.website!,
                      value: network.website,
                      onTap: () async {
                        // final url = network.website!.startsWith('http')
                        //     ? network.website!
                        //     : 'https://${network.website}';
                        // final uri = Uri.parse(url);
                        // if (await canLaunchUrl(uri)) {
                        //   await launchUrl(uri,
                        //       mode: LaunchMode.externalApplication);
                        // }
                      },
                    ),
                ],
              ),
            ),

            Gap(AppDimensions.spacing32),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius8),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: AppDimensions.icon24,
            ),
          ),
          Gap(AppDimensions.spacing4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.gray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? (value != null ? () => _copyToClipboard(value) : null),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.iconColor,
              size: AppDimensions.icon20,
            ),
            Gap(AppDimensions.spacing12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
