import 'package:flutter/material.dart';
import 'package:sehati_app/core/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final double? radius;
  final Function() onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width,
    this.radius,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height ?? 45,
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: backgroundColor ?? AppColors.blueLagoon,
                foregroundColor: foregroundColor ?? AppColors.white),
            onPressed: onPressed,
            child: Text(text)));
  }
}
