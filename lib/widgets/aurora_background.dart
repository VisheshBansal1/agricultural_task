import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class AuroraBackground extends StatefulWidget {
  final Widget? child;
  final bool animate;

  const AuroraBackground({super.key, this.child, this.animate = true});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(decoration: BoxDecoration(gradient: AppGradients.hero)),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = widget.animate ? _controller.value : 0.0;
                return Stack(
                  children: [
                    _blob(
                      color: AppColors.secondary,
                      size: 220,
                      left: -60 + (40 * (0.5 - (t - 0.5).abs())),
                      top: -70,
                    ),
                    _blob(
                      color: AppColors.accent,
                      size: 180,
                      right: -50,
                      top: 40 + (30 * t),
                      opacity: 0.28,
                    ),
                    _blob(
                      color: AppColors.secondary,
                      size: 160,
                      right: 30 - (20 * t),
                      bottom: -50,
                      opacity: 0.22,
                    ),
                  ],
                );
              },
            ),
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }

  Widget _blob({required Color color, required double size, double? left, double? right, double? top, double? bottom, double opacity = 0.35}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(color: color.withOpacity(opacity), shape: BoxShape.circle),
        ),
      ),
    );
  }
}
