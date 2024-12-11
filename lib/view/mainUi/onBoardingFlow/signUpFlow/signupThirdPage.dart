import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signUpFourthPage.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signUpSecondPage.dart';

import '../../../../bloc/onboarding/on_boarding_bloc.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../bottomSheet/gender.dart';

class SignUpThirdPage extends StatefulWidget {
  OnBoardingBloc bloc;

  SignUpThirdPage({super.key, required this.bloc});

  @override
  State<SignUpThirdPage> createState() => _SignUpThirdPageState();
}

class _SignUpThirdPageState extends State<SignUpThirdPage> {
  bool isVisible = false;
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    widget.bloc = BlocProvider.of<OnBoardingBloc>(context);
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: AppColor.ucpWhite500,
              body: Padding(
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
                        "assets/images/logoWithoutText.png",
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
                        height: Get.height / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UcpStrings.genDaTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpBlack600),
                            ),
                            height12,
                            StreamBuilder<Object>(
                                stream: widget.bloc.validation.gender,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    textEditingController: genderController,
                                    hintTxt: UcpStrings.genderTxt,
                                    readOnly: true,
                                    keyboardType: TextInputType.name,
                                    surffixWidget: Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: Icon(Ionicons.chevron_down),
                                    ),
                                    onTap: () async {
                                      String? result =
                                          await showCupertinoModalBottomSheet(
                                              topRadius: Radius.circular(15.r),
                                              backgroundColor:
                                                  AppColor.ucpWhite50,
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                    height: 250.h,
                                                    color: AppColor.ucpWhite500,
                                                    child: GenderOptions());
                                              });
                                      setState(() {
                                        genderController.text = result ?? "";
                                      });
                                      },
                                    onChanged: widget.bloc.validation.setGender,
                                  );
                                }),
                            //  height20,
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
                                stream: widget.bloc.validation.userName,
                                builder: (context, snapshot) {
                                  return CustomizedTextField(
                                    error: snapshot.error?.toString(),
                                    keyboardType: TextInputType.name,
                                    onChanged:
                                        widget.bloc.validation.setUserName,
                                  );
                                }),
                            // height20,
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
                          CustomButton(
                            onTap: () {
                              Get.to(SignUpFourthPage(bloc: widget.bloc));
                            },
                            height: 51.h,
                            width: 163.5.w,
                            buttonText: "${UcpStrings.proceedTxt} (3 of 5)",
                            borderRadius: 60.r,
                            buttonColor: AppColor.ucpBlue500,
                            textColor: AppColor.ucpWhite500,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }
}
