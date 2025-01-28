import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/designUtils/reusableFunctions.dart';
import 'package:ucp/utils/designUtils/reusableWidgets.dart';
import 'package:ucp/utils/ucpLoader.dart';

import '../../bloc/finance/finance_bloc.dart';
import '../../data/model/response/guarantorRequestList.dart';
import '../../utils/appStrings.dart';

class LoanApprovalScreen extends StatelessWidget {
  VoidCallback onTapAccept;
  VoidCallback onTapDecline;
  FinanceState state;
  GuarantorRequestsLoanApplicant requestsLoanApplicant;
  LoanApprovalScreen({Key? key,
    required this.state,
    required this.requestsLoanApplicant,
    required this.onTapAccept,required this.onTapDecline})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UCPLoadingScreen(
      visible: state is FinanceIsLoading,
      loaderWidget: LoadingAnimationWidget.discreteCircle(
        color: AppColor.ucpBlue500,
        size: 40.h,
        secondRingColor: AppColor.ucpBlue100,
      ),
      overlayColor: AppColor.ucpBlack400,
      transparency: 0.2,
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite10,
        bottomSheet:   Container(
          height: 83.h,
          color: AppColor.ucpBlue100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(onTap: onTapDecline,
                  borderRadius: 25.r,
                  height: 51.h,
                  width: 168.w,
                  buttonColor:AppColor.ucpBlue50,
                  textColor:AppColor.ucpBlack500,
                  buttonText: "Decline"),
              CustomButton(onTap: onTapAccept,
                  borderRadius: 25.r,
                  height: 51.h,
                  width: 168.w,
                  buttonColor:AppColor.ucpBlue500,
                  textColor:AppColor.ucpWhite500,
                  buttonText: "Accept"),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile and header card
                  Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage(UcpStrings.dashBoardB),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    padding: EdgeInsets.all(16.h),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: NetworkImage(
                              requestsLoanApplicant.profileImage), // Replace with your asset
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              requestsLoanApplicant.loanApplicant,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                color: AppColor.ucpWhite500,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'email address',
                              style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                color: AppColor.ucpWhite500,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'No contact',
                              style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                color: AppColor.ucpWhite500,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Loan details card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.ucpWhite500,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _loanDetail('Loan amount', NumberFormat.currency(symbol: 'NGN', decimalDigits: 0)
                                .format(double.parse(requestsLoanApplicant.loanAmount.toString()))),
                            _loanDetail('Loan product',  requestsLoanApplicant.productName),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _loanDetail('Start Date', requestsLoanApplicant.date.format('F d, Y')),
                            _loanDetail('End Date', 'Not specified'),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NumberFormat.currency(symbol: 'NGN', decimalDigits: 0)
                                  .format(double.parse(requestsLoanApplicant.loanAmount.toString())),
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                color: AppColor.ucpBlack500,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${requestsLoanApplicant.duration} months',
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                color: AppColor.ucpBlack500,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60.h),
                  // Buttons
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loanDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
            color: AppColor.ucpWhite600,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
            color: AppColor.ucpBlack500,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // primary: color,
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
