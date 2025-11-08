import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/widgets/custom_image_holder.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/custom_snack.dart';

class NetworkDetailsScreen extends StatelessWidget {
  final NetworkModel network;

  const NetworkDetailsScreen({super.key, required this.network});

  Future<void> _makePhoneCall(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

//   Future<void> _sendSMS(String? phone) async {
//     if (phone == null || phone.isEmpty) return;
//     final uri = Uri.parse('sms:$phone');
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }
//
  Future<void> _openWhatsApp(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    // Remove any non-digit characters for WhatsApp
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchWhatsApp(String url, BuildContext context) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch the url';
      }
    } catch (e) {
      CustomSnack.warning(e.toString(), context);
    }
  }

  Future<void> _sendEmail(String? email) async {
    if (email == null || email.isEmpty) return;
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Card Image
              CustomImageHolder(
                  imageUrl: network.imageUrl ?? '',
                  isCircle: false,
                  height: 200.h,
                  width: double.infinity,
                  fitType: (network.isCameraScanned == true)
                      ? BoxFit.cover
                      : BoxFit.fill,
                  errorWidget: const Icon(Icons.image,
                      size: 64, color: AppColors.iconColor)),
              Gap(AppDimensions.spacing16),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.phone,
                    label: 'Call',
                    onTap: () => _makePhoneCall(network.phone),
                  ),
                  // _buildActionButton(
                  //   icon: Icons.message,
                  //   label: 'SMS',
                  //   onTap: () {},
                  // ),
                  _buildActionButton(
                      icon: Icons.chat,
                      label: 'WhatsApp',
                      //onTap: () => _openWhatsApp(network.phone),
                      onTap: () => launchWhatsApp(
                          "whatsapp://send?phone=${network.phone}", context)),
                  _buildActionButton(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () => _sendEmail(network.email),
                  ),
                  _buildActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () {
                      SharePlus.instance.share(ShareParams(
                          text:
                              'Check out & download ${network.name}\'s digital business card - ${network.imageUrl}'));
                    },
                  ),
                ],
              ),
              Gap(AppDimensions.spacing16),

              // Customer Dropdown/Tag
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing12,
                  vertical: AppDimensions.spacing8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Text(
                  network.category ?? 'Customer',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
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
              color: AppColors.primaryLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppDimensions.icon24,
            ),
          ),
          Gap(AppDimensions.spacing4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.black,
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
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight.withOpacity(0.2),
              child: Center(
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: AppDimensions.icon16,
                ),
              ),
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
        decoration: const BoxDecoration(
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
