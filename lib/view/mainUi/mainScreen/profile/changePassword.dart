import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/bloc/profile/profile_bloc.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/ucpLoader.dart';

import '../../../../bloc/onboarding/onBoardingValidation.dart';
import '../../../../bloc/profile/profileController.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/customValidator.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../bottomSheet/SuccessNotification.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late ProfileBloc bloc;
  bool isVisible=false;
   ProfileController controller=ProfileController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
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
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((_){
     controller = bloc.validation;
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(state.errorResponse.message, context);
          });
          bloc.initial();
        }
        if(state is PasswordChanged){
          WidgetsBinding.instance.addPostFrameCallback((_){
            showCupertinoModalBottomSheet(
              topRadius: Radius.circular(15.r),
              backgroundColor: AppColor.ucpWhite500,
              context: context,
              builder: (context) {
                return Container(
                  height: 400.h,
                  color: AppColor.ucpWhite500,
                  child: LoadLottie(lottiePath: UcpStrings.ucpLottieSuccess1,
                    bottomText: state.data.retmsg,
                  ),
                );
              },
            ).then((value){
              Get.back(result: true);
            });
          });
          bloc.initial();
        }
        return UCPLoadingScreen(
          visible: state is ProfileLoading,
          loaderWidget: LoadingAnimationWidget.discreteCircle(
            color: AppColor.ucpBlue500,
            size: 40.h,
            secondRingColor: AppColor.ucpBlue100,
          ),
          overlayColor: AppColor.ucpBlack400,
          transparency: 0.2,
          child: GestureDetector(
            onTap: ()=> FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColor.ucpWhite10,
              bottomSheet:   StreamBuilder<Object>(
                stream: controller.completeChangePasswordValidation,
                builder: (context, snapshot) {
                  return Container(
                    height: 83.h,
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: const BoxDecoration(
                      color: AppColor.ucpBlue50,
                    ),
                    child: CustomButton(onTap: snapshot.hasData?() {
                      if(allConditionMet){
                       bloc.add(ChangePasswordEvent(controller.changePasswordRequest()));
                      }else{
                        AppUtils.showInfoSnack("Password conditions not met", context);
                      }

                    }:(){},
                      height: 51.h,
                      buttonText: "${UcpStrings.proceedTxt} ",
                      borderRadius: 60.r,
                      buttonColor: snapshot.hasData?AppColor.ucpBlue500:AppColor.ucpBlue300,
                      textColor: AppColor.ucpWhite500,
                    ),
                  );
                }
              ),
              body: Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: [
                      Gap(120.h),
                      SizedBox(
                        height: Get.height/1.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(UcpStrings.enterCurrentpasswordTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream: bloc.validation.currentPassword,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    isPasswordVisible: true,
                                    obsec:  bloc.validation.isCurrentPasswordVisible,
                                    surffixWidget: GestureDetector(
                                      onTap: (){
                                        // setState(() {
                                        //   bloc.validation.isConfirmPasswordSelected= false;
                                        //   bloc.validation.isPasswordSelected=true;
                                        //   bloc.validation.isPasswordVisible=!bloc.validation.isPasswordVisible;
                                        // });
                                      },
                                      child:Padding(
                                        padding:  EdgeInsets.only(right: 16.w),
                                        child:  bloc.validation.isCurrentPasswordVisible? Image.asset(
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
                                    textEditingController: currentPasswordController,
                                    error: snapshot.error?.toString(),
                                    hintTxt:UcpStrings.enterCurrentpasswordTxt,
                                    keyboardType: TextInputType.name,
                                    onChanged: controller.setCurrentPassword,
                                  );
                                }
                            ),
                            Text(UcpStrings.enterNewpasswordTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream: bloc.validation.password,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    isPasswordVisible: true,
                                    obsec:  bloc.validation.isPasswordVisible,
                                    surffixWidget: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          bloc.validation.isConfirmPasswordSelected= false;
                                          bloc.validation.isPasswordSelected=true;
                                          bloc.validation.isPasswordVisible=!bloc.validation.isPasswordVisible;
                                        });
                                      },
                                      child:Padding(
                                        padding:  EdgeInsets.only(right: 16.w),
                                        child:  bloc.validation.isPasswordVisible? Image.asset(
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
                                    hintTxt:UcpStrings.enterNewpasswordTxt,
                                    keyboardType: TextInputType.name,
                                    onChanged: (value){
                                      controller.setPassword(value);
                                      isValidString(value);
                                    tempPassword = value;
                                    },
                                  );
                                }
                            ),
                            Text(UcpStrings.confirmNewpasswordTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream: bloc.validation.confirmPassword,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    isPasswordVisible: true,
                                    isConfirmPasswordMatch: false,
                                    textEditingController: confirmPasswordController,
                                    hintTxt: UcpStrings.enterCpasswordTxt,
                                    error: snapshot.error?.toString(),
                                    keyboardType: TextInputType.visiblePassword,
                                    obsec: bloc.validation.isConfirmPasswordVisible,
                                    surffixWidget: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          bloc.validation.isConfirmPasswordSelected= true;
                                          bloc.validation.isPasswordSelected=false;
                                          bloc.validation.isPasswordVisible=!bloc.validation.isConfirmPasswordVisible;
                                        });
                                      },
                                      child:Padding(
                                        padding:  EdgeInsets.only(right: 16.w),
                                        child:  bloc.validation.isConfirmPasswordVisible? Image.asset(
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
                                    onChanged: bloc.validation.setConfirmPassword,
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

                    ],
                  ),
                  UCPCustomAppBar(
                      height: 93.h,
                      appBarColor: AppColor.ucpWhite10.withOpacity(0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          height30,
                          Row(
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
                                    ),
                                  ),
                                ),
                              ),
                              Gap(12.w),
                              Text(UcpStrings.changePasswordTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.ucpBlack500),
                              )
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
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
