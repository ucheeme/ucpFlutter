import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ucp/utils/appStrings.dart';

import '../../../../data/model/response/transactionHistoryResponse.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';

class TransactWidget extends StatelessWidget {
  UserTransaction transaction;
  String transactionType;
   TransactWidget({super.key,
     required this.transaction,
     required this.transactionType});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.h,
      width: 343.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 49.h,
            width: 200.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                transactionType=="debit"?
                Image.asset(UcpStrings.ucpDebitImage,height: 32.h,width: 32.w,):
                Image.asset(UcpStrings.ucpCreditImage,height: 32.h,width: 32.w,),
                Gap(12.w),
                SizedBox(
                  height: 49.h,
                  width: 140.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140.w,
                        child: Text(
                          transaction.narration,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 14.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack1000),
                        ),
                      ),
                      Text(
                          transaction.trandate==null?"No Date Available":
                          dateTimeFormatterMDY(transaction.trandate!.toIso8601String()),
                        style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 44.h,
            width: 130.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(
                      symbol: 'NGN', decimalDigits: 0)
                      .format(transactionType=="debit"?
                  getAmount(transaction.debit==null?"0":transaction.debit.toString())
                      :
                  getAmount(transaction.credit==null?"0":transaction.credit.toString())
                  ),
                  maxLines: 2,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                      .copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColor.ucpBlack1000),
                ),
                Gap(8.w),
                Icon(Icons.arrow_forward_ios,
                  color: AppColor.ucpBlack920,
                  size: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  double getAmount(String? amount){
    if(amount==null){
      print("i am");
      return 0.0;
    }else{
      if(amount.contains("-")){
        return double.parse(amount.replaceAll("-", "").trim());
      }else{
        return double.parse(amount.trim());
      }
    }

  }
}
