import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Gradient elevated button widget
class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final BorderRadius? borderRadius;

  const GradientButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 52,
    this.padding,
    this.gradient,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? (gradient ?? AppColors.primaryGradient)
            : LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              ),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : DefaultTextStyle(
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outline gradient button
class GradientOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final Gradient? gradient;
  final BorderRadius? borderRadius;

  const GradientOutlineButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height = 52,
    this.gradient,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveGradient = gradient ?? AppColors.primaryGradient;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    effectiveGradient.createShader(bounds),
                child: DefaultTextStyle(
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
