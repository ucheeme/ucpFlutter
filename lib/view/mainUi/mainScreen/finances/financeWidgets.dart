import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/designUtils/reusableFunctions.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/withdraw/withdrawRequestScreen.dart';

import '../../../../data/model/response/withdrawTransactionHistory.dart';
import '../../../../utils/colorrs.dart';

class FinanceRequestListDesign extends StatelessWidget {
  WithdrawTransactionHistory requestData;
   FinanceRequestListDesign({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.h,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
      decoration:  BoxDecoration(
        color: AppColor.ucpWhite500,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child:Column(
        children: [
          SizedBox(
            height: 25.h,
            width: 319.w,
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Text(requestData.accountName,
                  style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                  fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.ucpBlack950
                ),
                ),
                Text(
                  requestData.accountBalance.isNegative
                      ? "- ${NumberFormat.currency(symbol: 'NGN', decimalDigits: 0).format(double.parse(requestData.accountBalance.toString().replaceAll("-", "")))}"
                      :
                  NumberFormat.currency(
                      symbol: 'NGN',
                      decimalDigits: 0)
                      .format(double.parse(requestData.accountBalance.toString())),
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColor.ucpBlack500),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25.h,
            width: 319.w,
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Text(dateTimeFormatterMDY(requestData.date.toIso8601String(),
                format: 'MMMM d, y'),
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.ucpBlack700
                ),
                ),
                WithdrawRequestStatus(status: requestData.status)
              ],
            ),
          ),
        ],
      ) ,
    );
  }
}

class WithdrawRequestStatus extends StatefulWidget {
  String status;
   WithdrawRequestStatus({super.key, required this.status});

  @override
  State<WithdrawRequestStatus> createState() => _WithdrawRequestStatusState();
}

class _WithdrawRequestStatusState extends State<WithdrawRequestStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w,),
      decoration:  BoxDecoration(
        color:getStatusColor(widget.status.toLowerCase()),
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: Row(
        children: [
          Container(
            height: 6.67.h,
            width: 6.67.w,
            decoration: BoxDecoration(
                color:getStatusColorSmallCircle(widget.status.toLowerCase()),
               shape: BoxShape.circle
            ),
          ),
          Gap(4.w),
          Text(widget.status,
            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                color: AppColor.ucpBlack800),
          ),
        ],
      ),
    );
  }
  Color getStatusColor(String status){
    if(status == 'pending'){
      return AppColor.ucpOrange50;
    }else if(status == 'approved'){
      return AppColor.ucpSuccess50;
    }else if(status == 'rejected'){
      return AppColor.ucpDanger50;
}
    return AppColor.ucpOrange50;
  }
}
Color getStatusColorSmallCircle(String status){
  if(status == 'pending'){
    return AppColor.ucpOrange500;
  }else if(status == 'approved'){
    return AppColor.ucpSuccess150;
  }else if(status == 'rejected'){
    return AppColor.ucpDanger200;
  }
  return AppColor.ucpOrange500;
}

class FinanceOptionDesign extends StatelessWidget {
  String title;
  String message;
  String icon;
  Color color;
  Function()? onTap;
   FinanceOptionDesign({super.key,
     this.onTap,
     required this.color, required this.title,
   required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 190.h,
        width: 167.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(icon,height: 32.h,width: 32.w,),
            Spacer(),
            SizedBox(
              height: 100.h,
              width: 141.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(title,
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack500
                    ),
                  ),
                 Spacer(),
                  SizedBox(
                    // height: 45.h,
                    width: 141.w,
                    child: Text(message,
                      style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.ucpBlack600
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
