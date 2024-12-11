import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/constant.dart';

import '../../app/customAnimations/animationManager.dart';
import '../../utils/appStrings.dart';
import '../../utils/colorrs.dart';
import '../../utils/designUtils/reusableWidgets.dart';
import 'onBoarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationManager _animationManager;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Initialize the AnimationManager
    _animationManager = AnimationManager(controller: _controller);
    _animationManager.initAnimations();

    // Start the animation after a small delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
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
      backgroundColor: AppColor.ucpWhite500, // Replace with your AppColor if needed
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(212.h),
              SizedBox(
                height: 350.05.h,
                width: 343.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _animationManager.imageSlideAnimation.value *
                              MediaQuery.of(context).size.width,
                          child: Transform.scale(
                            scale: _animationManager.imageScaleAnimation.value,
                            child: Transform.translate(
                              offset: _animationManager.imageSlideUpAnimation.value*10,
                              child: Image.asset(
                                'assets/images/UCP_logo_no_BG.png', // Replace with your image asset
                                 // Replace with responsive dimensions if needed
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _animationManager.contentSlideAnimation.value *
                              MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 52.h,
                                width: 343.w,
                                child:  Text(
                                  UcpStrings.onboard1,
                                  style:CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.ucpBlack800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                //height: 96.h,
                                width: 343.w,
                                child:  Text(
                                  UcpStrings.onboard2,
                                  style:CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.ucpBlack800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
             Gap(188.95.h),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: _animationManager.contentSlideAnimation.value *
                        MediaQuery.of(context).size.height,
                    child:CustomButton(
                      onTap: () { Get.to(OnBoarding()); },
                      height: 51.h,
                      width: 343.w,
                      textStyle:CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          color:AppColor.ucpWhite500,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                      ) ,
                      buttonText: UcpStrings.continueTxt,
                      buttonColor: AppColor.ucpBlue500,
                      borderRadius: 25.r,
                      textColor: AppColor.ucpWhite500,
                      textfontSize: 16.sp,
                    ),
                  );
                },
              ),
          
              height47
            ],
          ),
        ),
      ),
    );
  }
}
