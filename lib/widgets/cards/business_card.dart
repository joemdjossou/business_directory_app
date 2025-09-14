import 'package:flutter/material.dart';

import '../../data/models/business.dart';
import '../../utils/animation_utils.dart';
import '../../utils/color_scheme.dart';

/// Business-specific card implementation with beautiful animations
class BusinessCard extends StatefulWidget {
  final Business business;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final int? index;

  const BusinessCard({
    super.key,
    required this.business,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.index,
  });

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationUtils.normalDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AnimationUtils.defaultCurve,
    ));

    // Entrance animation with stagger
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        Duration(milliseconds: (widget.index ?? 0) * 100),
        () {
          if (mounted) {
            _controller.forward();
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: AnimatedContainer(
              duration: AnimationUtils.fastDuration,
              curve: AnimationUtils.smoothCurve,
              margin: widget.margin ?? const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              transform: Matrix4.identity()
                ..scale(_isHovered ? 1.02 : 1.0),
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColorScheme.primaryGreen.withValues(
                      alpha: _isHovered ? 0.2 : 0.1,
                    ),
                    blurRadius: _isHovered ? 12.0 : 6.0,
                    offset: Offset(0, _isHovered ? 6.0 : 3.0),
                  ),
                ],
              ),
              child: Card(
                elevation: widget.elevation ?? (_isHovered ? 8.0 : 2.0),
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius ?? BorderRadius.circular(12.0),
                      gradient: _isHovered ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColorScheme.primaryGreen.withValues(alpha: 0.05),
                          AppColorScheme.primaryGreenLight.withValues(alpha: 0.02),
                        ],
                      ) : null,
                    ),
                    child: _buildContent(context),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business name with gradient effect and animation
        AnimatedContainer(
          duration: AnimationUtils.fastDuration,
          transform: Matrix4.identity()
            ..translate(_isHovered ? 4.0 : 0.0, 0.0),
          child: ShaderMask(
            shaderCallback: (bounds) => AppColorScheme.primaryGradient.createShader(bounds),
            child: Text(
              widget.business.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: _isHovered ? 18.0 : 16.0,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 12.0),

        // Location with animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: AnimationUtils.normalDuration,
          curve: AnimationUtils.smoothCurve,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildInfoRow(
                  context,
                  Icons.location_on,
                  widget.business.location,
                  AppColorScheme.error,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8.0),

        // Contact number with animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: AnimationUtils.normalDuration,
          curve: AnimationUtils.smoothCurve,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildInfoRow(
                  context,
                  Icons.phone,
                  widget.business.contactNumber,
                  AppColorScheme.info,
                ),
              ),
            );
          },
        ),

        // Action indicator with animation
        if (widget.onTap != null) ...[
          const SizedBox(height: 16.0),
          AnimatedContainer(
            duration: AnimationUtils.fastDuration,
            transform: Matrix4.identity()
              ..translate(_isHovered ? 8.0 : 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedDefaultTextStyle(
                  duration: AnimationUtils.fastDuration,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColorScheme.primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: _isHovered ? 13.0 : 12.0,
                  ),
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 4.0),
                AnimatedRotation(
                  turns: _isHovered ? 0.0 : -0.05,
                  duration: AnimationUtils.fastDuration,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: _isHovered ? 14.0 : 12.0,
                    color: AppColorScheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        AnimatedContainer(
          duration: AnimationUtils.fastDuration,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: _isHovered ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Icon(
            icon,
            size: 16.0,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: AnimatedDefaultTextStyle(
            duration: AnimationUtils.fastDuration,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: _isHovered ? FontWeight.w500 : FontWeight.normal,
            ),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  String getTitle() {
    return widget.business.name;
  }

  String? getSubtitle() {
    return '${widget.business.location} • ${widget.business.contactNumber}';
  }
}