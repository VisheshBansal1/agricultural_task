import 'package:flutter/material.dart';
import '../core/theme.dart';

enum AppButtonVariant { primary, secondary, text, accent }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final child = widget.isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[Icon(widget.icon, size: 18), const SizedBox(width: 8)],
              Text(widget.label),
            ],
          );

    Widget button;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        button = _GradientSurface(
          gradient: _enabled
              ? AppGradients.heroSubtle
              : const LinearGradient(colors: [AppColors.mutedGray, AppColors.mutedGray]),
          glow: _enabled ? AppColors.primary : null,
          pressed: _pressed,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
            child: IconTheme(data: const IconThemeData(color: Colors.white), child: child),
          ),
        );
        break;
      case AppButtonVariant.accent:
        button = _GradientSurface(
          gradient: _enabled
              ? AppGradients.gold
              : const LinearGradient(colors: [AppColors.mutedGray, AppColors.mutedGray]),
          glow: _enabled ? AppColors.accent : null,
          pressed: _pressed,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.textDark),
            child: IconTheme(data: const IconThemeData(color: AppColors.textDark), child: child),
          ),
        );
        break;
      case AppButtonVariant.secondary:
        button = AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 90),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.button),
              border: Border.all(color: _enabled ? AppColors.primary : AppColors.cardBorder, width: 1.4),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: _enabled ? AppColors.primary : AppColors.mutedGray),
              child: IconTheme(data: IconThemeData(color: _enabled ? AppColors.primary : AppColors.mutedGray), child: child),
            ),
          ),
        );
        break;
      case AppButtonVariant.text:
        button = Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.primary),
            child: child,
          ),
        );
        break;
    }

    final wrapped = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
      onTap: _enabled ? widget.onPressed : null,
      child: button,
    );

    return SizedBox(width: widget.width ?? double.infinity, child: wrapped);
  }
}

class _GradientSurface extends StatelessWidget {
  final Gradient gradient;
  final Color? glow;
  final bool pressed;
  final Widget child;

  const _GradientSurface({required this.gradient, required this.glow, required this.pressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadii.button),
          boxShadow: glow != null && !pressed ? AppShadows.glow(glow!) : null,
        ),
        child: child,
      ),
    );
  }
}
