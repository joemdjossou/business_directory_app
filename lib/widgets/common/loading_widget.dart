import 'package:flutter/material.dart';

import '../../utils/animation_utils.dart';
import '../../utils/color_scheme.dart';
import '../../utils/constants.dart';

/// Loading state widget with beautiful animations
class LoadingWidget extends StatefulWidget {
  final String? message;
  final bool showSkeleton;

  const LoadingWidget({super.key, this.message, this.showSkeleton = true});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticInOut),
    );

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Beautiful circular gradient loading indicator
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColorScheme.circularGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColorScheme.primaryGreen.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 20.0,
                              spreadRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Icon(
                            Icons.business,
                            color: AppColorScheme.primaryGreen,
                            size: 32.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 32.0),

          // Animated loading message
          if (widget.message != null)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: AnimationUtils.slowDuration,
              curve: AnimationUtils.smoothCurve,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Text(
                      widget.message!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 24.0),

          // Beautiful animated dots
          const LoadingDots(color: AppColorScheme.primaryGreen, size: 10.0),

          // Skeleton cards if enabled
          if (widget.showSkeleton) ...[
            const SizedBox(height: 48.0),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildAnimatedSkeletonCard(context, index);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnimatedSkeletonCard(BuildContext context, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: AnimationUtils.smoothCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.listPadding,
                vertical: 8.0,
              ),
              height: 120.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorScheme.primaryGreen.withValues(alpha: 0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated shimmer title
                    AnimationUtils.shimmerEffect(
                      child: Container(
                        width: 200.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: AppColorScheme.primaryGreen.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    // Animated shimmer location
                    AnimationUtils.shimmerEffect(
                      child: Container(
                        width: 150.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: AppColorScheme.primaryGreen.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Animated shimmer contact
                    AnimationUtils.shimmerEffect(
                      child: Container(
                        width: 120.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: AppColorScheme.primaryGreen.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
