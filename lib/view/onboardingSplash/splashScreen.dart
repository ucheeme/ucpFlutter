import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ucp/data/model/request/loginReq.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/loginFlow/loginD.dart';

import '../../app/customAnimations/animationManager.dart';
import '../../app/main/main.dart';
import '../../bloc/onboarding/on_boarding_bloc.dart';
import '../../utils/appStrings.dart';
import '../../utils/apputils.dart';
import '../../utils/colorrs.dart';
import '../../utils/designUtils/reusableWidgets.dart';
import '../../utils/sharedPreference.dart';
import '../mainUi/bottomNav.dart';
import 'onBoarding.dart';

bool bioMetric = MySharedPreference.getBiometricStatus();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationManager _animationManager;
  late OnBoardingBloc bloc;
  

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleOnBoardingErrorState(OnBoardingError state) {
    AppUtils.showSnack(
      "${state.errorResponse.message} ${state.errorResponse.data}",
      context,
    );
    bloc.initial();
  }

 
  @override
  Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: AppColor.ucpWhite500,
            // Replace with your AppColor if needed
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Gap(150.h),
                    SizedBox(
                      height: 355.05.h,
                      width: 343.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: _animationManager
                                        .imageSlideAnimation.value *
                                    MediaQuery.of(context).size.width,
                                child: Transform.scale(
                                  scale: _animationManager
                                      .imageScaleAnimation.value,
                                  child: Transform.translate(
                                    offset: _animationManager
                                            .imageSlideUpAnimation.value *
                                        10,
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
                                offset: _animationManager
                                        .contentSlideAnimation.value *
                                    MediaQuery.of(context).size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 52.h,
                                      width: 343.w,
                                      child: Text(
                                        UcpStrings.onboard1,
                                        style: CreatoDisplayCustomTextStyle
                                            .kTxtMedium
                                            .copyWith(
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
                                      child: Text(
                                        UcpStrings.onboard2,
                                        style: CreatoDisplayCustomTextStyle
                                            .kTxtMedium
                                            .copyWith(
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
                   Gap(230.h),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset:
                              _animationManager.contentSlideAnimation.value *
                                  MediaQuery.of(context).size.height,
                          child: CustomButton(
                            onTap: () async {
                            
                                Get.to(OnBoarding());
                              
                            },
                            height: 51.h,
                            width: 343.w,
                            textStyle: CreatoDisplayCustomTextStyle.kTxtMedium
                                .copyWith(
                              color: AppColor.ucpWhite500,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                            ),
                            buttonText: UcpStrings.continueTxt,
                            buttonColor: AppColor.ucpBlue500,
                            borderRadius: 25.r,
                            textColor: AppColor.ucpWhite500,
                            textfontSize: 16.sp,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 100.h,
                    )
                  ],
                ),
              ),
            ),
          );
    
  }
}
