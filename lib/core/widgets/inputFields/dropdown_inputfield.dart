import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../constants/app_borders.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_style.dart';

class DropdownTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> itemList;
  final String selectValue;
  final Function(dynamic value)? onChanged;
  final String initialValue;

  const DropdownTextField({
    super.key,
    required this.label,
    this.hintText = '',
    required this.itemList,
    required this.selectValue,
    this.onChanged,
    this.initialValue = '',
  });

  @override
  State<DropdownTextField> createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.black)),
        Gap(AppDimensions.spacing8),
        SizedBox(
          height: 56,
          child: FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.hintText,
                  focusedBorder: AppBorders.focusOutLineBorder,
                  enabledBorder: AppBorders.enableOutLineBorder,
                  errorBorder: AppBorders.outlineErrorBorder,
                  focusedErrorBorder: AppBorders.outlineErrorBorder,
                  filled: true,
                  fillColor: Colors.white,
                ),
                // isEmpty: widget.selectValue == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.selectValue,
                    onChanged: widget.onChanged,
                    style: AppTextStyles.labelMedium.copyWith(color: Colors.black),
                    items: widget.itemList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
