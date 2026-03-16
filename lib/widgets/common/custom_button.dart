import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final IconData? icon;
  final bool isLoading;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
    this.isLoading = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : SizedBox.shrink(),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? AppColors.primary,
          side: BorderSide(color: color ?? AppColors.primary),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
      ),
    );
  }
}