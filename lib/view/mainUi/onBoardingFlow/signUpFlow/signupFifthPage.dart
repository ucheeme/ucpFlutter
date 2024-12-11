import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_country_state/city_screen.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:flutter_country_state/state_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/utils/apputils.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signUpSecondPage.dart';

import '../../../../bloc/onboarding/onBoardingValidation.dart';
import '../../../../bloc/onboarding/on_boarding_bloc.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/customValidator.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
class SignUpfifthPage extends StatefulWidget {
  OnBoardingBloc bloc;
  SignUpfifthPage({super.key, required this.bloc});

  @override
  State<SignUpfifthPage> createState() => _SignUpfifthPageState();
}

class _SignUpfifthPageState extends State<SignUpfifthPage> {
  bool isVisible=false;
  OnboardingValidation controller = OnboardingValidation();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool allConditionMet = false;
  isValidString(String input) {
    final symbolPattern = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final numberPattern = RegExp(r'\d');
    final lowerCasePattern =RegExp(r'[a-z]');
    final upperCasePattern =RegExp(r'[A-Z]');

    bool containsSymbol = symbolPattern.hasMatch(input);
    bool containsLowerCase = lowerCasePattern.hasMatch(input);
    bool containsUpperCase = upperCasePattern.hasMatch(input);
    bool containsNumber = numberPattern.hasMatch(input);
    bool hasValidLength = input.length > 7;

    if(containsSymbol){
      setState(() {
        controller.isContainsSymbolChecked=true;
      });
    }else{
      setState(() {
        controller.isContainsSymbolChecked=false;
      });
    }
    if(containsNumber){
      setState(() {
        controller.isContainsNumChecked=true;
      });
    }else{
      setState(() {
        controller.isContainsNumChecked=false;
      });
    }
    if(hasValidLength){
      setState(() {
        controller.isEightCharacterMinimumChecked=true;
      });
    }else{
      setState(() {
        controller.isEightCharacterMinimumChecked=false;
      });
    }
    if(containsLowerCase){
      setState(() {
        controller.isContainsLowerCaseChecked=true;
      });
    }else{
      setState(() {
        controller.isContainsLowerCaseChecked=false;
      });
    }
    if(containsUpperCase){
      setState(() {
        controller.isContainsUpperCaseChecked=true;
      });
    }else{
      setState(() {
        controller.isContainsUpperCaseChecked=false;
      });
    }
    if(containsNumber&&containsLowerCase&&containsUpperCase&&containsSymbol&&hasValidLength){
      setState(() {
        allConditionMet=true;
      });
    }else{
      setState(() {
        allConditionMet=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    widget.bloc =  BlocProvider.of<OnBoardingBloc>(context);
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {

        return GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: AppColor.ucpWhite500,
              body:Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                        "assets/images/logoWithoutText.png", height: 35.h,),
                      height30,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(UcpStrings.signUp1Txt,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack500
                            ),),

                          Text(UcpStrings.createYourAccountTodayTxt,
                            style: CreatoDisplayCustomTextStyle.kTxtRegular
                                .copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColor.ucpBlack700
                            ),),
                        ],
                      ),
                      height40,
                      SizedBox(
                        height: Get.height/2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(UcpStrings.createPasswordTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream: widget.bloc.validation.password,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    isPasswordVisible: true,
                                    obsec:  widget.bloc.validation.isPasswordVisible,
                                    surffixWidget: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          widget.bloc.validation.isConfirmPasswordSelected= false;
                                          widget.bloc.validation.isPasswordSelected=true;
                                          widget.bloc.validation.isPasswordVisible=!widget.bloc.validation.isPasswordVisible;
                                        });
                                      },
                                      child:Padding(
                                        padding:  EdgeInsets.only(right: 16.w),
                                        child:  widget.bloc.validation.isPasswordVisible? Image.asset(
                                          "assets/images/eye_close.png",
                                          height: 24.h,
                                          width: 24.h,
                                        ):Image.asset(
                                          "assets/images/fi_eye.png",
                                          height: 24.h,
                                          width: 24.h,
                                        ),
                                      ),
                                    ),
                                    textEditingController: passwordController,
                                    error: snapshot.error?.toString(),
                                    hintTxt:UcpStrings.enterHomeAddressTxt,
                                    keyboardType: TextInputType.name,
                                    onChanged: (value){isValidString(value);
                                    tempPassword = value;
                                    },
                                  );
                                }
                            ),
                            Text(UcpStrings.confirmPasswordTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                              stream: widget.bloc.validation.confirmPassword,
                              builder: (context, snapshot) {
                                return CustomizedTextField(
                                  isPasswordVisible: true,
                                  isConfirmPasswordMatch: false,
                                  textEditingController: confirmPasswordController,
                                  hintTxt: UcpStrings.enterCpasswordTxt,
                                  error: snapshot.error?.toString(),
                                  keyboardType: TextInputType.visiblePassword,
                                    obsec: widget.bloc.validation.isConfirmPasswordVisible,
                                  surffixWidget: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        widget.bloc.validation.isConfirmPasswordSelected= true;
                                        widget.bloc.validation.isPasswordSelected=false;
                                        widget.bloc.validation.isPasswordVisible=!widget.bloc.validation.isConfirmPasswordVisible;
                                      });
                                    },
                                    child:Padding(
                                      padding:  EdgeInsets.only(right: 16.w),
                                      child:  widget.bloc.validation.isConfirmPasswordVisible? Image.asset(
                                        "assets/images/eye_close.png",
                                        height: 24.h,
                                        width: 24.h,
                                      ):Image.asset(
                                        "assets/images/fi_eye.png",
                                        height: 24.h,
                                        width: 24.h,
                                      ),
                                    ),
                                  ),
                                  onChanged: widget.bloc.validation.setConfirmPassword,
                                );
                              }
                            ),
                            Text(UcpStrings.passwordMustConsistTxt,
                            style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColor.ucpBlack500
                            ),
                            ),
                            Gap(15.h),
                            SizedBox(
                              height: 99.h,
                             // width: 343.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      passwordContainer(UcpStrings.minimumOf8CharactatTxt,controller.isEightCharacterMinimumChecked),
                                      passwordContainer(UcpStrings.oneUpperCTxt, controller.isContainsUpperCaseChecked,
                                      width: 148.w),
                                      SizedBox()
                                    ],
                                  ),
                                  height10,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      passwordContainer(UcpStrings.oneLowerCTxt,controller.isContainsLowerCaseChecked, width: 147),
                                      passwordContainer(UcpStrings.oneNumberOTxt,controller.isContainsNumChecked, width: 179),

                                    ],
                                  ),
                                  height10,
                                  passwordContainer(UcpStrings.oneSpecialCharacterTxt,controller.isContainsSymbolChecked, width: 203),
                             ]
                              )
                            )
                          ],
                        ),
                      ),
                      Gap(40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(onTap: () {
                            Get.back();
                          },
                            height: 51.h,
                            width: 163.5.w,
                            buttonText: UcpStrings.goBackTxt,
                            borderRadius: 60.r,
                            buttonColor: AppColor.ucpBlue50,
                            textColor: AppColor.ucpBlack500,
                          ),
                          CustomButton(onTap: () {
                            if(allConditionMet){
                              Get.to(SignUpSecondPage(bloc: widget.bloc));
                            }else{
                              AppUtils.showInfoSnack("Password conditions not met", context);
                            }

                          },
                            height: 51.h,
                            width: 163.5.w,
                            buttonText: "${UcpStrings.proceedTxt} (5 of 5)",
                            borderRadius: 60.r,
                            buttonColor: AppColor.ucpBlue500,
                            textColor: AppColor.ucpWhite500,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }
  Container passwordContainer(String txt, bool isFound,
  {double width = 160,}
      ) {
    return Container(
      height: 26.h,
      width:width.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color:isFound? AppColor.ucpSuccess50: AppColor.ucpWhite10,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        children: [
         !isFound? Image.asset(
            "assets/images/password_alert.png",
            height: 14.h,
            width: 14.h,
          ):Image.asset("assets/images/password_check.png",
           height: 14.h,
           width: 14.h,
         ),
          Gap(4.w),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(txt,
              style: CustomTextStyle.kTxtRegular.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColor.ucpBlack700
              ),),
          ),
        ],
      ),
    );
  }
}

