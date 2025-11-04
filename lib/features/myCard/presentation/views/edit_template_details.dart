import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/utils/assets_path.dart';
import 'package:screenshot/screenshot.dart';
import '../../../../core/widgets/card_info_tile.dart';

class EditTemplateDetails extends StatefulWidget {
  final String imagePath;

  const EditTemplateDetails({super.key, required this.imagePath});

  @override
  State<EditTemplateDetails> createState() => _EditTemplateDetailsState();
}

class _EditTemplateDetailsState extends State<EditTemplateDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFormatIndex = 0;
  int _selectedBackgroundIndex = 0;

  // Sample card formats (layouts)
  final List<CardFormat> _cardFormats = [
    CardFormat(id: 0, name: 'Format 1'),
    CardFormat(id: 1, name: 'Format 2'),
    CardFormat(id: 2, name: 'Format 3'),
    CardFormat(id: 3, name: 'Format 4'),
  ];

  // Card backgrounds (using available templates)
  final List<String> _cardBackgrounds = [
    AssetsPath.manualCardBg,
    AssetsPath.temp2,
    AssetsPath.temp3,
    AssetsPath.temp4,
    AssetsPath.temp5,
    AssetsPath.temp6,
    AssetsPath.temp7,
    AssetsPath.temp8,
    AssetsPath.temp9,
    AssetsPath.temp10,
  ];

  // fields controllers
  final TextEditingController _whereYouMetController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  // Screenshot controller for capturing the card preview widget
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Set initial background to match the passed imagePath
    final index = _cardBackgrounds.indexOf(widget.imagePath);
    if (index != -1) {
      _selectedBackgroundIndex = index;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Details',
          style: AppTextStyles.headline4.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Card Preview Section
          _buildCardPreview(),
          Gap(AppDimensions.spacing16),

          // Tab Bar
          _buildTabBar(),
          Gap(AppDimensions.spacing16),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDesignTab(),
                _buildDetailsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle save action
          Navigator.of(context).pop();
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Screenshot(
        controller: _screenshotController,
        child: Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage(AssetsPath.manualCardBg),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text,
                          style: AppTextStyles.headline1
                              .copyWith(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          _jobTitleController.text,
                          style: AppTextStyles.headline3
                              .copyWith(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        if (_companyController.text.isNotEmpty) ...[
                          const Icon(
                            Icons.domain,
                            color: Colors.white,
                            size: 42,
                          ),
                        ],
                        Text(
                          _companyController.text,
                          style: AppTextStyles.headline1
                              .copyWith(fontSize: 14, color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardInfoTile(
                        icon: Icons.phone, info: _phoneController.text),
                    const Gap(2),
                    CardInfoTile(
                        icon: Icons.location_on_outlined,
                        info: _addressController.text),
                    const Gap(2),
                    CardInfoTile(
                        icon: Icons.email, info: _emailController.text),
                    const Gap(2),
                    CardInfoTile(
                        icon: Icons.language_outlined,
                        info: _websiteController.text),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: color),
        Gap(8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10.sp,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.gray700,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        tabs: const [
          Tab(text: 'Design'),
          Tab(text: 'Details'),
        ],
      ),
    );
  }

  Widget _buildDesignTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Card Format Section
          Text(
            'Select Card Format',
            style: AppTextStyles.headline4.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(AppDimensions.spacing12),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _cardFormats.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFormatIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFormatIndex = index;
                    });
                  },
                  child: Container(
                    width: 80.w,
                    margin: EdgeInsets.only(right: AppDimensions.spacing12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.gray300
                          : AppColors.gray100,
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.secondary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Format preview (simple layout preview)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40.w,
                                height: 4.h,
                                color: AppColors.gray600,
                                margin: EdgeInsets.only(bottom: 4.h),
                              ),
                              Container(
                                width: 40.w,
                                height: 4.h,
                                color: AppColors.gray600,
                                margin: EdgeInsets.only(bottom: 4.h),
                              ),
                              Container(
                                width: 40.w,
                                height: 4.h,
                                color: AppColors.gray600,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 4.h,
                            right: 4.w,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Gap(AppDimensions.spacing24),

          // Select Card Background Section
          Text(
            'Select Card Background',
            style: AppTextStyles.headline4.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(AppDimensions.spacing12),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _cardBackgrounds.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedBackgroundIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBackgroundIndex = index;
                    });
                  },
                  child: Container(
                    width: 80.w,
                    margin: EdgeInsets.only(right: AppDimensions.spacing12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.secondary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimensions.radius8),
                      child: Stack(
                        children: [
                          Image.asset(
                            _cardBackgrounds[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          if (isSelected)
                            Positioned(
                              top: 4.h,
                              right: 4.w,
                              child: Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: AppColors.secondary,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
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

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Details',
            style: AppTextStyles.headline4.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(AppDimensions.spacing16),
          // Add form fields for editing card details here
          Text(
            'Edit card information',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class CardFormat {
  final int id;
  final String name;

  CardFormat({required this.id, required this.name});
}

// Custom painter for red angular shapes in top-right corner
class RedAnglesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.fill;

    // Draw angular shapes
    final path = Path()
      ..moveTo(size.width * 0.3, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.2)
      ..close();

    final path2 = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
