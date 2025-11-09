import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing16),
            itemCount: _tools.length,
            separatorBuilder: (context, index) => Gap(AppDimensions.spacing16),
            itemBuilder: (context, index) {
              final tool = _tools[index];
              return _ToolListItem(
                icon: tool.icon,
                title: tool.title,
                subtitle: tool.subtitle,
                onTap: tool.onTap,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Tool {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  _Tool({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}

final List<_Tool> _tools = [
  _Tool(
    icon: _ImageToTextIcon(),
    title: 'Image to Text',
    subtitle: 'Converts images to editable text.',
  ),
  _Tool(
    icon: _ConvertPdfIcon(),
    title: 'Convert PDF',
    subtitle: 'Convert documents & images into PDFs',
  ),
  _Tool(
    icon: _SignDocumentIcon(),
    title: 'Sign Document',
    subtitle: 'Sign documents digitally',
  ),
  _Tool(
    icon: _AddTaskIcon(),
    title: 'Add Task',
    subtitle: 'Create new tasks for your to-do list.',
  ),
];

class _ToolListItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ToolListItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Row(
          children: [
            SizedBox(
              width: 48.w,
              height: 48.w,
              child: icon,
            ),
            Gap(AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray800,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.gray700,
              size: AppDimensions.icon24,
            ),
          ],
        ),
      ),
    );
  }
}

// Image to Text Icon
class _ImageToTextIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          // Document background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          // Scanner frame overlay
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.secondary,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
          // Text lines inside document
          Positioned(
            left: 10.w,
            right: 10.w,
            top: 20.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 2.h,
                  color: AppColors.secondary,
                ),
                Gap(4.h),
                Container(
                  width: 60.w,
                  height: 2.h,
                  color: AppColors.secondary,
                ),
                Gap(4.h),
                Container(
                  width: 40.w,
                  height: 2.h,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Convert PDF Icon
class _ConvertPdfIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // PDF document
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.gray200,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Stack(
            children: [
              // PDF text
              Positioned(
                top: 6.h,
                left: 6.w,
                child: Text(
                  'PDF',
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray800,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Conversion arrows
        Positioned(
          bottom: 2.h,
          left: 12.w,
          right: 12.w,
          child: Container(
            height: 12.h,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 10.w,
                  color: Colors.white,
                ),
                Gap(2.w),
                Icon(
                  Icons.arrow_forward,
                  size: 10.w,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Sign Document Icon
class _SignDocumentIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Document
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.gray200,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 2.h,
                  color: AppColors.gray400,
                ),
                Gap(3.h),
                Container(
                  width: 20.w,
                  height: 2.h,
                  color: AppColors.gray400,
                ),
                Gap(3.h),
                Container(
                  width: 15.w,
                  height: 2.h,
                  color: AppColors.gray400,
                ),
              ],
            ),
          ),
        ),
        // Pen icon
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit,
              size: 12.w,
              color: Colors.white,
            ),
          ),
        ),
        // Signature line on document
        Positioned(
          bottom: 8.h,
          left: 8.w,
          right: 12.w,
          child: CustomPaint(
            size: Size(28.w, 4.h),
            painter: _SignaturePainter(),
          ),
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.8,
        size.width * 0.6, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.6, size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Add Task Icon
class _AddTaskIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Clipboard
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.gray200,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Stack(
            children: [
              // Clip at top
              Positioned(
                top: 0,
                left: 18.w,
                child: Container(
                  width: 12.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2.r),
                      topRight: Radius.circular(2.r),
                    ),
                  ),
                ),
              ),
              // Task lines
              Positioned(
                top: 12.h,
                left: 8.w,
                right: 8.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TaskLine(completed: true),
                    Gap(4.h),
                    _TaskLine(completed: true),
                    Gap(4.h),
                    _TaskLine(completed: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TaskLine extends StatelessWidget {
  final bool completed;

  const _TaskLine({required this.completed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (completed)
          Icon(
            Icons.check_circle,
            size: 10.w,
            color: AppColors.success,
          )
        else
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.gray400,
                width: 1.5,
              ),
            ),
          ),
        Gap(4.w),
        Expanded(
          child: Container(
            height: 1.5.h,
            color: AppColors.gray400,
          ),
        ),
      ],
    );
  }
}
