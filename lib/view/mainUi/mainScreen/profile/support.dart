import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/view/mainUi/mainScreen/profile/profileWidget.dart';

import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/contactHelper.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ucpWhite10,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 273.h,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  UcpStrings.contributionBg,fit: BoxFit.cover,
                ),
              ) ,
              Positioned(
                top: 50.h,
                left: 15.w,
                child: SizedBox(
                  height: 183.h,
                  width: 237.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: ColoredBox(
                            color: Colors.transparent,
                            child: Image.asset(
                              UcpStrings.ucpBackArrow,
                              height: 24.h,
                              width: 24.w,
                              color:AppColor.ucpWhite500,
                            ),
                          ),
                        ),
                      ),
                      Gap(20.h),

                      Image.asset(
                        UcpStrings.winkBg,height: 64.h,width: 64.w,
                      ),
                      SizedBox(
                        height: 33.h,
                        width: 343.w,
                        child: Text("Hello ${memberLoginDetails?.employeeName.toUpperCase()},",
                          style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.ucpWhite500
                          ),
                        ),
                      ),
                      Gap(16.h),
                      SizedBox(
                        height: 20.h,
                        width: 343.w,
                        child: Text("How can we help you today?",
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpWhite50
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(16.h),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: SupportWidget(
              onTap: (){
                ContactHelper.sendEmail('support@example.com');
              },
              iconImage: UcpStrings.supportMail,
              contact: 'demicoop@ucp.com',
              mainHeader: 'Send us a mail',
              messageBody: 'We typically reply to mails within 24hrs',
              instruction: 'Tap to send a mail',

            ),
          ),
          Gap(14.h),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: SupportWidget(
              onTap: (){
                ContactHelper.makePhoneCall('23900293m');
              },
              iconImage: UcpStrings.supportCall,
              contact: '070000CALLUCP',
              mainHeader: 'Send us a mail',
              messageBody: 'Phone lines are available between 8:00 AM and 5:00 PM on weekdays',
              instruction: 'Tap the number a call',

            ),
          ),
        ],
      ),
    );
  }
}
