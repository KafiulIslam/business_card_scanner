import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:business_card_scanner/features/myCard/presentation/cubit/my_card_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCardListItem extends StatelessWidget {
  final MyCardModel card;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const MyCardListItem({
    super.key,
    required this.card,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format date
    String dateText = '';
    if (card.createdAt != null) {
      final date = card.createdAt!;
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      dateText = '${date.day} ${months[date.month - 1]}, ${date.year}';
    }

    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          image: DecorationImage(
              image: NetworkImage(card.imageUrl ?? ''), fit: BoxFit.cover)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white)),
            child: Center(
              child: PopupMenuButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 18,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    onTap: () {
                      Future.microtask(() {
                        _showDeleteConfirmationDialog(context);
                      });
                    },
                    child: Text('Delete'),
                  ),
                  const PopupMenuItem(child: Text('Share')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Card'),
          content: const Text(
              'Are you sure you want to delete this card? This action cannot be undone.'),
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
                if (card.cardId != null && card.cardId!.isNotEmpty) {
                  context.read<MyCardCubit>().deleteMyCard(card.cardId!);
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
}
