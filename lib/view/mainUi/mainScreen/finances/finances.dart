import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/retirement/retirementScreen.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/savings/savings.dart';

import '../../../../utils/colorrs.dart';
import '../home/withdraw.dart';
import 'financeWidgets.dart';
import 'loan/loanMainScreen.dart';

class FinancesScreen extends StatefulWidget {
  const FinancesScreen({super.key});

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.ucpWhite10,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 273.h,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  UcpStrings.financeIcon,fit: BoxFit.cover,
                ),
              ) ,
              Positioned(
                top: 100.h,
                left: 15.w,
                child: SizedBox(
                  height: 100.h,
                  width: 237.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(UcpStrings.financeTxt,
                        style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.ucpWhite500
                        ),
                      ),
                      SizedBox(
                        height: 45.h,
                        width: 237.w,
                        child: Text(UcpStrings.financeSTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlue50
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          height16,
          Padding(padding:EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            height: 386.h,
            width: 343.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FinanceOptionDesign(
                      onTap: (){
                        Get.to(const SavingsScreen());
                      },
                      color: AppColor.ucpDanger25,
                      title: UcpStrings.savingTxt,
                      message: UcpStrings.savingMSGTxt,
                      icon: UcpStrings.ucpSavingsImage,
                    ),
                    FinanceOptionDesign(
                      onTap: (){
                        Get.to( Loanmainscreen());
                      },
                      color: AppColor.ucpBlue15,
                      title: UcpStrings.loanMTxt,
                      message: UcpStrings.loanMSGTxt,
                      icon: UcpStrings.ucpLoanImage,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FinanceOptionDesign(
                      onTap: (){
                        Get.to(WithdrawScreen(), curve: Curves.easeIn);
                      },
                      color: AppColor.ucpCSK25,
                      title: UcpStrings.withdrawalsTxt,
                      message: UcpStrings.withdrawalMSGTxt,
                      icon: UcpStrings.ucpWithdrawalImage,
                    ),
                    FinanceOptionDesign(
                      onTap: (){
                        Get.to(RetirementScreen(), curve: Curves.easeIn);
                      },
                      color: AppColor.ucpOrange15,
                      title: UcpStrings.retirementTxt,
                      message: UcpStrings.retirementMSGTxt,
                      icon: UcpStrings.ucpRetirementImage,
                    ),
                  ],
                ),
              ],
            ),
          ),
          )
        ],
      )
    );
  }
}
