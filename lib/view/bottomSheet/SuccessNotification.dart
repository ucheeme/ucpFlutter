import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif/gif.dart';
import 'package:lottie/lottie.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/constant.dart';

import '../../utils/appStrings.dart';

class LoadLottie extends StatefulWidget {
  final String lottiePath;
  final String? bottomText;
  const LoadLottie({super.key, required this.lottiePath, this.bottomText});

  @override
  State<LoadLottie> createState() => _LoadLottieState();
}

class _LoadLottieState extends State<LoadLottie> with TickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
    _gifController.repeat( period: Duration(seconds: 5)); // Control GIF frame duration
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ucpWhite500,
      body: Container(
        height: 439.h,
        width: 375.w,
        decoration: BoxDecoration(
            color: AppColor.ucpWhite500,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height:300.h ,
              width: 300.w,
              child: Lottie.asset(widget.lottiePath,controller: _gifController),
            ),
            if (widget.bottomText != null)
              Text(
                widget.bottomText!,
                textAlign: TextAlign.center,
                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  color: AppColor.ucpBlack500,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}



