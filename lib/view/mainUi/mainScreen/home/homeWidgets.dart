import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:ucp/data/model/response/memberTransactionHistory.dart';
import 'package:ucp/data/model/response/userAcctResponse.dart';
import 'package:ucp/utils/appStrings.dart';

import '../../../../data/model/response/transactionHistoryResponse.dart';
import '../../../../data/model/response/withdrawTransactionHistory.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';

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
                            transaction.narration.contains("-")?"${getInitials(transaction.narration.split("-")[0])} ${transaction.narration.split("-")[1]}":
                            transaction.narration,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 13.sp,
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
                      fontSize: 13.sp,
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

class HomeTransactWidget extends StatelessWidget {
  MemberTransactionReport transaction;
  String transactionType;
  HomeTransactWidget({super.key,required this.transaction,required this.transactionType});

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
                          transaction.narration.contains("-")?"${getInitials(transaction.narration.split("-")[0])} ${transaction.narration.split("-")[1]}":
                          transaction.narration,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 13.sp,
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
                  getAmount(transaction.debitacct==null?"0":transaction.debitacct.toString())
                      :
                  getAmount(transaction.creditAcct==null?"0":transaction.creditAcct.toString())
                  ),
                  maxLines: 2,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                      .copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
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

class HistoryFilter extends StatefulWidget {
 final List<UserAccounts> userAccounts;
  const HistoryFilter({super.key, required this.userAccounts});

  @override
  State<HistoryFilter> createState() => _HistoryFilterState();
}

class _HistoryFilterState extends State<HistoryFilter> {
  int selectedIndex =0;
  int selectedIndex2 =0;
  TransactionFilter? currentValue;
  List<int> durations =[3,6,12,24,36,48,60];
  UserAccounts? selectedObject;
  int? selectedObject2;
  @override
  void initState() {
   currentValue = TransactionFilter(durations[0].toString(),
       UserAccounts( accountNumber: widget.userAccounts[0].accountNumber,
           accountProduct: widget.userAccounts[0].accountProduct)
   );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.ucpWhite10,
      body:  Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),
              Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.close, size: 30.h,color: AppColor.ucpBlack500,)),
                  Gap(20.w),
                  Text(UcpStrings.transactionHistoryFilter,
                      style: CreatoDisplayCustomTextStyle.kTxtMedium
                          .copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ucpBlack500)),
                ],
              ),
              Gap(40.h),
              Text(UcpStrings.userDifferentAccts,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                      .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500)),
              Gap(22.sp),
              (widget.userAccounts.isEmpty)?
              Center(
                child: Text(UcpStrings.ucpLogo,),
              ):
              Column(
                children: widget.userAccounts.map((item) {
                  return Container(
                    height: 60.h,
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    child: RadioListTile<UserAccounts>(
                      title: Text(item.accountProduct.replaceAll("--", " - "),
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack500)),
                      value: item,
                      groupValue: selectedObject,
                      onChanged: (UserAccounts? value) {
                        setState(() {
                          selectedObject = value;
                        });
                        currentValue!.acctNumber=value!;
                      },
                    ),
                  );
                }).toList(),
              ),
              height20,
              Text(UcpStrings.selectMonth,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                      .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500)),
              Gap(12.sp),
              Column(
                children: durations.map((item) {
                  return Container(
                    height: 60.h,
                    child: RadioListTile<int>(
                      title: Text("${item.toString()} months",
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack500)),
                      value: item,
                      groupValue: selectedObject2,
                      onChanged: (int? value) {
                        setState(() {
                          selectedObject2 = value;
                        });
                        currentValue!.durations=value.toString();
                      },
                    ),
                  );
                }).toList(),
              ),
              Gap(30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(onTap: () {
                    Get.back();
                  },
                    height: 51.h,
                    width: 163.5.w,
                    buttonText: UcpStrings.goBackTxt,
                    borderRadius: 60.r,
                    buttonColor: AppColor.ucpBlue50,
                    textColor: AppColor.ucpBlack500,
                  ),
                CustomButton(onTap: () {
          Get.back(result: currentValue);
                },
          height: 51.h,
          width: 163.5.w,
          buttonText: UcpStrings.doneTxt,
          borderRadius: 60.r,
          buttonColor: AppColor.ucpBlue500,
          textColor: AppColor.ucpWhite500,
                )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WithdrawalTransactionWidgets extends StatelessWidget {
  WithdrawTransactionHistory transaction;
  WithdrawalTransactionWidgets({super.key,
    required this.transaction,});

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
                Image.asset(UcpStrings.ucpDebitImage,height: 32.h,width: 32.w,),
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
                          "${transaction.accountName} ${UcpStrings.withdrawalsTxt}",
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 13.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack1000),
                        ),
                      ),
                      Text(
                        transaction.date==null?"No Date Available":
                        dateTimeFormatterMDY(transaction.date!.toIso8601String()),
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
                      .format(
                  getAmount(transaction.accountBalance==null?"0":transaction.accountBalance.toString())
                  ),
                  maxLines: 2,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                      .copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
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
class TransactionFilter {
  UserAccounts acctNumber;
  String durations;
  TransactionFilter(this.durations,this.acctNumber);
}


class CustomRadioList extends StatefulWidget {
  final List<UserAccounts> userAccounts;
  final Function(UserAccounts) onSelected;

   CustomRadioList({Key? key, required this.userAccounts, required this.onSelected}) : super(key: key);

  @override
  _CustomRadioListState createState() => _CustomRadioListState();
}

class _CustomRadioListState extends State<CustomRadioList> {
  UserAccounts? selectedObject;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.userAccounts.map((item) {
        return Container(
          height: 60.h,
          padding: EdgeInsets.symmetric(vertical: 10.w),
          child: RadioListTile<UserAccounts>(
            title: Text(item.accountProduct.replaceAll("--", " - "),
                style: CreatoDisplayCustomTextStyle.kTxtMedium
                    .copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.ucpBlack500)),
            value: item,
            groupValue: selectedObject,
            onChanged: (UserAccounts? value) {
              setState(() {
                selectedObject = value;
              });
              widget.onSelected(value!);
            },
          ),
        );
      }).toList(),
    );
  }
}

class CustomRadioButtonDate extends StatefulWidget {
  final List<int> userAccounts;
  final Function(int) onSelected;
   CustomRadioButtonDate({super.key, required this.userAccounts, required this.onSelected});

  @override
  State<CustomRadioButtonDate> createState() => _CustomRadioButtonDateState();
}

class _CustomRadioButtonDateState extends State<CustomRadioButtonDate> {
  int? selectedObject;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.userAccounts.map((item) {
        return Container(
          height: 60.h,
          child: RadioListTile<int>(
            title: Text("${item.toString()} months",
                style: CreatoDisplayCustomTextStyle.kTxtMedium
                    .copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.ucpBlack500)),
            value: item,
            groupValue: selectedObject,
            onChanged: (int? value) {
              setState(() {
                selectedObject = value;
              });
              widget.onSelected(value!);
            },
          ),
        );
      }).toList(),
    );
  }
}
