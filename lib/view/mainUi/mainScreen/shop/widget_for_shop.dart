import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopFavorites.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopListWidget.dart';

import '../../../../app/customAnimations/animationManager.dart';
import '../../../../bloc/shop/shop_bloc.dart';
import '../../../../data/model/request/increaseDecreaseCartItemQuantity.dart';
import '../../../../data/model/response/itemsOnCart.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import 'itemsInCart.dart';

class ShopListItemDesign extends StatefulWidget {
  Function()? addToFavorite;
  Function()? addToCartAction;
  bool isFavourite;
  ItemsMarkedAsFavorite shopItem;
  int selectedIndex;
  int index;
  ShopState state;
  ShopBloc bloc;
  String? imageUrl;

  ShopListItemDesign(
      {super.key,
      required this.bloc,
      required this.isFavourite,
      required this.selectedIndex,
      required this.index,
      required this.state,
      required this.shopItem,
      this.addToCartAction,
        this.imageUrl,
      this.addToFavorite});

  @override
  State<ShopListItemDesign> createState() => _ShopListItemDesignState();
}

class _ShopListItemDesignState extends State<ShopListItemDesign> {
  // late ShopBloc bloc;

  @override
  Widget build(BuildContext context) {
    //bloc = BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopItemMarkedAsFavorite) {
          WidgetsBinding.instance.addPostFrameCallback((_) {});
          widget.bloc.initial();
        }
        return Container(
          height: 88.h,
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
              Stack(
                children: [
                  Container(
                    height: 88.h,
                    width: 112.h,
                    decoration: BoxDecoration(
                      // color: ,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          bottomLeft: Radius.circular(12
                              .r)), // Rounded cornersoverflow: BoxOverflow.hidden, // Ensures the image fits within the border
                    ),
                    child: ImageContainer(
                      imageUrl:widget.imageUrl?? UcpStrings.basketI,
                      isNetworkImage: widget.imageUrl!=null,
                      height: 88.h,
                      width: 112.h,
                    ),
                  ),
                  Positioned(
                    child: BouncingWidget(
                      duration: Duration(milliseconds: 100),
                      child: GestureDetector(
                        onTap: widget.addToFavorite,
                        child: Container(
                          height: 32.h,
                          width: 32.w,
                          padding: EdgeInsets.all(8.h),
                          decoration: BoxDecoration(
                            color: widget.isFavourite
                                ? AppColor.ucpOrange500
                                : AppColor.ucpOrange25,
                            // color: Colors.red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.r),
                                bottomRight: Radius.circular(12.r)),
                          ),
                          child: widget.isFavourite
                              ? Image.asset(UcpStrings.favouriteI)
                              : Image.asset(UcpStrings.unFavouriteI),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 88.h,
                width: 231.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 207.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.shopItem.itemName,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff000000)),
                            ),
                            Text(
                              NumberFormat.currency(
                                      symbol: 'NGN', decimalDigits: 0)
                                  .format(widget.shopItem.itemPrice),
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
                        height: 30.h,
                        width: 217.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 20.h,
                              width: 100.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    UcpStrings.inventoryCartIcon,
                                    height: 15.h,
                                    width: 15.w,
                                  ),
                                  // Gap(10.w),
                                  SizedBox(
                                    child: Text(
                                      "${widget.shopItem.quantity} in stock",
                                      maxLines: 2,
                                      style: CreatoDisplayCustomTextStyle
                                          .kTxtRegular
                                          .copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff000000)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Image.asset(UcpStrings.addToCartIcon),
                            displayWidget(state,shopItem: widget.shopItem)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget displayWidget(state,{ItemsMarkedAsFavorite? shopItem}) {
    bool isfound=false;
    int quantity = 0;
    int itemIndex = 0;
    for(int i=0;i<tempItemInCart.length;i++){
      if(tempItemInCart[i].itemcode==shopItem?.itemCode){
        isfound=true;
        quantity=tempItemInCart[i].quantity;
        itemIndex=i;
        break;
      }
    }
    if(isfound){
      return ShopIncreaseDecreaseQuantity(
        state: state,
        selectedIndex: widget.selectedIndex,
        index: itemIndex,
        itemQuantity: quantity,
        itemCode: widget.shopItem.itemCode,
        bloc: widget.bloc,
      );
    }else if (state is ShopIsAddingToCartLoading &&
        widget.selectedIndex == widget.index) {
      return AddingItemToCartLoading();
    }
   else if ((state is ShopItemAddedToCart&& widget.selectedIndex==widget.index) ||
        (state is ShopItemQuantityDecreased&& widget.selectedIndex==widget.index) ||
        ( state is ShopItemQuantityIncreased&& widget.selectedIndex==widget.index)) {
     print("this is the id ${widget.shopItem.id}");
      return ShopIncreaseDecreaseQuantity(
        state: state,
        selectedIndex: widget.selectedIndex,
        index: widget.index,
        itemQuantity: widget.shopItem.quantity,
        itemCode: widget.shopItem.itemCode,
        bloc: widget.bloc,
      );
    }
    else if (state is ShopInitial) {
      return GestureDetector(
          onTap: widget.addToCartAction,
          child: Image.asset(UcpStrings.addToCartIcon));
    }else {
      return GestureDetector(
          onTap: widget.addToCartAction,
          child: Image.asset(UcpStrings.addToCartIcon));
    }
  }
}

class ShopIncreaseDecreaseQuantity extends StatefulWidget {
  String? itemCode;
  ShopState state;
  ShopBloc bloc;
  int? itemQuantity;
  int selectedIndex;
  int index;

  ShopIncreaseDecreaseQuantity(
      {super.key,
      required this.itemCode,
      required this.state,
      required this.bloc,
      required this.itemQuantity,
      required this.selectedIndex,
      required this.index});

  @override
  State<ShopIncreaseDecreaseQuantity> createState() =>
      _ShopIncreaseDecreaseQuantityState();
}

class _ShopIncreaseDecreaseQuantityState
    extends State<ShopIncreaseDecreaseQuantity> {
  int quantity = 0;
  int quantityHolder = 0;
  int? selectedIndex;
  late ShopBloc bloc;
  List<ItemsOnCart> allItemInCart = [];

  @override
  void initState() {
   quantity = widget.itemQuantity ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(
                "${state.errorResponse.message} ${state.errorResponse.data}",
                context);
            quantity = quantityHolder;
          });
         // bloc.initial();
        }
        if (state is ShopItemQuantityDecreased) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            quantityHolder = quantity;
            selectedIndex = null;
            tempItemInCart[widget.index].quantity = quantity;
            subTotal = 0;
            for (var element in tempItemInCart) {
              subTotal = subTotal + (element.quantity * element.sellprice);
            }
            setState(() {
              tempItemInCart=tempItemInCart;
            });
          });
         // bloc.initial();
        }
        if (state is ShopAllItemsInCartLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // allItemInCart = state.shopItemsList;
            // setState(() {
            //
            // })setState;
          });
          bloc.initial();
        }
        if (state is ShopItemQuantityIncreased) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            quantityHolder = quantity;
            selectedIndex = null;
            tempItemInCart[widget.index].quantity = quantity;
            subTotal = 0;
            for (var element in tempItemInCart) {
              subTotal = subTotal + (element.quantity * element.sellprice);
            }
            setState(() {
              tempItemInCart=tempItemInCart;
            });
          });
         // bloc.initial();
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
                          print("this is the index ${widget.index}");
                          setState(() {
                            selectedIndex = widget.index;
                          });
                          if (quantity == 0) {
                            bloc.add(RemoveReduceItemQuantityFromCartEvent(
                                AddReduceItemQuantityOnCartRequest(
                                    itemCode: int.parse(widget.itemCode??"0"), quantity: 1)));
                          } else {
                            bloc.add(RemoveReduceItemQuantityFromCartEvent(
                                AddReduceItemQuantityOnCartRequest(
                                    itemCode:int.parse(widget.itemCode??"0"), quantity: 1)));
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
                                  itemCode:int.parse(widget.itemCode??"0"), quantity: 1)));
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
                  visible: state
                          is ShopIsIncreasingDecreasingItemQuantityOnCartLoading &&
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
