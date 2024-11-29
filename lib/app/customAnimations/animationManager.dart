import 'package:flutter/material.dart';

class AnimationManager {
  final AnimationController controller;
  late Animation<Offset> imageSlideAnimation;
  late Animation<Offset> imageSlideUpAnimation;
  late Animation<double> imageScaleAnimation;
  late Animation<Offset> contentSlideAnimation;

  AnimationManager({required this.controller});

  void initAnimations() {
    // Image slides in from the left
    imageSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    imageSlideUpAnimation = Tween<Offset>(
      begin: Offset.zero, // Start at the original position
      end: const Offset(0.0, -0.1), // Move slightly upward
    ).animate(
      CurvedAnimation(
        parent: controller,
          curve: const Interval(0.7, 1.0, curve: Curves.easeIn)
      ),
    );

    // Image scales down
    imageScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Content slides up with bounce
    contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start off-screen at the bottom
      end: Offset.zero, // Ends at its original position under the image
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve:  const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }
}
