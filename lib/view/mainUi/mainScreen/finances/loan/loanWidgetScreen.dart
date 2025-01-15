import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../data/model/response/loanApplicationResponse.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';

class LoanRequestWidget extends StatelessWidget {
  LoanRequests loanRequests;
   LoanRequestWidget({super.key, required this.loanRequests});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.33.h,
      width: 343.w,
     padding: EdgeInsets.symmetric(horizontal: 12.w),
     decoration: BoxDecoration(
       color: AppColor.ucpWhite500,
       borderRadius: BorderRadius.circular(12.r)
     ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         SizedBox(
           height: 56.h,
           width: 291.w,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               SizedBox(
                 height: 24.h,
              child: Row(
               children: [
            Text(loanRequests.productName,
              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.ucpBlack950
              ),
            ),
            Spacer(),
            Text(NumberFormat.currency(symbol: 'NGN', decimalDigits: 0).format(double.parse(loanRequests.loanAmount.toString())),
              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.ucpBlack500
              ),
            ),
             ]
        )
               ),
               SizedBox(
                 height: 24.h,
              child: Row(
               children: [
            Text("${loanRequests.duration} months",
              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.ucpBlack700
              ),
            ),
            Spacer(),
            Container(
              height: 24.33.h,
              width: 80.33.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color:loanRequests.status.toLowerCase() == "pending"
                    ? AppColor.ucpOrange100
                    : loanRequests.status.toLowerCase() == "approved"||
                    loanRequests.status.toLowerCase() == "disbursed"
                    ? AppColor.ucpSuccess50:AppColor.ucpDanger75,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 7.h,
                    width: 7.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:loanRequests.status.toLowerCase() == "pending"
                          ? AppColor.ucpOrange500
                          : loanRequests.status.toLowerCase() == "approved"||
                          loanRequests.status.toLowerCase() == "disbursed"
                          ? AppColor.ucpSuccess150:AppColor.ucpDanger150,
                    ),
                  ),
                  Gap(3.33.w),
                  Text(loanRequests.status,
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack800
                    ),
                  ),
                ],
              ),
            )
             ]
        )
               ),
         ])
        ,),
           Icon(Icons.arrow_forward_ios,color: AppColor.ucpBlack500,size: 18.w,)

        ]),);
  }
}
