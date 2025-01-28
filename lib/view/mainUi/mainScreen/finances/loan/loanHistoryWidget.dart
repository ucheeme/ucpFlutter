import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ucp/data/model/response/usersLoans.dart';

import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';

class LoanHistoryWidget extends StatefulWidget {
  UserLoans userLoans;
   LoanHistoryWidget({super.key,required this.userLoans});

  @override
  State<LoanHistoryWidget> createState() => _LoanHistoryWidgetState();
}

class _LoanHistoryWidgetState extends State<LoanHistoryWidget> {
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
                              Text(widget.userLoans.accountProduct.split("--")[0],
                                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.ucpBlack950
                                ),
                              ),
                              Spacer(),
                              Text(NumberFormat.currency(symbol: 'NGN', decimalDigits: 0).format(double.parse(widget.userLoans.loanAmount.toString())),
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
                              Text(convertDate(widget.userLoans.createdDate.toIso8601String()),
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
                                  color:widget.userLoans.status.toLowerCase() == "3"
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
                                        color:widget.userLoans.status.toLowerCase() == "3"
                                            ? AppColor.ucpSuccess150:AppColor.ucpDanger150,
                                      ),
                                    ),
                                    Gap(5.33.w),
                                    Text(widget.userLoans.status=="4"?"Active":"Closed",
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
