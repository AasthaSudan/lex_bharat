import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/spacing.dart';
import '../../utils/typography.dart';

/// A custom, beautiful app bar with flexible options
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color backgroundColor;
  final bool showBackButton;
  final Widget? titleWidget;
  final double elevation;

  const CustomAppBar({
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions,
    this.backgroundColor = AppColors.background,
    this.showBackButton = true,
    this.titleWidget,
    this.elevation = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: AppSpacing.screenPadding),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack ?? () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            )
          : null,
      leadingWidth: showBackButton ? 56 : 0,
      title: titleWidget ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTypography.titleLarge,
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
      actions: actions,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

