import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/spacing.dart';
import '../../utils/typography.dart';

/// A clean, reusable list item component with icon, title, and optional subtitle
class ListItemCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showBorder;
  final Color? backgroundColor;
  final EdgeInsets padding;

  const ListItemCard({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailingIcon = Icons.chevron_right_rounded,
    this.onTap,
    this.trailing,
    this.showBorder = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.listItemPadding,
      vertical: AppSpacing.sm,
    ),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs4),
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadiusSmall),
            border: showBorder
                ? Border.all(
                    color: AppColors.border,
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.accent).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.componentSpacing),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs2),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              trailing ??
                  (trailingIcon != null
                      ? Icon(
                          trailingIcon,
                          color: AppColors.textHint,
                          size: 20,
                        )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}

