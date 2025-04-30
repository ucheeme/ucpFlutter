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
import 'package:ucp/bloc/dashboard/dashboard_bloc.dart';
import 'package:ucp/bloc/profile/profile_bloc.dart';
import 'package:ucp/data/model/response/memberSavingAccounts.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';

import '../../../../bloc/onboarding/onBoardingValidation.dart';
import '../../../../bloc/profile/profileController.dart';
import '../../../../data/model/request/saveToAccount.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/customValidator.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../bottomSheet/SuccessNotification.dart';
import '../../../bottomSheet/memberSavingList.dart';
import '../../../bottomSheet/paymentmodebottomsheet.dart';
List<MemberSavingAccounts> tempMemberAccounts = [];
class ContributionScreen extends StatefulWidget {
  const ContributionScreen({super.key});

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  late ProfileBloc bloc;
String currentMonthlyPay ="";
  @override
  void initState() {
 WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   bloc.add(GetMemberCurrentMonthlyContributionEvent());
 });
    super.initState();
  }
  final controller = TextEditingController();
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
        if(state is MemberCurrentMonthlyContributionState){
              print("I an the value: ${state.response.monthlyContribution}");
         currentMonthlyPay = state.response.monthlyContribution.toString().split(".")[0];
        bloc.validation.contributionCurrentMonthlyAmountController.text = state.response.monthlyContribution.toString().split(".")[0];
        bloc.validation.setContributionCurrentMonthlyAmount(currentMonthlyPay);
          WidgetsBinding.instance.addPostFrameCallback((_){});
          bloc.initial();
        }
        if(state is RescheduleContributionState){
          WidgetsBinding.instance.addPostFrameCallback((_){
            showCupertinoModalBottomSheet(
              topRadius: Radius.circular(15.r),
              backgroundColor: AppColor.ucpWhite500,
              context: context,
              builder: (context) {
                return Container(
                  height: 400.h,
                  color: AppColor.ucpWhite500,
                  child: const LoadLottie(lottiePath: UcpStrings.ucpLottieSuccess1,
                    bottomText: "Request Sent, pending approval",
                  ),
                );
              },
            ).then((value){
              Get.back(result: true);
            });
            bloc.initial();
          });
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
                  stream: bloc.validation.contributionsValidation,
                  builder: (context, snapshot) {
                    return Container(
                      height: 83.h,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: const BoxDecoration(
                        color: AppColor.ucpBlue50,
                      ),
                      child: CustomButton(onTap: snapshot.hasData?(){
                       bloc.add(RescheduleContributionEvent(bloc.validation.rescheduleContributions()));
                      }:(){},
                        height: 51.h,
                        buttonText: "${UcpStrings.makeChangesTxt} ",
                        borderRadius: 60.r,
                        buttonColor: snapshot.hasData?AppColor.ucpBlue500:AppColor.ucpBlue300,
                        textColor: AppColor.ucpWhite500,
                      ),
                    );
                  }
              ),
              body:   ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 273.h,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          UcpStrings.contributionBg,fit: BoxFit.cover,
                        ),
                      ) ,
                      Positioned(
                        top: 50.h,
                        left: 15.w,
                        child: SizedBox(
                          height: 183.h,
                          width: 237.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color:AppColor.ucpWhite500,
                                    ),
                                  ),
                                ),
                              ),
                              Gap(20.h),
                              Text(UcpStrings.contributionTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.ucpWhite500
                                ),
                              ),
                              SizedBox(
                                height: 75.h,
                                width: 237.w,
                                child: Text(UcpStrings.contributionSubHeading,
                                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpBlue50
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  height20,
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Current Monthly Contribution",
                            style: CreatoDisplayCustomTextStyle.kTxtMedium
                                .copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack700),
                          ),
                    
                          height12,
                          StreamBuilder<Object>(
                              stream: bloc.validation.contributionCurrentMonthlyAmount,
                              builder: (context, snapshot) {
                                return CustomizedTextField(
                                  readOnly: true,
                                  inputFormat: [ThousandSeparatorFormatter(),],
                                  hintTxt: UcpStrings.amountTxt,
                                  keyboardType: TextInputType.number,
                                  textEditingController: bloc.validation.contributionCurrentMonthlyAmountController,
                                  onTap: () {
                                    setState(() {
                                     // isVisible = true;
                                    });
                                  },
                                  isTouched: bloc.validation.contributionCurrentMonthlyAmountController.text.isNotEmpty,
                                  onChanged:
                                  bloc.validation.setContributionAmount,
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
                          Text(
                            UcpStrings.contributionATxt ,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium
                                .copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack700),
                          ),
                          height12,
                          StreamBuilder<Object>(
                              stream: bloc.validation.amount,
                              builder: (context, snapshot) {
                                return CustomizedTextField(

                                  inputFormat: [ThousandSeparatorFormatter(),],
                                  hintTxt: UcpStrings.amountTxt,
                                  keyboardType: TextInputType.number,
                                  textEditingController: bloc.validation.contributionAmountController,
                                  onTap: () {
                                    setState(() {
                                     // isVisible = true;
                                    });
                                  },
                                  isTouched: bloc.validation.contributionAmountController.text.isNotEmpty,
                                  onChanged:
                                  bloc.validation.setContributionAmount,
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
                          // Text(UcpStrings.sMemberAccountTxt,
                          //   style: CreatoDisplayCustomTextStyle.kTxtMedium
                          //       .copyWith(
                          //       fontSize: 14.sp,
                          //       fontWeight: FontWeight.w500,
                          //       color: AppColor.ucpBlack700),
                          // ),
                          // CustomizedTextField(
                          //   readOnly: true,
                          //   textEditingController: controller,
                          //   hintTxt: UcpStrings.sMemberAccountTxt,
                          //   keyboardType: TextInputType.name,
                          //   surffixWidget: Padding(
                          //     padding: EdgeInsets.only(right: 8.w),
                          //     child: const Icon(Ionicons.chevron_down),
                          //   ),
                          //   isTouched:controller.text.isNotEmpty,
                          //   onTap: () => selectAccount(),
                          // ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  selectAccount() async {
    MemberSavingAccounts response =
        await showCupertinoModalBottomSheet(
        topRadius: Radius.circular(15.r),
        backgroundColor:
        AppColor.ucpWhite500,
        context: context,
        builder: (context) {
          return Container(
              height: 495.h,
              color: AppColor.ucpWhite500,
              child: MemberSavingAccountScreen(
                  memberAccounts:
                  tempMemberAccounts));
        });
    if (response != null) {
      controller.text=response.accountProduct;
      bloc.validation.setMemberAccountNumber(response.accountNumber);
     // accountNumber=response.accountNumber;
      setState(() {});
    }else{
     controller.text= "";
    }
  }
  selectModeOfPayment() async {
    bool response =
        await showCupertinoModalBottomSheet(
        topRadius: Radius.circular(15.r),
        backgroundColor:
        AppColor.ucpWhite500,
        context: context,
        builder: (context) {
          return Container(
              height: 495.h,
              color: AppColor.ucpWhite500,
              child: PaymentModeBottomSheet(
                  isSaving:true));
        });
    if (response) {
      Get.back();
    }else{

    }
  }
}
