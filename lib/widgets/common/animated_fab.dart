import 'package:flutter/material.dart';
import '../../utils/animation_utils.dart';
import '../../utils/color_scheme.dart';

/// Enhanced Floating Action Button with beautiful animations
class AnimatedFAB extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? tooltip;
  final Color? backgroundColor;
  final bool mini;
  final String? heroTag;

  const AnimatedFAB({
    super.key,
    this.onPressed,
    this.child,
    this.tooltip,
    this.backgroundColor,
    this.mini = false,
    this.heroTag,
  });

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: AnimationUtils.slowDuration,
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: AnimationUtils.normalDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: AnimationUtils.bounceCurve,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25, // Quarter turn
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: AnimationUtils.smoothCurve,
    ));
    
    // Start entrance animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onPressed() {
    if (widget.onPressed != null) {
      // Micro-interaction: quick rotation on press
      _rotationController.forward().then((_) {
        _rotationController.reverse();
      });
      
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.mini ? 28.0 : 32.0),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.backgroundColor ?? AppColorScheme.primaryGreen)
                            .withValues(alpha: 0.3),
                        blurRadius: 16.0,
                        offset: const Offset(0, 8.0),
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: _onPressed,
                    backgroundColor: widget.backgroundColor ?? AppColorScheme.primaryGreen,
                    foregroundColor: AppColorScheme.textOnPrimary,
                    mini: widget.mini,
                    heroTag: widget.heroTag,
                    tooltip: widget.tooltip,
                    elevation: 0,
                    child: widget.child,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Expandable FAB menu with smooth animations
class ExpandableFAB extends StatefulWidget {
  final List<FABMenuItem> items;
  final Widget child;
  final Color? backgroundColor;

  const ExpandableFAB({
    super.key,
    required this.items,
    required this.child,
    this.backgroundColor,
  });

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationUtils.normalDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: AnimationUtils.smoothCurve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) {
                  return Container(
                    color: Colors.black.withValues(
                      alpha: (0.3 * _expandAnimation.value).clamp(0.0, 1.0),
                    ),
                  );
                },
              ),
            ),
          ),
        
        // Menu items
        ...widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return Positioned(
            right: 8.0,
            bottom: 80.0 + (index * 70.0), // Stack items vertically
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                final delay = index * 0.1;
                final delayedAnimation = CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    delay.clamp(0.0, 0.8), // Ensure valid interval
                    1.0,
                    curve: AnimationUtils.bounceCurve,
                  ),
                );
                
                final animationValue = delayedAnimation.value.clamp(0.0, 1.0);
                
                return Transform.scale(
                  scale: animationValue,
                  child: Opacity(
                    opacity: animationValue,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.label != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4.0,
                                  offset: const Offset(0, 2.0),
                                ),
                              ],
                            ),
                            child: Text(
                              item.label!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                        ],
                        FloatingActionButton(
                          mini: true,
                          onPressed: () {
                            _toggle();
                            item.onPressed?.call();
                          },
                          backgroundColor: item.backgroundColor,
                          child: item.icon,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
        
        // Main FAB
        AnimatedFAB(
          onPressed: _toggle,
          backgroundColor: widget.backgroundColor,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0.0, // 45 degrees
            duration: AnimationUtils.normalDuration,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class FABMenuItem {
  final Widget icon;
  final String? label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const FABMenuItem({
    required this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
  });
}
