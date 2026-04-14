import 'package:flutter/material.dart';
import '../../utils/colors.dart';

/// Production-grade button component with variants, loading state, and accessibility
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isFullWidth;
  final String? semanticLabel;

  const AppButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isFullWidth = false,
    this.semanticLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final padding = _getPadding();
    final textSize = _getTextSize();

    final buttonWidget = _buildButtonContent(padding);

    if (!isFullWidth) {
      return buttonWidget;
    }

    return SizedBox(width: double.infinity, child: buttonWidget);
  }

  Widget _buildButtonContent(EdgeInsets padding) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;
    final effectiveOnPressed = isEnabled ? onPressed : null;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: semanticLabel ?? label,
      child: _buildButton(padding, isEnabled, effectiveOnPressed),
    );
  }

  Widget _buildButton(
    EdgeInsets padding,
    bool isEnabled,
    VoidCallback? onPressed,
  ) {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? AppColors.primary : AppColors.gray300,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.gray300,
            disabledForegroundColor: AppColors.gray500,
            padding: padding,
            elevation: isEnabled ? 0 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _buildLabel(isEnabled),
        );

      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: isEnabled ? AppColors.primary : AppColors.gray500,
            disabledForegroundColor: AppColors.gray500,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: isEnabled ? AppColors.primary : AppColors.gray300,
              width: 1.5,
            ),
          ),
          child: _buildLabel(isEnabled),
        );

      case ButtonVariant.tertiary:
        return TextButton(onPressed: onPressed, child: _buildLabel(isEnabled));

      case ButtonVariant.danger:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? AppColors.error : AppColors.errorTint,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.errorTint,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _buildLabel(isEnabled),
        );

      case ButtonVariant.success:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? AppColors.success
                : AppColors.successTint,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.successTint,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _buildLabel(isEnabled),
        );
    }
  }

  Widget _buildLabel(bool isEnabled) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.secondary
                ? AppColors.primary
                : Colors.white,
          ),
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(
      label,
      style: TextStyle(
        fontSize: _getTextSize(),
        fontWeight: FontWeight.w600,
        color: variant == ButtonVariant.secondary
            ? (isEnabled ? AppColors.primary : AppColors.gray500)
            : null,
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
  }

  double _getTextSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 18;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

enum ButtonVariant { primary, secondary, tertiary, danger, success }

enum ButtonSize { small, medium, large }
