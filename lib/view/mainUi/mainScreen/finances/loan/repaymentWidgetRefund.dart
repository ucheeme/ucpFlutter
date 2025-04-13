import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../data/model/response/loanRequestBreakDown.dart';
import '../../../../../data/model/response/loanScheduleForRefund.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/animatedPieChart.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';

class RefundWidget extends StatefulWidget {
  LoanScheduleForRefundResponse data;
  double total;
  int index;

  RefundWidget({super.key,
        required this.data,
        required this.total,
        required this.index});

  @override
  State<RefundWidget> createState() => _RefundWidgetState();
}

class _RefundWidgetState extends State<RefundWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 319.w,
      //margin: EdgeInsets.symmetric(vertical: 20.h,horizontal: 12.w),
      child: Row(
        children: [
          SizedBox(
            height: 46.h,
            width: 46.w,
            child: AnimatePieChart(
             // total: widget.total,
              total: widget.total,
              colorBackground: widget.data.paymentStatus.toLowerCase() == "outstanding"?AppColor.ucpDanger150:AppColor.ucpSuccess150,
              color:  widget.data.paymentStatus.toLowerCase() == "outstanding"?AppColor.ucpDanger50:AppColor.ucpSuccess50,
              dataMap: {
                "totalAmount": widget.total,
                "amountToPay": widget.data.totalRepayAmount.runtimeType==int?(widget.data.principalAmount*widget.index):
                (widget.data.totalRepayAmount * widget.index),
              },
              colorList: widget.data.paymentStatus.toLowerCase() == "outstanding"?
              [
                AppColor.ucpDanger50,
                AppColor.ucpDanger150,
              ]: [
                AppColor.ucpSuccess50,
                AppColor.ucpSuccess150,
              ],
            ),
          ),
          Gap(10.w),
          SizedBox(
            height: 48.3.h,
            width: 259.w,
            child: Column(
              children: [
                SizedBox(
                  height: 24.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.index}${getSuffix(widget.index)} loan payment",
                        style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500),
                      ),
                      Gap(16.w),
                      Text(
                        NumberFormat.currency(symbol: 'NGN', decimalDigits: 0)
                            .format(double.parse(widget.data.totalRepayAmount.toString())),
                        style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 24.33.h,
                         width:widget.data.paymentStatus.toLowerCase() == "outstanding"?90.33.w:50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color:widget.data.paymentStatus.toLowerCase() == "outstanding"
                              ? AppColor.ucpDanger75:AppColor.ucpSuccess50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 7.h,
                              width: 7.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:widget.data.paymentStatus.toLowerCase() == "outstanding"
                                    ? AppColor.ucpDanger150:AppColor.ucpSuccess150,
                              ),
                            ),
                            Gap(3.33.w),
                            Text(widget.data.paymentStatus??"",
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack800
                              ),
                            ),
                          ],
                        ),
                      ),
                     widget.data.paymentStatus.toLowerCase() == "outstanding"?
                     Text(
                       "Due in ${checkDateDifference(widget.data.dueDate.toIso8601String())} ",
                       style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                           fontSize: 12.sp,
                           fontWeight: FontWeight.w400,
                           color: AppColor.ucpBlack600),
                     )
                         : Text(
                        "${widget.data.paymentStatus} ${convertDate(widget.data.dueDate.toIso8601String())} ",
                        style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColor.ucpBlack600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
String formatDate(String inputDate) {
  // Parse the input string into a DateTime object
  DateTime parsedDate = DateTime.parse(inputDate);

  // Format the date into "MMM. dd, yyyy"
  String formattedDate = DateFormat("MMM. dd, yyyy").format(parsedDate);

  return formattedDate;
}
String checkDateDifference(String inputDate) {
  // Parse the input date
  DateTime parsedDate = DateTime.parse(inputDate);

  // Get today's date without time
  DateTime today = DateTime.now();
  DateTime todayOnly = DateTime(today.year, today.month, today.day);
  DateTime parsedDateOnly = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

  // Calculate the difference in days
  int difference = parsedDateOnly.difference(todayOnly).inDays;

  // Output result
  if (difference == 0) {
    print("The date is today!");
    return "Today";
  } else if (difference > 0) {
    if(difference<31){
      return parsedDateOnly.format("F d, Y");
    }else{
      return "$difference days";
    }

  } else {
    if(difference<31){
      return parsedDateOnly.format("F d, Y");
    }else{
      return"${-difference} days";
    }

  }
}
