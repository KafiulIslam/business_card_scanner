import 'package:business_card_scanner/core/widgets/buttons/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/routes/routes.dart';
import '../cubit/my_card_cubit.dart';
import '../cubit/my_card_state.dart';
import '../widgets/my_card_list_item.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({super.key});

  @override
  State<MyCardScreen> createState() => _MyCardScreenState();
}

class _MyCardScreenState extends State<MyCardScreen> {

  @override
  void initState() {
    super.initState();
    _fetchMyCards();
  }

  void _fetchMyCards() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<MyCardCubit>().fetchMyCards(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<MyCardCubit, MyCardState>(
        builder: (context, state) {
          return Scaffold(
            body: _buildBody(state),
            floatingActionButton: state.cards.isNotEmpty
                ? CustomFloatingButton(
                    icon: Icons.add,
                    onTap: () => context.push(Routes.chooseTemplate),
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildBody(MyCardState state) {
    if (state.isLoading && state.cards.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    // Show create card widget if no cards
    if (state.cards.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          child: _buildCreateCardWidget(context),
        ),
      );
    }

    // Show cards list
    return RefreshIndicator(
      onRefresh: () async {
        _fetchMyCards();
      },
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: state.cards.length,
          separatorBuilder: (context, index) => Gap(AppDimensions.spacing16),
          itemBuilder: (context, index) {
            final card = state.cards[index];
            return MyCardListItem(
              card: card,
              onTap: () {
                // TODO: Navigate to card details
              },
              onMoreTap: () {
                // TODO: Show card options
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCreateCardWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(Routes.chooseTemplate);
      },
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
          vertical: AppDimensions.spacing48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCardIcon(),
            Gap(AppDimensions.spacing16),
            Text(
              'Tap Here to Create Your Digital Business Card',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardIcon() {
    return SizedBox(
      width: 140.w,
      height: 100.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card outline - positioned to allow plus sign overlap
          Positioned(
            left: 10.w,
            top: 10.h,
            child: Container(
              width: 120.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 30.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Blue plus sign overlay overlapping bottom-left corner of card
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 32.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
