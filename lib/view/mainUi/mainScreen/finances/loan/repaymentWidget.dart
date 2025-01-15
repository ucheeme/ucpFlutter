import 'package:custom_grid_view/custom_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ucp/utils/designUtils/animatedPieChart.dart';

import '../../../../../data/model/response/loanRequestBreakDown.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';

class Repaymentwidget extends StatefulWidget {
  LoanRequestBreakdownList data;
  double total;
  int index;
   Repaymentwidget({super.key,required this.data,required this.total,required this.index});

  @override
  State<Repaymentwidget> createState() => _RepaymentwidgetState();
}

class _RepaymentwidgetState extends State<Repaymentwidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 319.w,
      //margin: EdgeInsets.symmetric(vertical: 20.h,horizontal: 12.w),
      child: Row(
        children: [
      SizedBox(
        height: 46.h,
        width: 46.w,
        child: AnimatePieChart(
          total:widget.total ,
          dataMap: {"totalAmount":widget.total,
          "amountToPay": (widget.data.total*widget.index),
          },
            colorList: [AppColor.ucpBlack50,AppColor.ucpWhite600,],
        ),
      ),
          Gap(10.w),
          SizedBox(
            height: 46.3.h,
            width: 259.w,
            child: Column(
              children: [
                SizedBox(height:24.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${widget.index}${getSuffix(widget.index)} loan payment",
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ucpBlack500
                      ),),
                    Gap(16.w),
                    Text(NumberFormat.currency(symbol: 'NGN', decimalDigits: 0).format(double.parse(widget.data.total.toString())),
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ucpBlack500
                      ),),
                  ],
                ),
                    )
                  ],
                ),
                ),
              ],
            ),
          );
  }
}
