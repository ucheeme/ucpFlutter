import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ucp/bloc/onboarding/on_boarding_bloc.dart';

import '../../utils/appStrings.dart';
import '../../utils/apputils.dart';
import '../../utils/colorrs.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableWidgets.dart';
import '../../utils/sharedPreference.dart';
import '../../utils/ucpLoader.dart';
import 'bottomNav.dart';
import 'onBoardingFlow/signUpFlow/cooperativeFInal.dart';
String isCreateAccountFirstStep = "";
class Otpscreen extends StatefulWidget {
  bool? isLogin;
  bool? isSignUp;
  String otpValue;
  OnBoardingBloc bloc;
   Otpscreen({super.key,this.isLogin,this.isSignUp,required this.otpValue, required this.bloc});

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen>with TickerProviderStateMixin {
  StreamController<ErrorAnimationType>? errorController;
  String requiredNumber="";
  String enteredValue = "";
  FocusNode _pinCodeFocusNode = FocusNode();
  TextEditingController otpController= TextEditingController();
  bool activateKeyboard = false;
  late Timer _timer;
  int _start = 60;
  bool isLoading = false;
  bool isWrongOTP = false;
  bool isCompleteOTP=false;
  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    String formattedMinutes = minutes.toString();
    String formattedSeconds = seconds.toString().padLeft(2, '0');
    // return "$formattedMinutes:$formattedSeconds";

      return formattedSeconds;

  }



  @override
  void initState() {
    MySharedPreference.saveCreateAccountStep(key: isCreateAccountFirstStep,value: false);
   // errorController = StreamController<ErrorAnimationType>();
    otpValue = widget.otpValue;
    startTimer();
    super.initState();
  }
  String otpValue="";
  @override
  void dispose() {
    errorController!.close();
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        if (state is CreateAccountSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Get.to(AwaitCooperativeResponse());
          });
          widget.bloc.initial();
        }
        if(state is LoginSuccess){
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            memberLoginDetails=state.response.memberLoginDetails;
            accessToken = state.response.token;
            refreshAccessToken = state.response.refreshToken;
           Get.offAll(MyBottomNav(), predicate: (route) => false);
          });
          widget.bloc.initial();
        }
        if(state is SignUpOTPSuccessful){
          WidgetsBinding.instance.addPostFrameCallback((_)async{
          AppUtils.showInfoSnack("For test purpose use ${state.response.otp}", context);
          otpValue=state.response.otp.toString();
          setState(() {_start=60;});
          startTimer();
          });
          widget.bloc.initial();
        }
        if(state is LoginOTPSuccessful){
          WidgetsBinding.instance.addPostFrameCallback((_)async{
            AppUtils.showInfoSnack("For test purpose use ${state.response.otp}", context);
            otpValue=state.response.otp.toString();
            print("the otp: ${state.response.otp}");
            setState(() {_start=60;});
            startTimer();
          });
          widget.bloc.initial();
        }
        if (state is OnBoardingError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration.zero, () {
              AppUtils.showSnack(
                  "${state.errorResponse.message} ${state.errorResponse.data}",
                  context);
            });
          });
          widget.bloc.initial();
        }
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: UCPLoadingScreen(
            visible: state is OnboardingIsLoading,
            loaderWidget: LoadingAnimationWidget.discreteCircle(
              color: AppColor.ucpBlue500,
              size: 40.h,
              secondRingColor: AppColor.ucpBlue100,
            ),
            //visible: true,
            overlayColor: AppColor.ucpBlack400,
            transparency: 0.2,
            child: Scaffold(
                backgroundColor: AppColor.ucpWhite500,
                body: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                          UcpStrings.ucpLogo,
                          height: 35.h,
                        ),
                        height30,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UcpStrings.otpSentTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                            Text(
                              UcpStrings.otpSentInstructionTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtRegular
                                  .copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.ucpBlack700),
                            ),
                          ],
                        ),
                        height40,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                UcpStrings.pleaseEnterOTPReceivedTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtRegular
                                    .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.ucpBlack700),
                              ),
                              height40,
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 16.h),
                                child: pinCodeTextField( ),
                              ),
                              height50,
                              Row(
                                children: [
                                  Text(
                                    UcpStrings.otpExpiresTxt,
                                    style: CustomTextStyle.kTxtRegular
                                        .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.ucpBlack700),
                                  ),
                                  Gap(4.w),
                                  Text(
                                    "$timerText seconds",

                                    style: CustomTextStyle.kTxtRegular
                                        .copyWith(
                                      decorationStyle: TextDecorationStyle.dashed,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.ucpBlue500),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                     // Spacer(),
                        CustomButton(
                          onTap: () {

                            if(requiredNumber.length==6 && otpValue==enteredValue){
                              if(widget.isSignUp==true){
                                widget.bloc.add(CreateAccountEvent(widget.bloc.validation.signupRequest()));
                              }
                              if(widget.isLogin==true){
                                widget.bloc.add(LoginEvent(widget.bloc.validation.loginRequest()));
                              }

                            }
                          },
                          height: 51.h,
                          width: 343.w,
                          buttonText:
                          "${UcpStrings.confirmOtPTxt} ",
                          borderRadius: 60.r,
                          buttonColor: AppColor.ucpBlue500,
                          textColor: AppColor.ucpWhite500,
                        ),
                        height12,
                        SizedBox(
                          height: 20.h,
                          width: double.infinity,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                UcpStrings.didntRecieveOTPTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtRegular
                                    .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.ucpBlack700),
                              ),
                              Gap(4.w),
                              GestureDetector(
                                onTap: () {
                                  if(_start ==0){
                                  if(widget.isSignUp==true){
                                    widget.bloc.add(SendSignUpOtpEvent(widget.bloc.validation.signupOtpRequest()));
                                  }
                                  if(widget.isLogin==true ){
                                    widget.bloc.add(SendLoginOtpEvent(widget.bloc.validation.loginOtpRequest()));
                                  }

                                } },
                                child: Text(
                                    UcpStrings.resendTxt,
                                  style: CreatoDisplayCustomTextStyle.kTxtRegular
                                      .copyWith(
                                      decorationStyle: TextDecorationStyle.dashed,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.ucpBlue500),
                                ),
                              ),
                            ],
                          ) ,
                        )
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget pinCodeTextField(){
    return StreamBuilder<String>(
        stream:  widget.bloc.validation.otpValue,
        builder: (context, snapshot) {
          return PinCodeTextField(
            //  controller: otpController,
            // focusNode: _pinCodeFocusNode,
              onTap: (){
                setState(() {
                  activateKeyboard=true;
                });
             //  _pinCodeFocusNode.requestFocus();
              },
              appContext: context,
              enableActiveFill: true,
              autoFocus: true,
              length: 6,
              showCursor: false,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              textStyle: CustomTextStyle.kTxtMedium.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,color: AppColor.ucpBlack500),
              obscureText: false,
              keyboardType: activateKeyboard?TextInputType.number:TextInputType.none,
              animationType: AnimationType.fade,
              //errorAnimationController: errorController,
              pinTheme: PinTheme(
                  inactiveFillColor: AppColor.ucpWhite10,
                  activeFillColor: AppColor.ucpWhite10,
                  selectedFillColor: AppColor.ucpBlue50,
                  fieldOuterPadding: EdgeInsets.zero,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12.r),
                  fieldHeight: 45.h,
                  fieldWidth: 45.w,
                  inactiveColor: AppColor.ucpWhite10,
                  activeColor:isWrongOTP?AppColor.ucpDanger150:AppColor.ucpWhite10,
                  selectedColor:isWrongOTP?AppColor.ucpDanger150:AppColor.ucpWhite10,
                  errorBorderColor: AppColor.ucpDanger150
              ),
              animationDuration: const Duration(milliseconds: 300),
              onChanged:(value){
                setState(() {
                  requiredNumber = value;
                });
                if(requiredNumber.length==6){
                  setState(() {
                    isCompleteOTP=true;
                   // widget.bloc.validation.otpController=value;
                  });
                  enteredValue=value;
                }else{
                  setState(() {
                    isWrongOTP=false;
                  });
                }
              }
          );
        }
    );
  }


  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isLoading = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

}
