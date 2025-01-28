import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/bloc/finance/finance_bloc.dart';
import 'package:ucp/bloc/finance/loanController.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/ApplyForLoan.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/CurrentLoans.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/GuarantorsLoan.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/loanRequests.dart';

import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';

class Loanmainscreen extends StatefulWidget {

  Loanmainscreen({super.key,});

  @override
  State<Loanmainscreen> createState() => _LoanmainscreenState();
}

class _LoanmainscreenState extends State<Loanmainscreen> {
  bool isRequests = true;
  bool isApply = false;
  bool isLoans = false;
  bool isGuarantors = false;
  LoanController controller = LoanController();
  late FinanceBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<FinanceBloc>(context);
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if(state is LoanApplicationCompletedState){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              isApply = false;
              isRequests =true;
            });
          });
          bloc.initial();
        }
        return Scaffold(
          bottomSheet: Visibility(
            visible: isApply,
            child: Container(
                height: 83.h,
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.ucpBlue50, //Color( 0xffEDF4FF),
                  // borderRadius: BorderRadius.only(
                  //   bottomRight: Radius.circular(15.r),
                  //   bottomLeft: Radius.circular(15.r),
                  // ),
                ),
                child: CustomButton(
                  onTap: () {
                    if (controller.loanProductController.text.isNotEmpty
                        && controller.loanAmountController.text.isNotEmpty
                        && controller.loanDurationController.text.isNotEmpty
                        && controller.netMonthlyPayController.text.isNotEmpty
                    ) {
                      bloc.add(GetAllGuarantorsEvent());
                    } else {
                      AppUtils.showSnack(UcpStrings.fillAllFields, context);
                    }
                    // Get.back(result: selectedCooperative);
                  },
                  borderRadius: 30.r,
                  buttonColor: AppColor.ucpBlue500,
                  buttonText: UcpStrings.doneTxt,
                  height: 51.h,
                  textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: AppColor.ucpWhite500,
                  ),
                  textColor: AppColor.ucpWhite500,
                )
            ),),
          body: Stack(
            children: [
              selectedScreen(),
              UCPCustomAppBar(
                  height: 120.h,
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
                          Text(isRequests ? UcpStrings.loanRequestTxt :
                          isApply ? UcpStrings.applyForLoan :
                          isLoans ? UcpStrings.loanHistory :
                          isGuarantors ? UcpStrings.guarantorApproval : "",
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
                        width: 334.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: AppColor.ucpBlue25,
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRequests = true;
                                  isApply = false;
                                  isLoans = false;
                                  isGuarantors = false;
                                });
                              },
                              child: AnimatedContainer(
                                height: 32.h,
                                width: 84.w,
                                decoration: BoxDecoration(
                                  color: isRequests
                                      ? AppColor.ucpBlue600
                                      : Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(40.r),
                                ),
                                duration:
                                const Duration(milliseconds: 500),
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isRequests = false;
                                  isApply = true;
                                  isLoans = false;
                                  isGuarantors = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration:
                                const Duration(milliseconds: 400),
                                height: 32.h,
                                width: 62.w,
                                decoration: BoxDecoration(
                                  color: isApply
                                      ? AppColor.ucpBlue600
                                      : Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(40.r),
                                ),
                                child: Center(
                                  child: Text(
                                    UcpStrings.applyTxt,
                                    style: CreatoDisplayCustomTextStyle
                                        .kTxtMedium
                                        .copyWith(
                                      fontSize: 14.sp,
                                      color: isApply
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
                                  isRequests = false;
                                  isApply = false;
                                  isLoans = true;
                                  isGuarantors = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration:
                                const Duration(milliseconds: 500),
                                height: 32.h,
                                width: 74.w,
                                decoration: BoxDecoration(
                                  color: isLoans
                                      ? AppColor.ucpBlue600
                                      : Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(40.r),
                                ),
                                child: Center(
                                  child: Text(
                                    UcpStrings.loanTxt,
                                    style: CreatoDisplayCustomTextStyle
                                        .kTxtMedium
                                        .copyWith(
                                      fontSize: 14.sp,
                                      color: isLoans
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
                                  isRequests = false;
                                  isApply = false;
                                  isLoans = false;
                                  isGuarantors = true;
                                });
                              },
                              child: AnimatedContainer(
                                height: 32.h,
                                width: 94.w,
                                decoration: BoxDecoration(
                                  color: isGuarantors
                                      ? AppColor.ucpBlue600
                                      : Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(40.r),
                                ),
                                duration:
                                const Duration(milliseconds: 500),
                                child: Center(
                                  child: Text(
                                    UcpStrings.guarantorTxt,
                                    style: CreatoDisplayCustomTextStyle
                                        .kTxtMedium
                                        .copyWith(
                                      fontSize: 14.sp,
                                      color: isGuarantors
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
                      )
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget selectedScreen() {
    if (isRequests) {
      return LoanRequestsScreen(controller: controller,);
    } else if (isApply) {
      return ApplyForLoan(controller: controller,);
    } else if (isLoans) {
      return UserCurrentLoans(controller: controller,);
    } else if (isGuarantors) {
      return LoanGuarantors();
    } else {
      return Text(UcpStrings.requestTxt);
    }
  }
}
