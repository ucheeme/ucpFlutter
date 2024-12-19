import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/data/model/response/dashboardResponse.dart';

import '../../../../app/main/pages.dart';
import '../../../../bloc/onboarding/on_boarding_bloc.dart';
import '../../../../data/model/response/cooperativeList.dart';
import '../../../../data/model/response/loginResponse.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../utils/sharedPreference.dart';
import '../../../../utils/ucpLoader.dart';
import '../../../bottomSheet/cooperatives.dart';
import '../../bottomNav.dart';
import '../../otpScreen.dart';
import '../signUpFlow/signUpSecondPage.dart';
DashboardResponse? dashboardResponse;
class LoginFlow extends StatefulWidget {
  const LoginFlow({super.key});

  @override
  State<LoginFlow> createState() => _LoginFlowState();
}

class _LoginFlowState extends State<LoginFlow> {
  bool isVisible = false;
  late OnBoardingBloc bloc;
  List<CooperativeListResponse> cooperativeList = [];
  bool rememberMe = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController sCollectiveController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(allCooperatives.isEmpty){
        bloc.add(GetAllCooperativesEvent());
      }
    });
    super.initState();
  }
  Future<void> _showCooperativeSelectionModal() async {
    CooperativeListResponse? response = await showCupertinoModalBottomSheet(
      topRadius: Radius.circular(15.r),
      backgroundColor: AppColor.ucpWhite500,
      context: context,
      builder: (context) {
        return Container(
          height: 485.h,
          color: AppColor.ucpWhite500,
          child: CooperativeListDesign(cooperativeList: allCooperatives),
        );
      },
    );

    if (response != null) {
      setState(() {
        sCollectiveController.text = response.tenantName;
        bloc.validation.selectedCooperative = response;
      });
     // bloc.validation.setCooperative(response);
    }
  }

  void _handleAllCooperativesState(AllCooperatives state) {
    cooperativeList = state.response;
    allCooperatives = cooperativeList;
    _showCooperativeSelectionModal();
    bloc.initial();
  }

  void _handleOnBoardingErrorState(OnBoardingError state) {
    AppUtils.showSnack(
      "${state.errorResponse.message} ${state.errorResponse.data}",
      context,
    );
    bloc.initial();
  }
  bool completed= false;
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<OnBoardingBloc>(context);
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        if (state is AllCooperatives) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            _handleAllCooperativesState(state);
          });
        }
        if(state is LoginOTPSuccessful){
          WidgetsBinding.instance.addPostFrameCallback((_)async{
            AppUtils.showInfoSnack("For test purpose use ${state.response.otp}", context);
            Get.to(Otpscreen(isLogin: true,bloc: bloc,otpValue: state.response.otp.toString()));
          });
          bloc.initial();
        }
        // if(state is LoginSuccess){
        //   WidgetsBinding.instance.addPostFrameCallback((_) async {
        //     memberLoginDetails=state.response.memberLoginDetails;
        //     accessToken = state.response.token;
        //     refreshAccessToken = state.response.refreshToken;
        //   //  Get.offAll(MyBottomNav(), predicate: (route) => false);
        //   });
        // }

        if (state is OnBoardingError)
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            _handleOnBoardingErrorState(state);
          });
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: UCPLoadingScreen(
            visible: state is OnboardingIsLoading,
            loaderWidget: LoadingAnimationWidget.discreteCircle(
              color: AppColor.ucpBlue500,
              size: 30.h,
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
                        Image.asset(UcpStrings.ucpLogo,
                          height: 35.h,
                        ),
                        height30,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UcpStrings.logInTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                            Text(
                              UcpStrings.accessYourAccountTxt,
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
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                UcpStrings.sCooperativeTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.ucpBlack600),
                              ),
                              height12,
                              StreamBuilder<Object>(
                                stream: bloc.validation.cooperative,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    readOnly: true,
                                    textEditingController: sCollectiveController,
                                    hintTxt: UcpStrings.sCooperativeTxt,
                                    keyboardType: TextInputType.name,
                                    surffixWidget: Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: const Icon(Ionicons.chevron_down),
                                    ),
                                    onTap: () => _showCooperativeSelectionModal(),
                                  );
                                }
                              ),
                              // height20,
                              Text(
                                UcpStrings.userNameTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.ucpBlack600),
                              ),
                              height12,
                              StreamBuilder<Object>(
                                  stream: bloc.validation.userName,
                                  builder: (context, snapshot) {
                                    return CustomizedTextField(
                                      isConfirmPasswordMatch: false,
                                      hintTxt: UcpStrings.enterUNameTxt,
                                      keyboardType: TextInputType.text,
                                      //textEditingController: userNameController,
                                      onChanged:
                                      bloc.validation.setUserName,
                                      error: snapshot.error?.toString(),
                                    );
                                  }),
                              Text(
                                UcpStrings.passwordTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.ucpBlack600),
                              ),
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
                                          child: bloc.validation.isPasswordVisible? Image.asset(
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
                                      isConfirmPasswordMatch: false,
                                      textEditingController: passwordController,
                                      error: snapshot.error?.toString(),
                                      hintTxt:UcpStrings.enterPasswordTxt,
                                      keyboardType: TextInputType.name,
                                      onChanged: bloc.validation.setPassword,
                                    );
                                  }
                              ),
                              height12,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                    width: 165.w,
                                    child: RememberMeCheckbox(
                                      onChanged: (value) {
                                       // print("This is the value:$value");
                                        setState(() {
                                         rememberMe = !rememberMe;
                                        });
                                        bloc.validation.rememberMe = rememberMe;
                                      },
                                      value:true ,),
                                  ),
                                  Text(UcpStrings.forgotPasswordTxt,
                                    style: CreatoDisplayCustomTextStyle.kTxtMedium
                                        .copyWith(
                                        decoration: TextDecoration.underline,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpBlue500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        height30,
                        CustomButton(
                          onTap: () {
                          // bloc.validation.loginRequest();
                            bloc.add(SendLoginOtpEvent(bloc.validation.loginOtpRequest()));
                         //  bloc.add(LoginEvent( bloc.validation.loginRequest()));
                            //  null;
                          },
                          height: 51.h,
                          buttonText: UcpStrings.continueTxt,
                          borderRadius: 60.r,
                          buttonColor: AppColor.ucpBlue500,
                          textColor: AppColor.ucpWhite500,
                        ),
                        Gap(100.h),
                        SizedBox(
                          height: 30.h,
                          width: double.infinity,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                UcpStrings.dontHaveAnAccountTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtRegular
                                    .copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.ucpBlack700),
                              ),
                              Gap(4.w),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Pages.signup);
                                  },
                                child: Text(
                                  UcpStrings.signUpTxt,
                                  style: CreatoDisplayCustomTextStyle.kTxtRegular
                                      .copyWith(
                                      fontSize: 16.sp,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.ucpBlack500),
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
}

