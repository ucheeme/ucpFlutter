import 'package:flutter/material.dart';

class UCPLoadingScreen extends StatelessWidget {
  final Color overlayColor;
  final double transparency;// 0.0 (completely transparent) to 1.0 (completely opaque)
  final Widget child;
  final Widget? loaderWidget;
  final bool visible; // Controls visibility of the overlay

  UCPLoadingScreen({
    Key? key,
    this.overlayColor = Colors.black,
    this.loaderWidget,
    this.transparency = 0.5,
    required this.child,
    this.visible = false, // Default to hidden
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   if (!visible) return  child; // Return an empty widget if not visible

    return Stack(
      children: [
        child,
        Stack(
          children: [
            // Full-screen overlay
            Positioned.fill(
              child: Container(
                color: overlayColor.withOpacity(transparency),
              ),
            ),
            // Center widget
            Center(
              child: loaderWidget ?? const CircularProgressIndicator(),
            ),
          ],
        ),
      ],
    );
  }
}
