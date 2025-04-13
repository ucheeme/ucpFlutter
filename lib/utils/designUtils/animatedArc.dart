import 'package:custom_grid_view/custom_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import '../colorrs.dart';


class AnimatedArc extends StatefulWidget {
  Widget? child;
  double? end;
   AnimatedArc({Key? key, this.child,this.end}) : super(key: key);

  @override
  State<AnimatedArc> createState() => _AnimatedArcState();
}

class _AnimatedArcState extends State<AnimatedArc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    print("this os end ${widget.end}");
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    final curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    // Initialize the animation
    _animation = Tween<double>(begin: 0.0, end: widget.end??3.15) // 20% progress
        .animate(curvedAnimation)..addListener((){
          setState(() {

          });
    });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children:[
            CustomPaint(
              size:Size(311.w, 157.8.h),  // Adjust size as needed
              painter: ArcPainter(isBackground: true, arc: null, progressColor: AppColor.ucpBlue100),
              child:  Center(
                child: widget.child
              ),
            ),
            CustomPaint(
              size:  Size(311.w, 157.8.h), // Adjust size as needed
              painter: ArcPainter(isBackground: false, arc: _animation.value, progressColor: AppColor.ucpBlue500),
              child:  Center(
                child: widget.child
              ),
            ),
          ] ,
        );
      },
    );
  }
}

class ArcPainter extends CustomPainter {
  bool isBackground;
  double? arc;
  Color progressColor;
  ArcPainter({required this.isBackground, this.arc,required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rec = Rect.fromLTWH(0.w, 0.h, 300.w, 300.h);
    final startAngle= -math.pi;
    final sweepAngle =arc ?? math.pi;
    final useCenter = false;
    final paint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = progressColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 30;
    if(isBackground){
     // paint.shader = gradient.createShader(rec);
    }
    canvas.drawArc(rec, startAngle, sweepAngle??size.width, useCenter, paint);
    // Define the arc rectangle
    //final Rect arcRect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    // Draw the full arc
    // canvas.drawArc(
    //   rec,
    //   math.pi, // Start angle (180 degrees in radians)
    //   math.pi, // Sweep angle (180 degrees in radians)
    //   false,
    //   fullArcPaint,
    // );

    // // Draw the animated progress arc
    // canvas.drawArc(
    //   arcRect,
    //   math.pi, // Start angle
    //   math.pi * progress, // Animated progress (e.g., 20% of 180 degrees)
    //   false,
    //   progressArcPaint,
    // );
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return true;
  }
     // oldDelegate.progress != progress;
}
