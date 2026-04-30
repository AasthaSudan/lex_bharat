import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─────────────────────────────────────────────────────────────────────────
/// Modern UI Components Library
/// ─────────────────────────────────────────────────────────────────────────

// ──────────────────────────────────────────────────────────────────────────
// Cards & Containers
// ──────────────────────────────────────────────────────────────────────────

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Border? border;
  final List<BoxShadow>? shadows;
  final BorderRadius? borderRadius;
  final GestureTapCallback? onTap;

  const ModernCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor,
    this.border,
    this.shadows,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: border ?? Border.all(color: AppColors.border, width: 1),
        boxShadow: shadows ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Buttons
// ──────────────────────────────────────────────────────────────────────────

class ModernButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;

  const ModernButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: SizedBox(
        width: widget.width,
        child: ElevatedButton(
          onPressed: widget.isDisabled || widget.isLoading
              ? null
              : () {
                  _controller.forward().then((_) => _controller.reverse());
                  widget.onPressed();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor ?? AppColors.cta,
            disabledBackgroundColor: (widget.backgroundColor ?? AppColors.cta)
                .withValues(alpha: 0.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            elevation: 0,
          ),
          child: widget.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      (widget.textColor ?? Colors.white)
                          .withValues(alpha: 0.7),
                    ),
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: widget.textColor ?? Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: widget.textColor ?? Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Input Fields
// ──────────────────────────────────────────────────────────────────────────

class ModernTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const ModernTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  late bool _obscure;
  String? _error;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          obscureText: _obscure,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
                : null,
            suffixIcon: widget.suffixIcon != null || widget.obscureText
                ? GestureDetector(
                    onTap: widget.obscureText
                        ? () => setState(() => _obscure = !_obscure)
                        : null,
                    child: Icon(
                      widget.obscureText
                          ? (_obscure
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded)
                          : widget.suffixIcon,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
            filled: true,
            fillColor: AppColors.gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: (value) {
            setState(() {
              _error = widget.validator?.call(value);
            });
          },
        ),
        if (_error != null) ...[
          const SizedBox(height: 6),
          Text(
            _error!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Gradient Badges
// ──────────────────────────────────────────────────────────────────────────

class GradientBadge extends StatelessWidget {
  final String label;
  final LinearGradient gradient;
  final IconData? icon;

  const GradientBadge({
    super.key,
    required this.label,
    required this.gradient,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Info Alerts
// ──────────────────────────────────────────────────────────────────────────

class InfoAlert extends StatelessWidget {
  final String message;
  final AlertType type;
  final IconData? icon;

  const InfoAlert({
    super.key,
    required this.message,
    this.type = AlertType.info,
    this.icon,
  });

  Color get _backgroundColor {
    switch (type) {
      case AlertType.success:
        return AppColors.successTint;
      case AlertType.warning:
        return AppColors.warningTint;
      case AlertType.error:
        return AppColors.errorTint;
      case AlertType.info:
        return AppColors.infoTint;
    }
  }

  Color get _borderColor {
    switch (type) {
      case AlertType.success:
        return AppColors.success.withValues(alpha: 0.2);
      case AlertType.warning:
        return AppColors.warning.withValues(alpha: 0.2);
      case AlertType.error:
        return AppColors.error.withValues(alpha: 0.2);
      case AlertType.info:
        return AppColors.info.withValues(alpha: 0.2);
    }
  }

  Color get _textColor {
    switch (type) {
      case AlertType.success:
        return AppColors.success;
      case AlertType.warning:
        return AppColors.warning;
      case AlertType.error:
        return AppColors.error;
      case AlertType.info:
        return AppColors.info;
    }
  }

  IconData get _defaultIcon {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_rounded;
      case AlertType.warning:
        return Icons.warning_rounded;
      case AlertType.error:
        return Icons.error_rounded;
      case AlertType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Icon(icon ?? _defaultIcon, color: _textColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AlertType { success, warning, error, info }

// ──────────────────────────────────────────────────────────────────────────
// Section Header
// ──────────────────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            if (actionLabel != null)
              GestureDetector(
                onTap: onAction,
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.cta,
                  ),
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Loading Skeleton
// ──────────────────────────────────────────────────────────────────────────

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: AppColors.gray200,
      end: AppColors.gray300,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _colorAnimation.value,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// Empty State
// ──────────────────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 40,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 24),
            ModernButton(
              label: actionLabel!,
              onPressed: onAction ?? () {},
              width: 160,
            ),
          ],
        ],
      ),
    );
  }
}
