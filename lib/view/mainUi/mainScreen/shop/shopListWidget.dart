import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ucp/bloc/shop/shop_bloc.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/itemsInCart.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopFavorites.dart';

import '../../../../app/customAnimations/animationManager.dart';
import '../../../../data/model/request/addToCartRequest.dart';
import '../../../../data/model/request/increaseDecreaseCartItemQuantity.dart';
import '../../../../data/model/request/markAsFavorite.dart';
import '../../../../data/model/response/itemsOnCart.dart';
import '../../../../data/model/response/shopList.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';

class AddingItemToCartLoading extends StatelessWidget {
  const AddingItemToCartLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 74.w,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
          color: AppColor.ucpLightBlue600,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: AppColor.ucpLightBlue100,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            UcpStrings.inCartTxt,
            style: CreatoDisplayCustomTextStyle.kTxtRegular
                .copyWith(color: AppColor.ucpWhite500, fontSize: 12.sp),
          ),
          Image.asset(
            UcpStrings.loadingCartIcon,
            height: 12.52.h,
            width: 12.87.w,
          )
        ],
      ),
    );
  }
}

class CartItemIncreaseDecreaseDesign extends StatefulWidget {
  String? itemCode;
  ShopState state;
  ShopBloc bloc;
  int? itemQuantity;
  int selectedIndex;
  int index;
  CartItemIncreaseDecreaseDesign(
  {super.key,
  required this.index,required this.selectedIndex,
  required this.bloc,required,
  this.itemCode,this.itemQuantity, required this.state});

@override
State<CartItemIncreaseDecreaseDesign> createState() =>
    _CartItemIncreaseDecreaseDesignState();
}

class _CartItemIncreaseDecreaseDesignState
    extends State<CartItemIncreaseDecreaseDesign> {
  int quantity = 0;
  int quantityHolder = 0;
  int? selectedIndex;
  late ShopBloc bloc;
  List<ItemsOnCart> allItemInCart=[];
  @override
  void initState() {
    quantity = widget.itemQuantity ?? 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc= BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(
                "${state.errorResponse.message} ${state.errorResponse.data}",
                context);
            quantity = quantityHolder;
          });
          bloc.initial();
        }
        if (state is ShopItemQuantityDecreased) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            quantityHolder = quantity;
            selectedIndex=null;
            tempItemInCart[widget.index].quantity=quantity;
            subTotal=0;
            for (var element in tempItemInCart) {
              subTotal = subTotal+(element.quantity*element.sellprice);
            }
            if(quantityHolder==0){
              tempItemInCart.removeAt(widget.index);
            }
            // bloc.add(GetAllItemOnCartEvent());
          });
          bloc.initial();
        }
        if (state is ShopAllItemsInCartLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            allItemInCart = state.shopItemsList;
            tempItemInCart=allItemInCart;
            // setState(() {
            //
            // })setState;
          });
          bloc.initial();
        }
        if (state is ShopItemQuantityIncreased) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            quantityHolder = quantity;
            selectedIndex=null;
            tempItemInCart[widget.index].quantity=quantity;
            subTotal=0;
            for (var element in tempItemInCart) {
              subTotal = subTotal+(element.quantity*element.sellprice);
            }
            // bloc.add(GetAllItemOnCartEvent());
          });
          bloc.initial();
        }
        return Stack(
          children: [
            SizedBox(
                height: 30.h,
                width: 93.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {

                          setState(() {
                            selectedIndex = widget.index;
                          });
                          if (quantity == 0) {
                            bloc.add(RemoveReduceItemQuantityFromCartEvent(
                                AddReduceItemQuantityOnCartRequest(
                                    itemCode:int.parse(widget.itemCode??"0"), quantity: 1)
                            )
                            );
                          } else {
                            bloc.add(RemoveReduceItemQuantityFromCartEvent(
                                AddReduceItemQuantityOnCartRequest(
                                    itemCode: int.parse(widget.itemCode??"0"), quantity: 1)
                            ));
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        child: Image.asset(quantity == 0
                            ? UcpStrings.removeItemFromCart
                            : UcpStrings.reduceInventoryIcon)),
                    Text(quantity.toString(),
                        style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500)),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = widget.index;
                          });
                          bloc.add(IncreaseItemQuantityOnCartEvent(
                              AddReduceItemQuantityOnCartRequest(
                                  itemCode: int.parse(widget.itemCode??"0"), quantity: 1)));
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Image.asset(UcpStrings.increaseInventoryIcon)),
                  ],
                )),
            Positioned(
              bottom: 0.h,
              top: 0.h,
              child: Shimmer.fromColors(
                baseColor: AppColor.ucpBlue25,
                highlightColor: AppColor.ucpOrange500.withOpacity(0.5),
                enabled: true,
                child: Visibility(
                  visible:
                  state is ShopIsIncreasingDecreasingItemQuantityOnCartLoading &&
                      (selectedIndex == widget.index),
                  child: Container(
                    height: 38.h,
                    width: 93.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: AppColor.ucpBlue25.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}


class CartSummaryListDesign extends StatefulWidget {
  dynamic element;
  ShopState state;
  bool? isOrderRequest;
  ShopBloc bloc;
  int selectedIndex;
  int index;
  double amount;
  CartSummaryListDesign({super.key,
    required this.bloc,
    required this.selectedIndex,
    required this.index,
    this.isOrderRequest,
    required this.amount,
    required this.element,required this.state});

  @override
  State<CartSummaryListDesign> createState() => _CartSummaryListDesignState();
}

class _CartSummaryListDesignState extends State<CartSummaryListDesign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      // width: 330.w,
      padding: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: AppColor.ucpWhite500,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColor.ucpBlack50,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height:70.h,
            width: 90.w,
            decoration: BoxDecoration(
              image: DecorationImage(image:widget.element.itemImage!=null?NetworkImage(
                  widget.element.itemImage
              ):AssetImage(UcpStrings.basketI), fit: BoxFit.cover),
              border: Border.all(color: AppColor.ucpBlack50),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r)),
            ),
          ),
          Gap(3.w),
          SizedBox(
            height: 70.h,
            width:240.w,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.element.itemName,
                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                            .copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff000000)),
                      ),
                      Gap(16.w),
                      Text(
                        NumberFormat.currency(
                            symbol: 'NGN', decimalDigits: 0)
                            .format(widget.amount),
                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                            .copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff000000)),
                      )
                    ],
                  ),
                  Visibility(
                    visible: widget.isOrderRequest==null?true:false,
                    child: CartItemIncreaseDecreaseDesign(
                      state: widget.state,
                      bloc: widget.bloc,
                      selectedIndex: widget.selectedIndex,
                      index: widget.index,
                      itemCode:widget.isOrderRequest==null? widget.element.id.toString():null,
                      itemQuantity: widget.element.quantity,
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



class ItemRequestedGroupDesign extends StatelessWidget {
  const ItemRequestedGroupDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


// class ShopRequestData{
//   List<>
// }