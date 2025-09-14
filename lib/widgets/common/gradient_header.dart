import 'package:flutter/material.dart';
import '../../utils/color_scheme.dart';

/// A beautiful gradient header widget showcasing the Geny-inspired design
class GradientHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final double height;
  final bool showPattern;

  const GradientHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.height = 200.0,
    this.showPattern = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColorScheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          if (showPattern) _buildBackgroundPattern(),
          
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (trailing != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildTitleSection()),
                        trailing!,
                      ],
                    )
                  else
                    _buildTitleSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: AppColorScheme.textOnPrimary,
            height: 1.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8.0),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 16.0,
              color: AppColorScheme.textOnPrimary.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GradientPatternPainter(),
      ),
    );
  }
}

class _GradientPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColorScheme.textOnPrimary.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw circular patterns similar to Geny app
    final centerX = size.width * 0.8;
    final centerY = size.height * 0.3;
    
    // Large circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      60.0,
      paint,
    );
    
    // Medium circle
    canvas.drawCircle(
      Offset(centerX - 40, centerY + 50),
      35.0,
      paint..color = AppColorScheme.textOnPrimary.withValues(alpha: 0.08),
    );
    
    // Small circles
    canvas.drawCircle(
      Offset(centerX + 30, centerY - 20),
      20.0,
      paint..color = AppColorScheme.textOnPrimary.withValues(alpha: 0.06),
    );
    
    canvas.drawCircle(
      Offset(centerX - 70, centerY - 30),
      15.0,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Circular gradient widget similar to the Geny app design
class CircularGradientWidget extends StatelessWidget {
  final double size;
  final Widget? child;
  final bool animate;

  const CircularGradientWidget({
    super.key,
    this.size = 120.0,
    this.child,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget gradientContainer = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: AppColorScheme.circularGradient,
        shape: BoxShape.circle,
      ),
      child: child != null
          ? Center(child: child!)
          : null,
    );

    if (animate) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: gradientContainer,
          );
        },
      );
    }

    return gradientContainer;
  }
}
