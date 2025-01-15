import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../data/model/response/purchasedItemSummartResponse.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';

class ItemRequestShopWidget extends StatefulWidget {
  PurchasedSummary purchasedSummary;
   ItemRequestShopWidget({super.key, required this.purchasedSummary});

  @override
  State<ItemRequestShopWidget> createState() => _ItemRequestShopWidgetState();
}

class _ItemRequestShopWidgetState extends State<ItemRequestShopWidget> {
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 200.h,
      width: 343.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
      decoration: BoxDecoration(
        color:  AppColor.ucpWhite500,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColor.ucpBlack50),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 24.h,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.purchasedSummary.itemCount.toString()} Products",
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack500),),
                  Icon(Icons.arrow_forward,color: AppColor.ucpBlack500,)
                ]
            ),
          ),
          height14,
          SizedBox(
            height: 24.h,
            child: Row(
              children: [
                Text("Quantity: ",
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack700),),
                Text("${widget.purchasedSummary.quantity.toString()} units",
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500),),
              ],
            ) ,
          ),
          height14,
          SizedBox(
            height: 24.h,
            child: Row(
              children: [
                Text("Total: ",
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack700),),
                Text(NumberFormat.currency(name: "NGN", decimalDigits: 0).format(
                    widget.purchasedSummary.totalPrice.toDouble()),
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500),),
              ],
            ) ,
          ),
          height14,
          SizedBox(
            height: 24.h,
            child: Row(
              children: [
                Text("Date: ",
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack700),),
                Text(DateFormat("dd-MM-yyyy").format(widget.purchasedSummary.purchasedDate),
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500),),
              ],
            ) ,
          ),
          height14,
          SizedBox(
            height: 24.h,
            child: Row(
              children: [
                Text("Status: ",
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack700),),
                Container(
                  height: 24.h,
                  width: 76.w,
                  decoration: BoxDecoration(
                      color: widget.purchasedSummary.status.name.toLowerCase() == "pending"
                          ? AppColor.ucpOrange100
                          : widget.purchasedSummary.status.name.toLowerCase() == "approved"||
                          widget.purchasedSummary.status.name.toLowerCase() == "paid"
                          ? AppColor.ucpSuccess50:AppColor.ucpDanger75,
                      borderRadius: BorderRadius.circular(50.r)
                  ),
                  child: Center(
                    child: Text( widget.purchasedSummary.status.name.toLowerCase() == "paid"?"Approved":"${widget.purchasedSummary.status.name}",
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ucpBlack500),),
                  ),
                )
              ],
            ) ,
          ),
        ],
      ),
    );
  }
}
