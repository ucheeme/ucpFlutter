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
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signupFifthPage.dart';

import '../../../../bloc/onboarding/on_boarding_bloc.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../bottomSheet/gender.dart';

class SignUpFourthPage extends StatefulWidget {
  OnBoardingBloc bloc;
   SignUpFourthPage({super.key, required this.bloc});

  @override
  State<SignUpFourthPage> createState() => _SignUpFourthPageState();
}

class _SignUpFourthPageState extends State<SignUpFourthPage> {
  bool isVisible=false;
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
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
                        height:MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(UcpStrings.enterHomeAddressTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            StreamBuilder<Object>(
                                stream: widget.bloc.validation.userName,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    textEditingController: homeAddressController,
                                    error: snapshot.error?.toString(),
                                    hintTxt:UcpStrings.enterHomeAddressTxt,
                                    keyboardType: TextInputType.name,
                                    onChanged: widget.bloc.validation.setUserName,
                                  );
                                }
                            ),
                            //  height20,
                            Text(UcpStrings.sCountryTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            // height20,
                            CustomizedTextField(
                              textEditingController: countryController,
                              hintTxt: UcpStrings.sCountryTxt,
                              readOnly: true,
                              keyboardType: TextInputType.name,
                              surffixWidget: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child:  Icon(Ionicons.chevron_down),
                              ),
                              onTap: () async {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: AppColor.ucpWhite500,
                                  context: context,
                                  isDismissible: true,
                                  builder: (context) =>  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    child: ShowCountryDialog(
                                      searchHint: 'Search for a country',
                                      substringBackground: Colors.black,
                                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpBlack500
                                      ),
                                      countryHeaderStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpBlack500
                                      ),
                                      searchStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpBlack500
                                      ),
                                      subStringStyle:  CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpWhite500
                                      ),
                                      selectedCountryBackgroundColor: AppColor.ucpWhite500,
                                      notSelectedCountryBackgroundColor:AppColor.ucpWhite500,
                                      onSelectCountry: (){setState(() {
                                       var selectedCountry = Selected.country;
                                       setState(() {
                                        countryController.text =selectedCountry;
                                       });
                                      });},
                                    ),
                                  ),

                                );
                              },
                            ),
                            Text(UcpStrings.sStateTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            // height20,
                            CustomizedTextField(
                              textEditingController: stateController,
                              hintTxt: UcpStrings.sStateTxt,
                              readOnly: true,
                              keyboardType: TextInputType.name,
                              surffixWidget: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child:  Icon(Ionicons.chevron_down),
                              ),
                              onTap: () async {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: AppColor.ucpWhite500,
                                  isDismissible: true,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    child: ShowStateDialog(
                                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpBlack500
                                      ),
                                      stateHeaderStyle:  CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpBlack500
                                      ),
                                      subStringStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpWhite500
                                      ),
                                      substringBackground: Colors.black,
                                      selectedStateBackgroundColor: AppColor.ucpWhite500,
                                      notSelectedStateBackgroundColor:AppColor.ucpWhite500,
                                      onSelectedState: (){
                                        setState(() {
                                         var selectedState = Selected.state;
                                         setState(() {
                                          stateController.text=selectedState;
                                         });
                                        });
                                      },
                                    ),
                                  ),

                                );
                              },
                            ),
                            Text(UcpStrings.sCityTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack600
                              ),),
                            height12,
                            // height20,
                            CustomizedTextField(
                              textEditingController: cityController,
                              hintTxt: UcpStrings.sCityTxt,
                              readOnly: true,
                              keyboardType: TextInputType.name,
                              surffixWidget: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child:  Icon(Ionicons.chevron_down),
                              ),
                              onTap: () async {
                               showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: AppColor.ucpWhite10,
                                  isDismissible: true,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    child:  ShowCityDialog(
                                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpBlack500
                                      ),
                                      countryHeaderStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpBlack500
                                      ) ,
                                      subStringStyle:  CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpWhite500
                                      ),
                                      substringBackground: Colors.black,
                                      selectedCityBackgroundColor:AppColor.ucpWhite500,
                                      notSelectedCityBackgroundColor:AppColor.ucpWhite500,
                                      onSelectedCity: (){
                                        setState(() {
                                        var selectedCity = Selected.city;
                                        setState(() {
                                          cityController.text =selectedCity;
                                        });
                                        });
                                       },
                                    ),
                                  ),
                                );
                              },
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
                          CustomButton(onTap: () {
                             Get.to(SignUpfifthPage(bloc: widget.bloc));
                          },
                            height: 51.h,
                            width: 163.5.w,
                            buttonText: "${UcpStrings.proceedTxt} (4 of 5)",
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
}
