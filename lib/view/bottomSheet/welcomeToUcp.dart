import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/app/main/pages.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/constant.dart';

import '../../utils/colorrs.dart';
import '../../utils/designUtils/reusableWidgets.dart';

class WelcomeToUcp extends StatefulWidget {
  const WelcomeToUcp({super.key});

  @override
  State<WelcomeToUcp> createState() => _WelcomeToUcpState();
}

class _WelcomeToUcpState extends State<WelcomeToUcp> {
  bool isSignUp = true;
  bool isLogIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ucpWhite500,
      body: SizedBox(
        height: 390.h,
        width: 375.w,
        child: Column(
          children: [
            height24,
            Text(
              UcpStrings.welcomeToUCPTxt,
              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  color: AppColor.ucpBlack500),
            ),
            height30,
            UCPWelcomeOption(
              iconImage: "assets/images/person_add.png",
              bodyText: UcpStrings.createAcct,
              headerText: UcpStrings.signUpTxt,
              isSelected: isSignUp,
              onTap: () {
                setState(() {
                  isSignUp = true;
                  isLogIn = false;
                });
              },
            ),
            height20,
            UCPWelcomeOption(
              iconImage: "assets/images/signUp/person.png",
              bodyText: UcpStrings.logInBTxt,
              headerText: UcpStrings.logInTxt,
              isSelected: isLogIn,
              onTap: () {
                setState(() {
                  isSignUp = false;
                  isLogIn = true;
                });
              },
            ),
            height30,
            CustomButton(
              onTap: () {
                if(isSignUp){
                  Get.toNamed(Pages.signup);
                }else{
                  Get.toNamed(Pages.login);
                }
              },
              height: 51.h,
              width: 343.w,
              buttonColor: AppColor.ucpBlue500,
              borderRadius: 60.r,
              buttonText: UcpStrings.continueTxt,
              textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.ucpWhite500),
            )
          ],
        ),
      ),
    );
  }
}
