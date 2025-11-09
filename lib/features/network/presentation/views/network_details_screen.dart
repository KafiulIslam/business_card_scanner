import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/assets_path.dart';
import 'package:business_card_scanner/core/widgets/custom_image_holder.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<void> _openWhatsApp(
      String whatsappNumber, BuildContext context) async {
    try {
      if (await canLaunch("whatsapp://send?phone=$whatsappNumber")) {
        await launch("whatsapp://send?phone=$whatsappNumber");
      } else {
        throw 'Could not launch the url';
      }
    } catch (e) {
      CustomSnack.warning(e.toString(), context);
    }
  }

  Future<void> _sendEmail(String? email, BuildContext context) async {
    try {
      if (email == null || email.isEmpty) {
        CustomSnack.warning('Email address is not available', context);
        return;
      }
      final uri = Uri.parse('mailto:$email');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      print('Failed to open email: ${e.toString()}');
      CustomSnack.warning('Failed to open email: ${e.toString()}', context);
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _openLinkedInSearch(String? name, BuildContext context) async {
    try {
      if (name == null || name.isEmpty) {
        CustomSnack.warning('Name is not available', context);
        return;
      }
      // URL encode the name for LinkedIn search
      final encodedName = Uri.encodeComponent(name);
      final uri = Uri.parse(
          'https://www.linkedin.com/search/results/people/?keywords=$encodedName');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch LinkedIn';
      }
    } catch (e) {
      print('Failed to open LinkedIn: ${e.toString()}');
      CustomSnack.warning('Failed to open LinkedIn: ${e.toString()}', context);
    }
  }

  Future<void> _openFacebookSearch(String? name, BuildContext context) async {
    try {
      if (name == null || name.isEmpty) {
        CustomSnack.warning('Name is not available', context);
        return;
      }
      // URL encode the name for Facebook search
      final encodedName = Uri.encodeComponent(name);
      final uri =
          Uri.parse('https://www.facebook.com/search/top/?q=$encodedName');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Facebook';
      }
    } catch (e) {
      print('Failed to open Facebook: ${e.toString()}');
      CustomSnack.warning('Failed to open Facebook: ${e.toString()}', context);
    }
  }

  Future<void> _openGoogleMaps(String? address, BuildContext context) async {
    try {
      if (address == null || address.isEmpty) {
        CustomSnack.warning('Address is not available', context);
        return;
      }
      // URL encode the address for Google Maps search
      final encodedAddress = Uri.encodeComponent(address);
      // Use Google Maps URL scheme - this will open the app if installed, or web version
      final uri = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$encodedAddress');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Google Maps';
      }
    } catch (e) {
      print('Failed to open Google Maps: ${e.toString()}');
      CustomSnack.warning(
          'Failed to open Google Maps: ${e.toString()}', context);
    }
  }

  Future<void> _saveContactToDevice(BuildContext context) async {
    try {
      // Check and request contacts permission
      final permission = await Permission.contacts.status;
      if (permission.isDenied) {
        final result = await Permission.contacts.request();
        if (result.isDenied) {
          CustomSnack.warning(
              'Contacts permission is required to save contact', context);
          return;
        }
      }

      if (permission.isPermanentlyDenied) {
        CustomSnack.warning(
            'Please enable contacts permission in app settings', context);
        return;
      }

      // Create a new contact
      final newContact = Contact(
        name: Name(
          first: network.name ?? '',
          last: '',
        ),
      );

      // Add phone number if available
      if (network.phone != null && network.phone!.isNotEmpty) {
        newContact.phones = [
          Phone(network.phone!),
        ];
      }

      // Add email if available
      if (network.email != null && network.email!.isNotEmpty) {
        newContact.emails = [
          Email(network.email!),
        ];
      }

      // Add company/organization if available
      if (network.company != null && network.company!.isNotEmpty) {
        newContact.organizations = [
          Organization(
            company: network.company!,
            title: network.title ?? '',
          ),
        ];
      }

      // Add address if available
      if (network.address != null && network.address!.isNotEmpty) {
        newContact.addresses = [
          Address(network.address!),
        ];
      }

      // Add website if available
      if (network.website != null && network.website!.isNotEmpty) {
        newContact.websites = [
          Website(network.website!),
        ];
      }

      // Insert the contact
      await FlutterContacts.insertContact(newContact);

      if (context.mounted) {
        CustomSnack.success('Contact saved successfully!', context);
      }
    } catch (e) {
      print('Failed to save contact: ${e.toString()}');
      if (context.mounted) {
        CustomSnack.warning('Failed to save contact: ${e.toString()}', context);
      }
    }
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
                      onTap: () => _openWhatsApp(network.phone ?? '', context)),
                  _buildActionButton(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () =>
                        _sendEmail('kafiulislam135@gmail.com', context),
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
                            _buildSocialIcon(AssetsPath.linkedIn, () {
                              _openLinkedInSearch(network.name, context);
                            }),
                            Gap(AppDimensions.spacing8),
                            _buildSocialIcon(AssetsPath.facebook, () {
                              _openFacebookSearch(network.name, context);
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
                        trailing: IconButton(
                            onPressed: () => _saveContactToDevice(context),
                            icon: const Icon(
                              Icons.contact_phone_outlined,
                              color: AppColors.primary,
                            )),
                      ),

                    // Address
                    if (network.address != null && network.address!.isNotEmpty)
                      _buildContactItem(
                          icon: Icons.location_on_outlined,
                          label: network.address!,
                          value: network.address,
                          trailing: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: InkWell(
                              onTap: () =>
                                  _openGoogleMaps(network.address, context),
                              child: Image.asset(
                                AssetsPath.googleMap,
                                height: 22,
                                width: 22,
                              ),
                            ),
                          )),

                    // Website
                    if (network.website != null && network.website!.isNotEmpty)
                      _buildContactItem(
                        icon: Icons.language,
                        label: network.website!,
                        value: network.website,
                        onTap: () async {
                          final url = network.website!.startsWith('http')
                              ? network.website!
                              : 'https://${network.website}';
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
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
          crossAxisAlignment: CrossAxisAlignment.center,
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

  Widget _buildSocialIcon(String image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        image,
        height: 22,
        width: 22,
      ),
    );
  }
}
