import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/designUtils/reusableWidgets.dart';
import 'package:ucp/view/mainUi/otpScreen.dart';

import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../loginFlow/loginD.dart';

class AwaitCooperativeResponse extends StatefulWidget {
  const AwaitCooperativeResponse({super.key});

  @override
  State<AwaitCooperativeResponse> createState() => _AwaitCooperativeResponseState();
}

class _AwaitCooperativeResponseState extends State<AwaitCooperativeResponse> {
  late Timer _timer;
  int _remainingTime = 172800;// 1 hour in seconds
  String hoursString = "";
  String minutesString = "";
  String secondsString = "";
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

   _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;
    setState(() {
      hoursString = hours.toString().padLeft(2, '0');
      minutesString = minutes.toString().padLeft(2, '0');
      secondsString = secs.toString().padLeft(2, '0');
    });

    print("hours: $hoursString, minutes: $minutesString, seconds: $secondsString");
  //  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  @override
  Widget build(BuildContext context) {
    _formatTime(_remainingTime);
    return Scaffold(
      backgroundColor: AppColor.ucpWhite500,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 13.w,vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              height30,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Image.asset(
                      "assets/images/arrow-left.png",
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                ),
              ),
              height16,
              Image.asset(
                UcpStrings.ucpLogo, height: 35.h,),
              height50,
              Text(UcpStrings.awaitCooperativeResponse,
                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontWeight: FontWeight.w500,
                    fontSize: 24.sp,color: AppColor.ucpBlack500),),
              height24,
              Text(UcpStrings.awaitCooperativeResponseBody,
                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,color: AppColor.ucpBlack700),),
              height24,
              Text(UcpStrings.awaitCooperativeResponseBody2,
                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,color: AppColor.ucpBlack700),),
              Gap(100.h),
              Container(
                height: 52.h,
                width: 343.w,
                padding: EdgeInsets.symmetric(horizontal: 20.w,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColor.ucpOrange50,
                ),
                child: Center(
                  child: Text(UcpStrings.applicationSent,
                    textAlign: TextAlign.center,
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,color: AppColor.ucpBlack700),),
                ),
              ),
              height40,
              SizedBox(
                height: 44.h,
                child: Row(
                  children: [
                    Container(
                      height: 44.h,
                      width: 47.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColor.ucpWhite10,
                      ),
                      child: Center(
                        child: Text(hoursString.split('').first,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp,color: AppColor.ucpBlack500),),
                      ),
                    ),
                    Gap(5.w),
                    Container(
                      height: 44.h,
                      width: 47.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColor.ucpWhite10,
                      ),
                      child: Center(
                        child: Text(hoursString.split('').last,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp,color: AppColor.ucpBlack500),),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 9.w,),
                    child: Text(":",
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,color: AppColor.ucpBlack500),),
                    ),
                    Container(
                      height: 44.h,
                      width: 47.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColor.ucpWhite10,
                      ),
                      child: Center(
                        child: Text(minutesString.split('').first,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp,color: AppColor.ucpBlack500),),
                      ),
                    ),
                    Gap(5.w),
                    Container(
                      height: 44.h,
                      width: 47.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColor.ucpWhite10,
                      ),
                      child: Center(
                        child: Text(minutesString.split('').last,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp,color: AppColor.ucpBlack500),),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 9.w,),
                      child: Text(":",
                        style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,color: AppColor.ucpBlack500),),
                    ),
                    Container(
                      height: 44.h,
                      width: 47.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColor.ucpWhite10,
                      ),
                      child: Center(
                        child: Text(secondsString.split('').first,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp,color: AppColor.ucpBlack500),),
                      ),
                    ),
                    Gap(5.w),
                    Container(
                      height: 44.h,
                      width: 47.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColor.ucpWhite10,
                      ),
                      child: Center(
                        child: Text(secondsString.split('').last,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp,color: AppColor.ucpBlack500),),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(157.h),
              CustomButton(onTap: (){
                // Get.to(Otpscreen());
                Get.offAll(LoginFlow(), predicate: (route) => false);
              }, buttonText: UcpStrings.returnToSignIApp,
                buttonColor: AppColor.ucpBlue500,
              borderRadius: 25.r,
                height: 51.h,
                width: 343.w,
                textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(fontWeight: FontWeight.w500,fontSize: 16.sp,color: AppColor.ucpWhite500),
                textColor: AppColor.ucpWhite500,
              ),
            ],
          ),
        ),
      )
    );
  }
}
