import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/view/mainUi/mainScreen/home/homeWidgets.dart';

import '../../../../data/model/response/memberTransactionHistory.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';

class Hometransactionhistory extends StatelessWidget {
  List<MemberTransactionReport> transactionList ;
   Hometransactionhistory({super.key, required this.transactionList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ucpWhite10,
      body:SafeArea(child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20.w),
              Center(
                  child: Text(
                    "All Member Transaction History",
                    style: CustomTextStyle.kTxtBold.copyWith(
                        color: AppColor.ucpBlack500, fontSize: 18.sp),
                  )),
              IconButton(onPressed: (){
                Get.back();
              },
                  icon:  Icon(Icons.close,
                      color: AppColor.ucpBlack500)),
            ],
          ),
          Gap(20.h),
          transactionList.isEmpty?
          Center(
            child: Text(UcpStrings.emptyTransactionTxt,
                style: CreatoDisplayCustomTextStyle.
                kTxtMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: AppColor.ucpBlack500
                )),
          ):
          SizedBox(
            height: 600.h,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal:16.w),
              children: transactionList
                  .mapIndexed(
                      (element, index) => Padding(
                    padding: EdgeInsets.only(
                        bottom: 14.h),
                    child: HomeTransactWidget(
                      transaction: element,
                      transactionType: element.debitacct==0?"credit":"debit",
                    ),
                  ))
                  .toList(),
            ),
          ),
        ],
      ))

    );
  }
}
