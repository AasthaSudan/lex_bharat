import 'package:flutter/material.dart';
import '../../utils/colors.dart';

/// Production-grade input field component with validation, error states, and accessibility
class AppInputField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isRequired;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onSuffixTap;
  final TextInputAction textInputAction;
  final String? semanticLabel;
  final bool obscureText;

  const AppInputField({
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.textInputAction = TextInputAction.next,
    this.semanticLabel,
    this.obscureText = false,
    super.key,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final isObscured = widget.obscureText && !_showPassword;

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      enabled: !widget.readOnly,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with required indicator
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (widget.isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Input field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isError
                    ? AppColors.error
                    : _isFocused
                    ? AppColors.primary
                    : AppColors.border,
                width: _isFocused || isError ? 2 : 1,
              ),
              color: widget.readOnly ? AppColors.gray100 : AppColors.surface,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              readOnly: widget.readOnly,
              maxLines: isObscured ? 1 : widget.maxLines,
              maxLength: widget.maxLength,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              textInputAction: widget.textInputAction,
              obscureText: isObscured,
              decoration: InputDecoration(
                hintText: widget.hint,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: InputBorder.none,
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: AppColors.textSecondary,
                        size: 20,
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null || widget.obscureText
                    ? GestureDetector(
                        onTap: widget.obscureText
                            ? () =>
                                  setState(() => _showPassword = !_showPassword)
                            : widget.onSuffixTap,
                        child: Icon(
                          widget.obscureText
                              ? (_showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off)
                              : widget.suffixIcon,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      )
                    : null,
                hintStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 14,
                ),
                counterText: '',
              ),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),

          // Character count
          if (widget.maxLength != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${widget.controller?.text.length ?? 0}/${widget.maxLength}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),

          // Error message
          if (isError)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.errorText ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.error,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
