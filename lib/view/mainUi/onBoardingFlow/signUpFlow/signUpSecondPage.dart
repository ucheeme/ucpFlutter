import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signupThirdPage.dart';

import '../../../../bloc/onboarding/on_boarding_bloc.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../utils/ucpLoader.dart';

class SignUpSecondPage extends StatefulWidget {
  OnBoardingBloc bloc;
   SignUpSecondPage({super.key, required this.bloc});

  @override
  State<SignUpSecondPage> createState() => _SignUpSecondPageState();
}

class _SignUpSecondPageState extends State<SignUpSecondPage> {
  bool isVisible=false;
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
                      Image.asset(UcpStrings.ucpLogo, height: 35.h,),
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
                        height:MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(UcpStrings.fNameTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream:widget.bloc.validation.firstName,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    isConfirmPasswordMatch: false,
                                    hintTxt: UcpStrings.enterFNTxt,
                                    error: snapshot.error?.toString(),
                                    keyboardType: TextInputType.name,
                                    onChanged: widget.bloc.validation.setFirstName,
                                  );
                                }
                            ),
                            //  height20,
                            Text(UcpStrings.lNameTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream: widget.bloc.validation.lastName,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    isConfirmPasswordMatch: false,
                                    hintTxt: UcpStrings.enterLNTxt,
                                    error: snapshot.error?.toString(),
                                    keyboardType: TextInputType.name,
                                    onChanged: widget.bloc.validation.setLastName,
                                  );
                                }
                            ),
                            // height20,
                            Text(UcpStrings.eMailTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream: widget.bloc.validation.email,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    isConfirmPasswordMatch: false,
                                    hintTxt: UcpStrings.enterEmailTxt,
                                    error: snapshot.error?.toString(),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: widget.bloc.validation.setEmail,
                                  );
                                }
                            ),
                            // height20,
                            Text(UcpStrings.phoneNumberTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream: widget.bloc.validation.phoneNumber,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    isConfirmPasswordMatch: false,
                                    hintTxt: UcpStrings.enterPhoneTxt,
                                    error: snapshot.error?.toString(),
                                    keyboardType: TextInputType.phone,
                                    onChanged: widget.bloc.validation.setPhoneNumber,
                                  );
                                }
                            ),

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
                          StreamBuilder<Object>(
                            stream: widget.bloc.validation.completeSignupSecondPageValidation,
                            builder: (context, snapshot) {
                              return CustomButton(onTap: () =>
                                snapshot.data == true ? Get.to(SignUpThirdPage(bloc: widget.bloc)) : null,
                                height: 51.h,
                                width: 163.5.w,
                                buttonText: "${UcpStrings.proceedTxt} (2 of 5)",
                                borderRadius: 60.r,
                                buttonColor: AppColor.ucpBlue500,
                                textColor: AppColor.ucpWhite500,
                              );
                            }
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
}
