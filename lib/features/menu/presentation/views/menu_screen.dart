import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/delete_account_cubit.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/logout_cubit.dart';
import 'package:business_card_scanner/features/menu/presentation/widgets/menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/custom_snack.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (!context.mounted) return;
            if (state is LogoutFailure) {
              CustomSnack.warning(state.message, context);
            }
            if (state is LogoutSuccess) {
              CustomSnack.success('You have been logged out.', context);
              final router = GoRouter.of(context);
              context.read<LogoutCubit>().reset();
              router.go(Routes.login);
            }
          },
        ),
        BlocListener<DeleteAccountCubit, DeleteAccountState>(
          listener: (context, state) {
            if (!context.mounted) return;
            if (state is DeleteAccountFailure) {
              CustomSnack.warning(state.message, context);
            }
            if (state is DeleteAccountSuccess) {
              CustomSnack.success(
                  'Your account has been deleted permanently.', context);
              final router = GoRouter.of(context);
              context.read<DeleteAccountCubit>().reset();
              router.go(Routes.login);
            }
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight.withOpacity(0.2),
                        border: Border.all(color: AppColors.primary)),
                    child: Center(
                      child: Text(
                        'KI',
                        style: AppTextStyles.headline3
                            .copyWith(  color: AppColors.primary),
                      ),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Email',
                    style: AppTextStyles.headline3
                        .copyWith(fontSize: 16, color: Colors.black),
                  ),
                  Gap(AppDimensions.spacing32),
                  // privacy
                  MenuTile(
                      onTap: () => context.push(Routes.privacyPolicy),
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy'),
                  Gap(AppDimensions.spacing16),
                  // Terms
                  MenuTile(
                      onTap: () => context.push(Routes.termsConditions),
                      icon: Icons.rule,
                      title: 'Terms & Conditions'),
                  // Gap(AppDimensions.spacing16),
                  // // Share us
                  // const MenuTile(icon: Icons.share_outlined, title: 'Share Us'),
                  // Gap(AppDimensions.spacing16),
                  // // Rate us
                  // const MenuTile(icon: Icons.star, title: 'Rate Us'),
                  Gap(AppDimensions.spacing16),
                  // Logout
                  BlocBuilder<LogoutCubit, LogoutState>(
                    builder: (context, state) {
                      final isLoading = state is LogoutLoading;
                      return MenuTile(
                        onTap: isLoading ? null : () => _confirmLogout(context),
                        icon: Icons.logout_outlined,
                        title: isLoading ? 'Logging out...' : 'Logout',
                        iconColor: Colors.red,
                      );
                    },
                  ),
                  Gap(AppDimensions.spacing16),
                  // Delete
                  BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                    builder: (context, state) {
                      final isDeleting = state is DeleteAccountLoading;
                      return MenuTile(
                        onTap: isDeleting
                            ? null
                            : () => _confirmDeleteAccount(context),
                        icon: Icons.delete_forever_outlined,
                        title: isDeleting ? 'Deleting...' : 'Delete Account',
                        iconColor: Colors.red,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final logoutCubit = context.read<LogoutCubit>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              'Confirm Logout',
              style: AppTextStyles.headline4
                  .copyWith(fontSize: 18, color: AppColors.gray900),
            ),
          ],
        ),
        content: Text(
          'You are about to log out of your account. Do you want to continue?',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              logoutCubit.logout();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final deleteAccountCubit = context.read<DeleteAccountCubit>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              'Delete Account',
              style: AppTextStyles.headline4
                  .copyWith(fontSize: 18, color: AppColors.gray900),
            ),
          ],
        ),
        content: Text(
          'This action will permanently erase your account and data. Do you wish to continue?',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteAccountCubit.deleteAccount();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
