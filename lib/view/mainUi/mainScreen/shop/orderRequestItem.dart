import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopListWidget.dart';

import '../../../../bloc/shop/shop_bloc.dart';
import '../../../../data/model/response/itemsInPurchaseSummary.dart';
import '../../../../data/repository/FinanceRepo.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
double oSubTotal=0;
class OrderRequestBreakdownScreen extends StatefulWidget {
  ShopBloc bloc;
  String orderId;
  String orderStatus;
   OrderRequestBreakdownScreen({super.key,required this.orderStatus,required this.bloc,required this.orderId});

  @override
  State<OrderRequestBreakdownScreen> createState() => _OrderRequestBreakdownScreenState();
}

class _OrderRequestBreakdownScreenState extends State<OrderRequestBreakdownScreen> {
  late ShopBloc bloc;
  int? selectedIndex;
  int currentPage = 1;
  int pageSize = 10;
  int totalPageSize = 0;
  bool hasMore = true;
  List<ItemInSummary> allItemsInOrder = [];
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
   print("I am here,${widget.orderId}");
    bloc = widget.bloc;
    WidgetsBinding.instance.addPostFrameCallback((_) {
        bloc.add(GetAllItemInPurchasedSummaryEvent(
            PaginationRequest(
                pageSize: pageSize,
                currentPage: currentPage, 
                addOns: widget.orderId
            )));

    });
    super.initState();
  } 
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
  builder: (context, state) {
    if (state is ShopError) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        AppUtils.showSnack(state.errorResponse.message, context);
      });
      bloc.initial();
    }
    if(state is ShopPurchasedItemRequestItemsLoaded){
      WidgetsBinding.instance.addPostFrameCallback((_){
        totalPageSize= state.purchasedItemsSummary.totalCount;
        oSubTotal=0;
        for (var element in state.purchasedItemsSummary.modelResult) {
          allItemsInOrder.add(element);

        }
        for (var element in allItemsInOrder) {
          oSubTotal = oSubTotal+(element.quantity*element.unitPrice);
        }
        setState(() {
          oSubTotal=oSubTotal;
        });
      });
      bloc.initial();
    }
    return UCPLoadingScreen(
      visible: state is ShopIsLoading,
      loaderWidget: LoadingAnimationWidget.discreteCircle(
        color: AppColor.ucpBlue500,
        size: 40.h,
        secondRingColor: AppColor.ucpBlue100,
      ),
      overlayColor: AppColor.ucpBlack400,
      transparency: 0.2,
      child: Scaffold(
        backgroundColor:AppColor.ucpWhite10,
        extendBodyBehindAppBar: true,
        bottomSheet: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
                height: 153.h,
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.ucpBlue50.withOpacity(0.15),     //Color( 0xffEDF4FF),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      onTap: () {
            
                      },
                      borderRadius: 30.r,
                      buttonColor: widget.orderStatus.toLowerCase() == "pending"
                          ? AppColor.ucpOrange100
                          :widget.orderStatus.toLowerCase() == "approved"||
                          widget.orderStatus.toLowerCase() == "paid"
                          ? AppColor.ucpSuccess50:AppColor.ucpDanger50,
                      buttonText: UcpStrings.doneTxt,
                      height: 51.h,
                      textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: AppColor.ucpWhite500,
                      ),
                      textColor: AppColor.ucpWhite500,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              UcpStrings.orderStatus,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500
                              ),
                            ),
                            Container(
                              height: 25.h,
                              width: 73.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: widget.orderStatus.toLowerCase() == "pending"
                                    ? AppColor.ucpOrange500
                                    : widget.orderStatus.toLowerCase() == "approved"||
                                    widget.orderStatus.toLowerCase() == "paid"
                                    ? AppColor.ucpSuccess100:AppColor.ucpDanger150
                              ),
                              child: Center(
                                child: Text(widget.orderStatus,
                                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpWhite500
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    height12,
                    CustomButton(
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
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              UcpStrings.totalAmount,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpWhite500
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                  symbol: "NGN",
                                  decimalDigits: 0
                              ).format(oSubTotal),
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpWhite500
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
        body: Stack(
          // fit: StackFit.passthrough,
          children: [
            // Positioned(
            //   top:50.h,
            //   child: ,
            // ),
            Padding(
              padding:EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView(
               // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(120.h),
                  SizedBox(
                    height: 90.h * allItemsInOrder.length,
                    child: Column(
                      // padding: EdgeInsets.zero,
                      children: allItemsInOrder.mapIndexed((element,index)=>
                          Padding(
                            padding:  EdgeInsets.only(bottom: 8.h),
                            child: GestureDetector(
                              onTap: (){setState(() {
                                selectedIndex=index;
                              });},
                              child: OrderItemsB(
                                element: element,
                                isImageUrl: false,
                               // state: state,
                              ),
                            ),
                          )
                      ).toList(),
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
                      height: 50.h * allItemsInOrder.length,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColor.ucpWhite500
                      ),
                      child:Column(children: allItemsInOrder.mapIndexed((element,index)=>
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
                                  Text(NumberFormat.currency(name: "NGN",decimalDigits: 0).format(
                                      element.unitPrice*element.quantity),
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
                                Text(NumberFormat.currency(name: "NGN",decimalDigits: 0).format(oSubTotal),
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
                                Text(NumberFormat.currency(name: "NGN",decimalDigits: 0).format(oSubTotal),
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
                        Text(UcpStrings.orderRequestBreakDown,
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
      ),
    );
  },
);
  }
}


class OrderItemsB extends StatelessWidget {
  ItemInSummary element;
  bool isImageUrl;
  String? image;
   OrderItemsB({super.key, required this.element, this.image,required this.isImageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
       width: 343.w,
      decoration: BoxDecoration(
        color: AppColor.ucpWhite500,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColor.ucpBlack50,
        ),
      ),
      child: Row(
        children: [
          Container(

              width: 90.w,
            // padding: EdgeInsets.only(top: 3.h, bottom: 5.h,left: 3.w),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: isImageUrl?NetworkImage(image??""):AssetImage(  UcpStrings.basketI,),
                  fit: BoxFit.cover, // Ensures the image fits the container
                ),
                border: Border.all(color: AppColor.ucpBlack50),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r)),
              ),
          ),
          Gap(5.w),
          SizedBox(
            height: 70.h,
            // width:25.w,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                   // color: Colors.blue,
                    width: 130.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         element.itemName,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)),
                        ),
                        Text("${element.quantity} units",
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100.w,

                    child: Text(
                      textAlign: TextAlign.end,
                      NumberFormat.currency(
                          symbol: 'NGN', decimalDigits: 0)
                          .format(element.unitPrice),
                      style: CreatoDisplayCustomTextStyle.kTxtMedium
                          .copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff000000)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
