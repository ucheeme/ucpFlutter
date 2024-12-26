import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/retirement/retireScreen.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/retirement/retirementHistory.dart';

import '../../../../../bloc/finance/finance_bloc.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../withdraw/withdrawFundScreen.dart';

class RetirementScreen extends StatefulWidget {
  const RetirementScreen({super.key});

  @override
  State<RetirementScreen> createState() => _RetirementScreenState();
}

class _RetirementScreenState extends State<RetirementScreen> {
  late FinanceBloc bloc;
  bool isRetire =true;
  bool isRequests=false;
  int selectedIndex = 0;
  int selectedMOPIndex = 0;
  WithdrawPaymentMode selectedModeOfPayment=WithdrawPaymentMode(title: "Cash",paymentId: 1);
  List<WithdrawPaymentMode>modeOfPayment =[WithdrawPaymentMode(title: "Cash",paymentId: 1),WithdrawPaymentMode(title: "Cheque",paymentId: 2), WithdrawPaymentMode(title: "Transfer", paymentId: 3)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isRetire?
          const RetireScreen():
          RitirementRequestHistory(),
          UCPCustomAppBar(
              height: 145.h,
              appBarColor: AppColor.ucpWhite10.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(40.h),
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
                      Text(UcpStrings.retirementTxt,
                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                            .copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500),
                      )
                    ],
                  ),
                  height10,
                  Container(
                    height: 40.h,
                    width: 164.w,
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColor.ucpBlue25,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isRetire = true;
                              isRequests = false;
                            });
                          },
                          child: AnimatedContainer(
                            height: 32.h,
                            width: 62.w,
                            decoration: BoxDecoration(
                              color: isRetire
                                  ? AppColor.ucpBlue600
                                  : Colors.transparent,
                              borderRadius:
                              BorderRadius.circular(40.r),
                            ),
                            duration:
                            const Duration(milliseconds: 500),
                            child: Center(
                              child: Text(
                                UcpStrings.retireTxt,
                                style: CreatoDisplayCustomTextStyle
                                    .kTxtMedium
                                    .copyWith(
                                  fontSize: 14.sp,
                                  color: isRetire
                                      ? AppColor.ucpWhite500
                                      : AppColor.ucpBlack800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isRetire = false;
                              isRequests = true;
                            });
                          },
                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 400),
                            height: 32.h,
                            width: 84.w,
                            decoration: BoxDecoration(
                              color: isRequests
                                  ? AppColor.ucpBlue600
                                  : Colors.transparent,
                              borderRadius:
                              BorderRadius.circular(40.r),
                            ),
                            child: Center(
                              child: Text(
                                UcpStrings.requestTxt,
                                style: CreatoDisplayCustomTextStyle
                                    .kTxtMedium
                                    .copyWith(
                                  fontSize: 14.sp,
                                  color: isRequests
                                      ? AppColor.ucpWhite500
                                      : AppColor.ucpBlack800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}



class RetireFigmaDesign extends StatefulWidget {
  const RetireFigmaDesign({super.key});

  @override
  State<RetireFigmaDesign> createState() => _RetireFigmaDesignState();
}

class _RetireFigmaDesignState extends State<RetireFigmaDesign> {
  int selectedIndex = 0;
  int selectedMOPIndex = 0;
  WithdrawPaymentMode selectedModeOfPayment=WithdrawPaymentMode(title: "Cash",paymentId: 1);
  List<WithdrawPaymentMode>modeOfPayment =[WithdrawPaymentMode(title: "Cash",paymentId: 1),WithdrawPaymentMode(title: "Cheque",paymentId: 2), WithdrawPaymentMode(title: "Transfer", paymentId: 3)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(
        children: [
          Gap(140.h),
          SizedBox(
            height: 272.h,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 98.h,
                  child: Stack(
                    children: [
                      Container(
                        height: 92.h,
                        width: 343.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColor.ucpBlue500)
                        ),
                        child: Image.asset(UcpStrings.dashBoard2B,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 20.h,
                        left: 40.w,
                        right: 40.w,
                        child: Column(
                          children: [
                            Text(UcpStrings.tRetirementAmt,
                              style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpOrange300
                              ),
                            ),
                            Text(NumberFormat.currency(name: 'NGN',decimalDigits: 0).format(345082),
                              style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.ucpWhite500
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                height8,
                SizedBox(
                  height: 156.h,
                  child: Stack(
                    children: [
                      Container(
                        height: 152.h,
                        width: 343.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Image.asset(UcpStrings.dashBoard3B,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 20.h,
                        left: 40.w,
                        right: 40.w,
                        bottom: 20.h,
                        child: SizedBox(
                          height: 112.h,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 48.h,
                                width: 303.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 48.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(UcpStrings.memberBalance,
                                            style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.ucpBlue25
                                            ),
                                          ),
                                          Text(NumberFormat.currency(name: 'NGN',decimalDigits: 0).format(345082),
                                            style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.ucpWhite500
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 48.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(UcpStrings.loanPrincipal,
                                            style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.ucpBlue25
                                            ),
                                          ),
                                          Text(NumberFormat.currency(name: 'NGN',decimalDigits: 0).format(345082),
                                            style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.ucpWhite500
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 48.h,
                                width: 303.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 48.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(UcpStrings.loanInterest,
                                            style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.ucpBlue25
                                            ),
                                          ),
                                          Text(NumberFormat.currency(name: 'NGN',decimalDigits: 0).format(345082),
                                            style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.ucpWhite500
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 48.h,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(UcpStrings.charges,
                                            style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.ucpBlue25
                                            ),
                                          ),
                                          Text(NumberFormat.currency(name: 'NGN',decimalDigits: 0).format(345082),
                                            style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.ucpWhite500
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          height24,
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(UcpStrings.selectPaymentMode,
              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: AppColor.ucpBlack800
              ),),
          ),
          height8,
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 200.h,
              child: ListView(

                  children: modeOfPayment
                      .mapIndexed((element, index) =>
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedModeOfPayment = element;
                            selectedMOPIndex = index;
                          });
                        },
                        child: Container(
                            height: element.title.length > 30
                                ? 70.h
                                : 48.h,
                            margin: EdgeInsets.only(
                              bottom: 14.h, ),
                            padding:
                            EdgeInsets.symmetric(horizontal: 12.h),
                            decoration: BoxDecoration(
                                color: (index == selectedMOPIndex)
                                    ? AppColor.ucpBlue25
                                    : AppColor.ucpWhite500,
                                borderRadius:
                                BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: (index == selectedMOPIndex)
                                      ? AppColor.ucpBlue500
                                      : AppColor.ucpWhite500,
                                )),
                            child: BottomsheetRadioButtonRightSide(
                              radioText: element.title,
                              isMoreThanOne:
                              element.title.length > 30,
                              isDmSans: false,
                              isSelected: index == selectedMOPIndex,
                              onTap: () {
                                setState(() {
                                  selectedMOPIndex = index;
                                });
                              },
                              textHeight: element.title.length > 30
                                  ? 24.h
                                  : 16.h,
                            )),
                      )
                  )
                      .toList()),
            ),
          ),
        ],
      ),
    );
  }
}