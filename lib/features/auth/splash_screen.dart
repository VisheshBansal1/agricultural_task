import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/glass_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..forward();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                FadeTransition(
                  opacity: _controller,
                  child: Text(
                    'From Land to Life',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                const Spacer(),
                ScaleTransition(
                  scale: Tween<double>(begin: 0.85, end: 1).animate(
                      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack)),
                  child: FadeTransition(
                    opacity: _controller,
                    child: Column(
                      children: [
                        GlassContainer(
                          borderRadius: 28,
                          padding: const EdgeInsets.all(22),
                          child: const Text('🌱', style: TextStyle(fontSize: 48)),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                            children: const [
                              TextSpan(text: 'Krishi', style: TextStyle(color: AppColors.accent)),
                              TextSpan(text: 'Rent'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Rent  ·  Grow  ·  Together',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 5,
                          backgroundColor: Colors.white.withOpacity(0.18),
                          valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Growing opportunities...',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white60)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
