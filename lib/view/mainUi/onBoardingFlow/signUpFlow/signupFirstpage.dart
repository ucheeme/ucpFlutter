import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/bloc/onboarding/on_boarding_bloc.dart';
import 'package:ucp/data/model/response/cooperativeList.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/bottomSheet/cooperatives.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signUpSecondPage.dart';

import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../utils/sharedPreference.dart';

class SignUpFirstPage extends StatefulWidget {
  const SignUpFirstPage({super.key});

  @override
  State<SignUpFirstPage> createState() => _SignUpFirstPageState();
}

class _SignUpFirstPageState extends State<SignUpFirstPage> {
  bool isVisible = false;
  late OnBoardingBloc bloc;
  List<CooperativeListResponse> cooperativeList = [];
  bool isMember = false,
      isNotMember = false,
      isAcceptTermsAndConditions = false;
TextEditingController textEditingController = TextEditingController();
TextEditingController membershipAmountController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(allCooperatives.isEmpty){
        bloc.add(GetAllCooperativesEvent());
      }
    });
    super.initState();
  }



  bool completed= false;
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<OnBoardingBloc>(context);
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        if (state is AllCooperatives) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            cooperativeList = state.response;
            allCooperatives= cooperativeList;
            CooperativeListResponse response =
                await showCupertinoModalBottomSheet(
                topRadius: Radius.circular(15.r),
                backgroundColor:
                AppColor.ucpWhite500,
                context: context,
                builder: (context) {
                  return Container(
                      height: 485.h,
                      color: AppColor.ucpWhite500,
                      child: CooperativeListDesign(
                          cooperativeList:
                          cooperativeList));
                });
            if (response != null) {
              bloc.validation.selectedCooperative = response;
              setState(() {
                textEditingController.text =
                    response.tenantName;
              });
            }
          });
          bloc.initial();
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
                        Image.asset(UcpStrings.ucpLogo,
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
                        Text(
                          UcpStrings.dYHMemberIDTxt,
                          style: CustomTextStyle.kTxtRegular.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColor.ucpBlack600),
                        ),
                        height16,
                        SizedBox(
                          height: 19.h,
                          width: 343.w,
                          child: Row(
                            children: [
                              SizedBox(
                                  height: 19.h,
                                  width: 171.5.w,
                                  child: UCPRadioButton(
                                    isSelected: isMember,
                                    isDmSans: false,
                                    radioText: UcpStrings.yIDoTxt,
                                    onTap: () {
                                      setState(() {
                                        isMember = true;
                                        isNotMember = false;
                                        bloc.validation.isMember = isMember;

                                      });

                                    },
                                  )),
                              SizedBox(
                                height: 19.h,
                                width: 171.5.w,
                                child: UCPRadioButton(
                                  isSelected: isNotMember,
                                  onTap: () {
                                    setState(() {
                                      isMember = false;
                                      isNotMember = true;
                                      bloc.validation.isNotMember = isNotMember;

                                    });

                                  },
                                  isDmSans: false,
                                  radioText: UcpStrings.nIDoTxt,
                                ),
                              )
                            ],
                          ),
                        ),
                        height20,
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<Object>(
                                  stream: bloc.validation.memberId,
                                  builder: (context, snapshot) {
                                    return Visibility(
                                      visible: isMember,
                                      child: CustomizedTextField(
                                        hintTxt: UcpStrings.enterMemberIdTxt,
                                        keyboardType: TextInputType.name,
                                        onChanged: bloc.validation.setMemberNo,
                                        error: snapshot.error?.toString(),
                                      ),
                                    );
                                  }),
                              height10,
                              Text(
                                UcpStrings.sCooperativeTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpBlack600),
                              ),
                              height12,
                              CustomizedTextField(
                                readOnly: true,
                                textEditingController: textEditingController,
                                hintTxt: UcpStrings.sCooperativeTxt,
                                keyboardType: TextInputType.name,
                                surffixWidget: Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: const Icon(Ionicons.chevron_down),
                                ),
                                onTap: () async {
                                  if (allCooperatives.isEmpty) {
                                    bloc.add(GetAllCooperativesEvent());
                                  } else {
                                    CooperativeListResponse response =
                                        await showCupertinoModalBottomSheet(
                                            topRadius: Radius.circular(15.r),
                                            backgroundColor:
                                                AppColor.ucpWhite500,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                  height: 485.h,
                                                  color: AppColor.ucpWhite500,
                                                  child: CooperativeListDesign(
                                                      cooperativeList:
                                                          cooperativeList));
                                            });
                                    if (response != null) {
                                      bloc.validation.selectedCooperative = response;
                                      setState(() {
                                        textEditingController.text =
                                            response.tenantName;
                                      });
                                    }
                                  }
                                },
                              ),
                              height20,
                              Text(
                                UcpStrings.membershipFeeTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpBlack600),
                              ),
                              height12,
                              StreamBuilder<Object>(
                                  stream: bloc.validation.memberAmount,
                                  builder: (context, snapshot) {
                                    return CustomizedTextField(
                                      inputFormat: [ThousandSeparatorFormatter(),],
                                      hintTxt: UcpStrings.amountTxt,
                                      keyboardType: TextInputType.number,
                                      textEditingController: membershipAmountController,
                                      onTap: () {
                                        setState(() {
                                          isVisible = true;
                                        });
                                      },
                                      onChanged:
                                          bloc.validation.setMembershipAmount,
                                      error: snapshot.error?.toString(),
                                      prefixWidget: Visibility(
                                          child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.w, right: 8.w),
                                        child: Text(
                                          "NGN",
                                          style: CreatoDisplayCustomTextStyle
                                              .kTxtBold
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                  color: AppColor.ucpBlack500),
                                        ),
                                      )),
                                    );
                                  }),
                              height30,
                              UCPRadioButton(
                                isSelected: isAcceptTermsAndConditions,
                                isDmSans: false,
                                radioText: UcpStrings.aTermsAndConditionsTxt,
                                onTap: () {
                                  setState(() {
                                    isAcceptTermsAndConditions =
                                        !isAcceptTermsAndConditions;
                                  });
                                  bloc.validation.isAcceptTermsAndCondition =
                                      isAcceptTermsAndConditions;
                                },
                              ),
                            ],
                          ),
                        ),
                        height30,
                        CustomButton(
                          onTap: () {
                              bloc.validation.firstPageCheck()?
                            Get.to(
                              SignUpSecondPage(bloc: bloc),
                              curve: Curves.easeIn,
                            ):null;
                            //  null;
                          },
                          height: 51.h,
                          buttonText: "${UcpStrings.proceedTxt} (1 of 5)",
                          borderRadius: 60.r,
                          buttonColor: AppColor.ucpBlue500,
                          textColor: AppColor.ucpWhite500,
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
