import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_cubit.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_state.dart';
import 'package:business_card_scanner/features/network/presentation/widgets/network_card_list_item.dart';
import 'package:business_card_scanner/features/network/presentation/widgets/empty_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchNetworkCards();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh cards when screen becomes visible again (after navigation)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<NetworkCubit>().state;
        final user = FirebaseAuth.instance.currentUser;
        // Refresh if cards are empty and we're not currently loading
        if (user != null && state.cards.isEmpty && !state.isLoading) {
          _fetchNetworkCards();
        }
      }
    });
  }

  void _fetchNetworkCards() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<NetworkCubit>().fetchNetworkCards(user.uid);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<NetworkModel> _filterCards(List<NetworkModel> cards, String query) {
    if (query.isEmpty) return cards;
    final lowerQuery = query.toLowerCase();
    return cards.where((card) {
      return (card.name?.toLowerCase().contains(lowerQuery) ?? false) ||
          (card.title != null &&
              card.title!.isNotEmpty &&
              card.title!.toLowerCase().contains(lowerQuery)) ||
          (card.company != null &&
              card.company!.isNotEmpty &&
              card.company!.toLowerCase().contains(lowerQuery)) ||
          (card.email != null &&
              card.email!.isNotEmpty &&
              card.email!.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBG,
        // leading: Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: AppColors.primaryLight.withOpacity(0.2),
        //       border: Border.all(color: AppColors.primary),
        //       shape: BoxShape.circle,
        //     ),
        //     child: const Icon(
        //       Icons.person,
        //       color: AppColors.primary,
        //     ),
        //   ),
        // ),
        title: Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: AppTextStyles.hintText,
              fillColor: Colors.transparent,
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.iconColor,
                size: 20.w,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing12,
                vertical: AppDimensions.spacing8,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Header with Profile, Search, and Filter
          // _buildHeader(),
          // Cards List

          Expanded(
            child: BlocBuilder<NetworkCubit, NetworkState>(
              builder: (context, state) {
                if (state.isLoading && state.cards.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                final filteredCards = _filterCards(state.cards, _searchQuery);

                if (filteredCards.isEmpty) {
                  return const Center(
                    child: EmptyCardWidget(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _fetchNetworkCards();
                  },
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: filteredCards.length,
                      separatorBuilder: (context, index) =>
                          Gap(AppDimensions.spacing16),
                      itemBuilder: (context, index) {
                        final card = filteredCards[index];
                        return NetworkCardListItem(
                          card: card,
                          onTap: () => context.push(
                            Routes.networkDetails,
                            extra: card,
                          ),
                          onMoreTap: () {
                            _showCardOptions(context, card);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCardOptions(BuildContext context, NetworkModel card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radius20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: AppColors.primary),
              title: Text('Edit', style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to edit screen
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: AppColors.primary),
              title: Text('Share', style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: AppColors.error),
              title: Text('Delete',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radius20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort & Filter',
              style: AppTextStyles.headline4,
            ),
            Gap(AppDimensions.spacing16),
            ListTile(
              leading: Icon(Icons.sort_by_alpha, color: AppColors.primary),
              title: Text('Sort by Name', style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement sorting
              },
            ),
            ListTile(
              leading: Icon(Icons.date_range, color: AppColors.primary),
              title: Text('Sort by Date', style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement sorting
              },
            ),
          ],
        ),
      ),
    );
  }
}
