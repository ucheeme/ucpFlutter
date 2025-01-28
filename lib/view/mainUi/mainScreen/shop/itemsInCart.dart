import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:ucp/bloc/shop/shop_bloc.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopListWidget.dart';

import '../../../../data/model/response/itemsOnCart.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../errorPages/noNotification.dart';
List<ItemsOnCart>tempItemInCart=[];
double subTotal=0;
class CartSummary extends StatefulWidget {
  List<ItemsOnCart> allItemInCart;
   CartSummary({super.key,required this.allItemInCart});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  List<ItemsOnCart> allItemInCart=[];
 // double subTotal=0;
  int? selectedIndex;
  late ShopBloc bloc;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subTotal=0;
      allItemInCart=widget.allItemInCart;
      print("This is ${allItemInCart.length}");
      // tempItemInCart.clear();
      for (var element in allItemInCart) {
        subTotal = subTotal+(element.quantity*element.sellprice);
      }
      setState(() {
        subTotal=subTotal;
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc=BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ShopBloc, ShopState>(
  builder: (context, state) {
    if (state is ShopAllItemsInCartLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        allItemInCart.clear();
        allItemInCart = state.shopItemsList;
        tempItemInCart=state.shopItemsList;
        // for (var element in allItemInCart) {
        //   subTotal = subTotal+(element.quantity*element.sellprice);
        // }
        setState(() {
          subTotal=subTotal;
        });
      });
      bloc.initial();
    }
    return Scaffold(
      backgroundColor:AppColor.ucpWhite10,
      extendBodyBehindAppBar: true,
      bottomSheet: Container(
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
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    NumberFormat.currency(
                      symbol: "NGN",
                      decimalDigits: 0
                    ).format(subTotal),
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpWhite500
                    ),
                  ),
                  SizedBox(
                    width: 50.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          UcpStrings.payTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpWhite500
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top: 4.h),
                          child: Icon(Icons.arrow_forward,color: AppColor.ucpWhite500,size: 15,),
                        )
                      ],
                    ),
                  )


                ],
              ),
            ),
            onTap: () {

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
      body: Stack(
        children: [
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(120.h),
                  allItemInCart.isEmpty?
                  EmptyNotificationsScreen(emptyHeader: UcpStrings.emptyCartTxt,emptyMessage: UcpStrings.emptyMessageTxt,press: () { bloc.add(GetAllItemOnCartEvent()); },):
                  SizedBox(
                    height: 90.h * allItemInCart.length,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        // padding: EdgeInsets.zero,
                        children: allItemInCart.mapIndexed((element,index)=>
                            Padding(
                              padding:  EdgeInsets.only(bottom: 8.h),
                              child: GestureDetector(
                                onTap: (){setState(() {
                                  selectedIndex=index;
                                });},
                                child: CartSummaryListDesign(
                                  index: index,
                                  bloc: bloc,
                                  // isOrderRequest: true,
                                  amount: double.parse(element.sellprice.toString()),
                                  selectedIndex: selectedIndex??0,
                                  element: element,state: state,),
                              ),
                            )
                        ).toList(),
                      ),
                    ),
                  ),
                  height30,
                  Text(UcpStrings.orderSummary,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: AppColor.ucpBlack500
                  ),),
                  Gap(12.h),
                  Container(
                    height: 50.h * allItemInCart.length,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColor.ucpWhite500
                    ),
                    child:Column(children: allItemInCart.mapIndexed((element,index)=>
                    SizedBox(
                      height: 40.h,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(element.itemName.isEmpty?"Unknown":element.itemName,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500
                              ),
                            ),
                            Text("${element.quantity} units",
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500
                              ),
                            ),
                            Text(NumberFormat.currency(name: "NGN",decimalDigits: 0).format(element.sellprice),
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    ).toList(),)
                  ),
                  height12,
                  Container(
                    height: 72.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColor.ucpBlue50
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 14.w,vertical: 12.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 20.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(UcpStrings.subTotalTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500
                                ),
                                ),
                                Text(NumberFormat.currency(name: "NGN",decimalDigits: 0).format(subTotal),
                                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpBlack500
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(UcpStrings.estimatedTotalTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500
                                ),
                                ),
                                Text(NumberFormat.currency(name: "NGN",decimalDigits: 0).format(subTotal),
                                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpBlack500
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  height120,
                ],
              ),
            ),
          ),
          UCPCustomAppBar(
              height: 93.h,
              appBarColor: AppColor.ucpWhite10.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   height30,
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: SizedBox(
                          height: 24.h,
                          width: 24.w,
                          child: ColoredBox(
                            color: Colors.transparent,
                            child: Image.asset(
                              UcpStrings.ucpBackArrow,
                              height: 24.h,
                              width: 24.w,
                            ),
                          ),
                        ),
                      ),
                      Gap(12.w),
                      Text(UcpStrings.cartSummary,
                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                            .copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500),
                      )
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  },
);
  }
}
