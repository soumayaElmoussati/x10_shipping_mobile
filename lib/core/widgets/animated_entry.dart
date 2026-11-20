import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedEntry extends StatelessWidget {
  final Widget child;
  final int delay;
  final double offset;

  const AnimatedEntry({
    super.key,
    required this.child,
    this.delay = 0,
    this.offset = 22,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(
          duration: 550.ms,
          delay: delay.ms,
        )
        .slideY(
          begin: 0.12,
          end: 0,
          duration: 550.ms,
          delay: delay.ms,
          curve: Curves.easeOutCubic,
        );
  }
}