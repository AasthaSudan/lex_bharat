import 'package:flutter/material.dart';
import '../../utils/colors.dart';

/// Production-grade card component with various styles and states
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final bool enabled;
  final String? semanticLabel;

  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
    this.border,
    this.shadow,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.onTap,
    this.enabled = true,
    this.semanticLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorder = Border.all(color: AppColors.border, width: 1);

    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      enabled: enabled && onTap != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && onTap != null ? onTap : null,
          borderRadius: borderRadius,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
              border: border ?? defaultBorder,
              boxShadow: shadow ?? AppColors.softShadow,
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Elevated card variant with stronger shadow
class AppElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const AppElevatedCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      shadow: AppColors.elevatedShadow,
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: child,
    );
  }
}

/// Status badge component for displaying status labels
class AppStatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final IconData? icon;
  final bool isSmall;

  const AppStatusBadge({
    required this.label,
    this.type = StatusBadgeType.info,
    this.icon,
    this.isSmall = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, textColor) = _getColors();
    final padding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    final fontSize = isSmall ? 12.0 : 14.0;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 12 : 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _getColors() {
    switch (type) {
      case StatusBadgeType.success:
        return (AppColors.successTint, AppColors.success);
      case StatusBadgeType.warning:
        return (AppColors.warningTint, AppColors.warning);
      case StatusBadgeType.error:
        return (AppColors.errorTint, AppColors.error);
      case StatusBadgeType.info:
        return (AppColors.infoTint, AppColors.info);
    }
  }
}

enum StatusBadgeType { success, warning, error, info }

/// Divider component
class AppDivider extends StatelessWidget {
  final Color? color;
  final double height;
  final EdgeInsets? padding;

  const AppDivider({
    this.color = AppColors.border,
    this.height = 1,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Divider(color: color, height: height, thickness: height),
    );
  }
}

/// Section header component
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onViewMore;
  final bool showViewMore;

  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.onViewMore,
    this.showViewMore = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showViewMore && onViewMore != null)
          GestureDetector(
            onTap: onViewMore,
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Info box component for displaying tips and important information
class AppInfoBox extends StatelessWidget {
  final String message;
  final InfoBoxType type;
  final IconData? customIcon;
  final VoidCallback? onDismiss;

  const AppInfoBox({
    required this.message,
    this.type = InfoBoxType.info,
    this.customIcon,
    this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, borderColor, iconColor) = _getColors();
    final icon = customIcon ?? _getDefaultIcon();

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, color: iconColor, height: 1.4),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close_rounded, color: iconColor, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case InfoBoxType.success:
        return Icons.check_circle_outline_rounded;
      case InfoBoxType.warning:
        return Icons.warning_amber_rounded;
      case InfoBoxType.error:
        return Icons.error_outline_rounded;
      case InfoBoxType.info:
        return Icons.info_outline_rounded;
    }
  }

  (Color, Color, Color) _getColors() {
    switch (type) {
      case InfoBoxType.success:
        return (AppColors.successTint, AppColors.success, AppColors.success);
      case InfoBoxType.warning:
        return (AppColors.warningTint, AppColors.warning, AppColors.warning);
      case InfoBoxType.error:
        return (AppColors.errorTint, AppColors.error, AppColors.error);
      case InfoBoxType.info:
        return (AppColors.infoTint, AppColors.info, AppColors.info);
    }
  }
}

enum InfoBoxType { success, warning, error, info }
