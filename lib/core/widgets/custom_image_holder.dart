import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class CustomImageHolder extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final bool isCircle;
  final Widget errorWidget;

  const CustomImageHolder(
      {super.key,
        required this.imageUrl,
        required this.height,
        required this.width,
        this.isCircle = true,
        required this.errorWidget});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(8),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => const Padding(
        padding: EdgeInsets.all(6.0),
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.scaffoldBG,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: errorWidget,
      ),
    );
  }
}
