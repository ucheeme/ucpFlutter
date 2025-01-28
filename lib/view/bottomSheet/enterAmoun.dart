import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/view/bottomSheet/memberSavingAccounts.dart';

import '../../utils/appStrings.dart';
import '../../utils/colorrs.dart';
import '../../utils/designUtils/reusableFunctions.dart';
import '../../utils/designUtils/reusableWidgets.dart';
import 'cooperatives.dart';
class EnterAmountBottomSheet extends StatefulWidget {
  const EnterAmountBottomSheet({super.key});

  @override
  State<EnterAmountBottomSheet> createState() => _EnterAmountBottomSheetState();
}

class _EnterAmountBottomSheetState extends State<EnterAmountBottomSheet> {
TextEditingController amountController = TextEditingController();
  bool isTouched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet:  Container(
          height: 83.h,
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.ucpBlue50,     //Color( 0xffEDF4FF),
            // borderRadius: BorderRadius.only(
            //   bottomRight: Radius.circular(15.r),
            //   bottomLeft: Radius.circular(15.r),
            // ),
          ),
          child: CustomButton(
            onTap: () {
              saveToAccountRequest?.amount = amountController.text.replaceAll(",", "");
              Get.back();
              _showUserAccountModal();
            },
            borderRadius: 30.r,
            buttonColor: AppColor.ucpBlue500,
            buttonText: UcpStrings.doneTxt,
            height: 51.h,
            textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: AppColor.ucpWhite500,
            ),
            textColor: AppColor.ucpWhite500,
          )
      ),
        body: Container(
            height: 300.h,
            decoration: BoxDecoration(
              color: AppColor.ucpWhite500,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Gap(20.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.w),
                child: Text("Enter Amount",
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack700,
                    )),
              ),
              Gap(15.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15.w),
                child: CustomizedTextField(
                  textEditingController:amountController,
                  inputFormat: [ThousandSeparatorFormatter(),],
                  hintTxt: UcpStrings.enterAmount,
                  keyboardType: TextInputType.number,
                  validator: (value) {},
                  isConfirmPasswordMatch: false,
                  isTouched: isTouched,
                  onTap: (){
                    setState(() {
                      isTouched = true;
                    });
                  },
                ),
              ),

            ])));
  }

  Future<void> _showUserAccountModal() async {
    await showCupertinoModalBottomSheet(
      topRadius: Radius.circular(15.r),
      backgroundColor: AppColor.ucpWhite500,
      context: context,
      builder: (context) {
        return Container(
          height: 485.h,
          color: AppColor.ucpWhite500,
          child:MemberSavingAccountsBottomSheets(),
        );
      },
    );
  }
}
