import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/assets_path.dart';
import 'package:business_card_scanner/core/widgets/custom_image_holder.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_cubit.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/custom_snack.dart';
import '../../../../core/services/external_app_service.dart';

class NetworkDetailsScreen extends StatelessWidget {
  final NetworkModel network;

  const NetworkDetailsScreen({super.key, required this.network});

  Future<void> _makePhoneCall(String? phone, BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.makePhoneCall(phone);
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  Future<void> _openWhatsApp(
      String whatsappNumber, BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.openWhatsApp(whatsappNumber);
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  Future<void> _sendEmail(String? email, BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.sendEmail(email);
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  void _copyToClipboard(String text, BuildContext context) {
    try {
      final service = context.read<ExternalAppService>();
      service.copyToClipboard(text);
      if (context.mounted) {
        CustomSnack.success('Copied to clipboard', context);
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning('Failed to copy: ${e.toString()}', context);
      }
    }
  }

  Future<void> _openLinkedInSearch(String? name, BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.openLinkedInSearch(name);
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  Future<void> _openFacebookSearch(String? name, BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.openFacebookSearch(name);
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  Future<void> _openGoogleMaps(String? address, BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.openGoogleMaps(address);
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  Future<void> _openWebsite(String? website, BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.openWebsite(website);
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  Future<void> _saveContactToDevice(BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.saveContactToDevice(network);
      if (context.mounted) {
        CustomSnack.success('Contact saved successfully!', context);
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  Future<void> _shareNetworkCard(String text, BuildContext context) async {
    try {
      final service = context.read<ExternalAppService>();
      await service.shareContent(text);
    } catch (e) {
      if (context.mounted) {
        CustomSnack.warning(e.toString(), context);
      }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Business Card'),
          content: const Text(
              'Are you sure you want to delete this business card? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (network.cardId != null && network.cardId!.isNotEmpty) {
                  context
                      .read<NetworkCubit>()
                      .deleteNetworkCard(network.cardId!);
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkState>(
      listenWhen: (prev, curr) =>
          (prev.isLoading && !curr.isLoading && curr.isSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (!state.isLoading && state.isSuccess) {
          CustomSnack.success('Network card deleted successfully', context);
          context.read<NetworkCubit>().clearFlags();
          // Navigate back to previous screen
          if (context.mounted) {
            context.pop();
          }
        } else if (state.error != null) {
          CustomSnack.warning(state.error!, context);
          context.read<NetworkCubit>().clearFlags();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            network.name ?? 'Network Details',
            style: AppTextStyles.headline4,
          ),
          actions: [
            InkWell(
              onTap: () => _showDeleteConfirmationDialog(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.withOpacity(0.2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
            ),
            const Gap(16)
          ],
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
                      onTap: () => _makePhoneCall(network.phone, context),
                    ),
                    // _buildActionButton(
                    //   icon: Icons.message,
                    //   label: 'SMS',
                    //   onTap: () {},
                    // ),
                    _buildActionButton(
                        icon: Icons.chat,
                        label: 'WhatsApp',
                        onTap: () =>
                            _openWhatsApp(network.phone ?? '', context)),
                    // _buildActionButton(
                    //   icon: Icons.email,
                    //   label: 'Email',
                    //   onTap: () =>
                    //       _sendEmail('kafiulislam135@gmail.com', context),
                    // ),
                    _buildActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: () => _shareNetworkCard(
                          'Check out & download ${network.name}\'s digital business card - ${network.imageUrl}',
                          context),
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
                Column(
                  children: [
                    // Card Name
                    if (network.name != null && network.name!.isNotEmpty)
                      _buildContactItem(
                        icon: Icons.description_outlined,
                        label: '${network.name} Card',
                        value: network.name,
                        context: context,
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
                            _buildImageIcon(AssetsPath.linkedIn, () {
                              _openLinkedInSearch(network.name, context);
                            }),
                            Gap(AppDimensions.spacing8),
                            _buildImageIcon(AssetsPath.facebook, () {
                              _openFacebookSearch(network.name, context);
                            }),
                          ],
                        ),
                        context: context,
                      ),

                    // Title
                    if (network.title != null && network.title!.isNotEmpty)
                      _buildContactItem(
                        icon: Icons.work_outline,
                        label: network.title!,
                        value: network.title,
                        context: context,
                      ),

                    // Company
                    if (network.company != null && network.company!.isNotEmpty)
                      _buildContactItem(
                        icon: Icons.business_outlined,
                        label: network.company!,
                        value: network.company,
                        context: context,
                      ),

                    // Email
                    if (network.email != null && network.email!.isNotEmpty)
                      _buildContactItem(
                          icon: Icons.alternate_email,
                          label: network.email!,
                          value: network.email,
                          trailing: _buildImageIcon(AssetsPath.email,
                              () => _sendEmail(network.email, context)),
                          context: context),

                    // Phone
                    if (network.phone != null && network.phone!.isNotEmpty)
                      _buildContactItem(
                        icon: Icons.phone_outlined,
                        label: network.phone!,
                        value: network.phone,
                        trailing: _buildImageIcon(AssetsPath.saveContact,
                            () => _saveContactToDevice(context)),
                        context: context,
                      ),

                    // Address
                    if (network.address != null && network.address!.isNotEmpty)
                      _buildContactItem(
                          icon: Icons.location_on_outlined,
                          label: network.address!,
                          value: network.address,
                          trailing: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: _buildImageIcon(
                                  AssetsPath.googleMap,
                                  () => _openGoogleMaps(
                                      network.address, context))),
                          context: context),

                    // Website
                    if (network.website != null && network.website!.isNotEmpty)
                      _buildContactItem(
                        icon: Icons.language,
                        label: network.website!,
                        value: network.website,
                        trailing: _buildImageIcon(
                          AssetsPath.webview,
                          () => _openWebsite(network.website, context),
                        ),
                        context: context,
                      ),
                  ],
                ),
                Gap(AppDimensions.spacing32),
              ],
            ),
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
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap ??
          (value != null ? () => _copyToClipboard(value, context) : null),
      splashColor: Colors.transparent,
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

  Widget _buildImageIcon(String image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        image,
        height: 24,
        width: 24,
      ),
    );
  }
}
