import 'package:flutter/material.dart';

class StaggeredFadeIn extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration baseDelay;
  final Duration duration;

  const StaggeredFadeIn({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = const Duration(milliseconds: 45),
    this.duration = const Duration(milliseconds: 380),
  });

  @override
  Widget build(BuildContext context) {
    final delayMs = (baseDelay.inMilliseconds * index).clamp(0, 400).toInt();
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration + Duration(milliseconds: delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final totalMs = duration.inMilliseconds + delayMs;
        final progress = ((value * totalMs - delayMs) / duration.inMilliseconds).clamp(0.0, 1.0).toDouble();
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, (1 - progress) * 18),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
