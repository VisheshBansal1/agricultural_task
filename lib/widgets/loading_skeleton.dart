import 'package:flutter/material.dart';
import '../core/theme.dart';

class LoadingSkeleton extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  const LoadingSkeleton({super.key, this.height = 16, this.width, this.borderRadius});

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.4 + (0.3 * (0.5 + 0.5 * (_controller.value * 2 - 1).abs()));
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: AppColors.cardBorder.withOpacity(opacity),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

class ResourceCardSkeleton extends StatelessWidget {
  const ResourceCardSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          LoadingSkeleton(height: 90, borderRadius: BorderRadius.all(Radius.circular(12))),
          SizedBox(height: 10),
          LoadingSkeleton(height: 12, width: 120),
          SizedBox(height: 6),
          LoadingSkeleton(height: 12, width: 80),
        ],
      ),
    );
  }
}
