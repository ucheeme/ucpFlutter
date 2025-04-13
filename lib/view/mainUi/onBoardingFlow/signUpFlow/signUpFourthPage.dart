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
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/data/model/response/statesInCountry.dart';
import 'package:ucp/view/bottomSheet/countries.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signupFifthPage.dart';

import '../../../../bloc/onboarding/on_boarding_bloc.dart';
import '../../../../data/model/request/signUpReq.dart';
import '../../../../data/model/response/allCountries.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../utils/sharedPreference.dart';
import '../../../../utils/ucpLoader.dart';
import '../../../bottomSheet/gender.dart';
import '../../otpScreen.dart';
import 'cooperativeFInal.dart';

class SignUpFourthPage extends StatefulWidget {
  OnBoardingBloc bloc;

  SignUpFourthPage({super.key, required this.bloc});

  @override
  State<SignUpFourthPage> createState() => _SignUpFourthPageState();
}

class _SignUpFourthPageState extends State<SignUpFourthPage> {
  bool isVisible = false;
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  late OnBoardingBloc bloc;
  AllCountriesResponse? selectedCountry;
  AllStateResponse? selectedStated;
  @override
  void initState() {
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc =  BlocProvider.of<OnBoardingBloc>(context);
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        if (state is CreateAccountSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Get.to(AwaitCooperativeResponse());
          });
          bloc.initial();
        }
        if(state is SignUpOTPSuccessful){
          WidgetsBinding.instance.addPostFrameCallback((_)async{
            Get.to(Otpscreen(isSignUp: true,bloc: widget.bloc,otpValue: state.response.otp.toString() ,));
          });
          widget.bloc.initial();
        }
        if(state is AllUcpStates){
          WidgetsBinding.instance.addPostFrameCallback((_) async {

            // if(res!=null){
            //   bloc.add(GetAllStatesEvent(res.countryCode));
            // }
          });
        }
        if (state is OnBoardingError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration.zero, () {
              AppUtils.showSnack(
                  "${state.errorResponse.message} ${state.errorResponse.data}",
                  context);
            });
          });
          bloc.initial();
        }
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: UCPLoadingScreen(
            visible: state is OnboardingIsLoading,
            loaderWidget: LoadingAnimationWidget.discreteCircle(
              color: AppColor.ucpBlue500,
              size: 50.h,
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
                              UcpStrings.signUp1Txt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpBlack500),
                            ),
                            Text(
                              UcpStrings.createYourAccountTodayTxt,
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
                                UcpStrings.enterHomeAddressTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpBlack600),
                              ),
                              height12,
                              StreamBuilder<Object>(
                                  stream: bloc.validation.homeAddress,
                                  builder: (context, snapshot) {
                                    return CustomizedTextField(
                                      isConfirmPasswordMatch: false,
                                      textEditingController:
                                          homeAddressController,
                                      error: snapshot.error?.toString(),
                                      hintTxt: UcpStrings.enterHomeAddressTxt,
                                      keyboardType: TextInputType.name,
                                      onChanged:
                                          bloc.validation.setHomeAddress,
                                    );
                                  }),
                              //  height20,
                              Text(
                                UcpStrings.sCountryTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpBlack600),
                              ),
                              height12,
                              // height20,
                              StreamBuilder<Object>(
                                  stream: bloc.validation.country,
                                  builder: (context, snapshot) {
                                    return CustomizedTextField(
                                      textEditingController: countryController,
                                      hintTxt: UcpStrings.sCountryTxt,
                                      readOnly: true,
                                      onChanged:
                                          bloc.validation.setCountry,
                                      keyboardType: TextInputType.name,
                                      surffixWidget: Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: Icon(Ionicons.chevron_down),
                                      ),
                                      onTap: () async {
                                        AllCountriesResponse? res = await  showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: AppColor.ucpWhite500,
                                          context: context,
                                          isDismissible: true,
                                          builder: (context) => SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7,
                                            child: CountriesDesign(allcountries: allCountries,)
                                          ),
                                        );
                                      if(res!=null){
                                        var selectedCountry =
                                            res;
                                        this.selectedCountry=res;
                                        setState(() {
                                          countryController.text =
                                              selectedCountry.countryName;
                                        });
                                        bloc.validation
                                            .setCountry(res.countryCode);
                                        AllStateResponse res2=await  showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: AppColor.ucpWhite500,
                                          context: context,
                                          isDismissible: true,
                                          builder: (context) => SizedBox(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.7,
                                              child: StateDesign(countryId: res.countryCode,)
                                          ),
                                        );
                                      if(res2!=null){
                                        selectedStated = res2;
                                        var selectedState =
                                          res2;
                                        setState(() {
                                          stateController.text =
                                              selectedState.stateName;
                                        });
                                        bloc.validation
                                            .setState(res2.stateCode);
                                      }
                                      }
                                      },
                                    );
                                  }),
                              Text(
                                UcpStrings.sStateTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpBlack600),
                              ),
                              height12,
                              // height20,
                              StreamBuilder<Object>(
                                  stream: bloc.validation.state,
                                  builder: (context, snapshot) {
                                    return CustomizedTextField(
                                      textEditingController: stateController,
                                      hintTxt: UcpStrings.sStateTxt,
                                      readOnly: true,
                                      onChanged:
                                          bloc.validation.setState,
                                      keyboardType: TextInputType.name,
                                      surffixWidget: Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: Icon(Ionicons.chevron_down),
                                      ),
                                      onTap: () async {
                                        AllStateResponse res2=await  showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: AppColor.ucpWhite500,
                                          context: context,
                                          isDismissible: true,
                                          builder: (context) => SizedBox(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.7,
                                              child: StateDesign(countryId: selectedCountry!.countryCode,)
                                          ),
                                        );
                                        if(res2!=null){
                                          var selectedState =
                                              res2;
                                          setState(() {
                                            stateController.text =
                                                selectedState.stateName;
                                          });
                                          bloc.validation
                                              .setState(res2.stateCode);
                                        }
                                      },
                                    );
                                  }),

                            ],
                          ),
                        ),
                        Gap(40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              onTap: () {
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
                                stream: bloc.validation
                                    .completeSignupFourthPageValidation,
                                builder: (context, snapshot) {
                                  return CustomButton(
                                    onTap: () {
                                    //  bloc.add(GetAllCooperativesEvent());
                                    //   snapshot.data == true
                                    //       ?
                                      _creatUser();
                                          //: print("thd");
                                    },
                                    height: 51.h,
                                    width: 163.5.w,
                                    buttonText:
                                        UcpStrings.proceedTxt,
                                    borderRadius: 60.r,
                                    buttonColor: AppColor.ucpBlue500,
                                    textColor: AppColor.ucpWhite500,
                                  );
                                }),
                          ],
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
  _creatUser(){
   // var signupRequest = bloc.validation.signupRequest();
    bloc.add(SendSignUpOtpEvent(bloc.validation.signupOtpRequest()));
   // bloc.add(CreateAccountEvent( bloc.validation.signupRequest()));
  }
}
