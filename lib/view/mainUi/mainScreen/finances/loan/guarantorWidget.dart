import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../data/model/response/guarantorRequestList.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';

class GuarantorWidget extends StatelessWidget {
  GuarantorRequestsLoanApplicant guarantorRequestsLoanApplicant;
   GuarantorWidget({super.key,required this.guarantorRequestsLoanApplicant});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: 343.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColor.ucpWhite500,
      ),
      child: Row(
        children: [
          Container(
            height: 35.h,
            width: 35.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.ucpBlue600, width: 0.88.w),
              shape: BoxShape.circle,
              image: DecorationImage(image:
              NetworkImage(guarantorRequestsLoanApplicant.profileImage), fit: BoxFit.cover),
            ),
          ),
          Gap(10.w),
          SizedBox(
            height: 44.33.h,
            width: 274.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(guarantorRequestsLoanApplicant.loanApplicant,style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ucpBlack950
                      ),),
                      Text(NumberFormat.currency(symbol: 'NGN', decimalDigits: 0)
                          .format(double.parse(guarantorRequestsLoanApplicant.loanAmount.toString())),
                        style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ucpBlack500
                      ),),
                    ],
                  ),
                ),
                Gap(2.h),
                SizedBox(
                  height: 20.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${guarantorRequestsLoanApplicant.duration.toString()} months",style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.ucpBlack700
                      ),),
                      Icon(Icons.arrow_forward_ios,color: AppColor.ucpBlack500,size: 18.w,)
                    ],
                  ),
                ),
              ]),
          )
        ],
      ),
    );
  }
}
