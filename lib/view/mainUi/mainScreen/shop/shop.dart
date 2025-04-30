import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/bloc/shop/shop_bloc.dart';
import 'package:ucp/data/model/response/shopList.dart';
import 'package:ucp/data/repository/FinanceRepo.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopFavorites.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopListWidget.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopRequestScreen.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopScreen.dart';

import '../../../../data/model/request/addToCartRequest.dart';
import '../../../../data/model/request/increaseDecreaseCartItemQuantity.dart';
import '../../../../data/model/request/markAsFavorite.dart';
import '../../../../data/model/response/favoriteItemsResponse.dart';
import '../../../../data/model/response/itemsOnCart.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import 'itemsInCart.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isShop = true;
  bool isRequest = false;
  bool isFavorite = false;
  late ShopBloc bloc;
  int? selectedIndex;
  int currentPage = 1;
  int pageSize = 10;
  List<ShopItemList> shopItemsList = [];
  List<ShopItemList> itemsInCart = [];
  List<FavoriteItem> allFavoriteItems = [];
  List<ItemsMarkedAsFavorite> allFavoriteItem2 = [];
  List<ItemsOnCart> allItemInCart = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetShopItemsEvent());

      bloc.add(GetAllItemOnCartEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(state.errorResponse.message, context);
          });
          bloc.initial();
        }
        if (state is ShopItemsLoaded) {
          // Ensuring the widget tree is not rebuilt during the callback
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Extract the shop items list from the state
            shopItemsList = state.shopItemsList;

            // Clear the favorite items list before adding new items to avoid duplicates
            // allFavoriteItem2.clear();
            bloc.add(GetAllFavoriteItemsEvent(PaginationRequest(
                currentPage: currentPage, pageSize: pageSize)));


          });

          // Reinitializing the bloc after processing the items
          bloc.initial();
        }

        if (state is ShopItemAddedToCart) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
        bloc.add(GetAllItemOnCartEvent());
          });
          // bloc.initial();
        }
        if (state is ShopAllFavoriteItemsLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            allFavoriteItem2.clear();
            allFavoriteItems = state.allFavoriteItems.modelResult;
            String id = "";
            if (allFavoriteItems.isNotEmpty) {
              for (var element in shopItemsList) {
                bool isFavorite = allFavoriteItems.any(
                      (item) {
                    if( double.parse(element.itemCode) ==
                        double.parse(item.itemCode)){
                      id = item.id.toString();
                      return true;
                    }else{
                      return false;
                    }
                  },
                );

                allFavoriteItem2.add(
                  ItemsMarkedAsFavorite(
                    id: id,
                    imageUrl: element.itemImage,
                    itemCode: element.itemCode,
                    itemName: element.itemName,
                    itemPrice: element.itemPrice,
                    quantity: element.quantity ?? 0,
                    isFavourite: isFavorite,
                  ),
                );
              }
            }
            else {
              allFavoriteItem2.addAll(
                shopItemsList.map(
                      (element) => ItemsMarkedAsFavorite(
                    id: "",
                    itemCode: element.itemCode,
                    itemName: element.itemName,
                    itemPrice: element.itemPrice,
                    imageUrl: element.itemImage,
                    quantity: element.quantity ?? 0,
                    isFavourite: false,
                  ),
                ),
              );
            }

          });
          bloc.initial();
        }
        if (state is ShopAllItemsInCartLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            allItemInCart = state.shopItemsList;
            tempItemInCart= state.shopItemsList;
          });
          bloc.initial();
        }
        if (state is ShopItemMarkedAsFavorite) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            bloc.add(GetAllFavoriteItemsEvent(PaginationRequest(
                currentPage: currentPage, pageSize: pageSize)));
          });
          bloc.initial();
        }
        if (state is ShopItemUnMarkedAsFavorite) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            bloc.add(GetAllFavoriteItemsEvent(PaginationRequest(
                currentPage: currentPage, pageSize: pageSize)));
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
              backgroundColor: AppColor.ucpWhite10,
              body: Stack(
                children: [
                  displayScreen(state),
                  UCPCustomAppBar(
                      height: MediaQuery.of(context).size.height*0.23,
                      appBarColor: AppColor.ucpWhite10,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Gap(20.h),
                            Text(
                              UcpStrings.shoppingTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                            height14,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40.h,
                                  width: 248.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    color: AppColor.ucpBlue25,
                                    borderRadius: BorderRadius.circular(40.r),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isShop = true;
                                            isRequest = false;
                                            isFavorite = false;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          height: 32.h,
                                          width: 57.w,
                                          decoration: BoxDecoration(
                                            color: isShop
                                                ? AppColor.ucpBlue600
                                                : Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(40.r),
                                          ),
                                          duration:
                                          const Duration(milliseconds: 500),
                                          child: Center(
                                            child: Text(
                                              UcpStrings.shopTxt,
                                              style: CreatoDisplayCustomTextStyle
                                                  .kTxtMedium
                                                  .copyWith(
                                                fontSize: 14.sp,
                                                color: isShop
                                                    ? AppColor.ucpWhite500
                                                    : AppColor.ucpBlack800,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isShop = false;
                                            isRequest = true;
                                            isFavorite = false;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                          const Duration(milliseconds: 400),
                                          height: 32.h,
                                          width: 84.w,
                                          decoration: BoxDecoration(
                                            color: isRequest
                                                ? AppColor.ucpBlue600
                                                : Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(40.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              UcpStrings.requestTxt,
                                              style: CreatoDisplayCustomTextStyle
                                                  .kTxtMedium
                                                  .copyWith(
                                                fontSize: 14.sp,
                                                color: isRequest
                                                    ? AppColor.ucpWhite500
                                                    : AppColor.ucpBlack800,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isShop = false;
                                            isRequest = false;
                                            isFavorite = true;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                          const Duration(milliseconds: 500),
                                          height: 32.h,
                                          width: 90.w,
                                          decoration: BoxDecoration(
                                            color: isFavorite
                                                ? AppColor.ucpBlue600
                                                : Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(40.r),
                                          ),
                                          child: Center(
                                            child: Text(
                                              UcpStrings.favouriteTxt,
                                              style: CreatoDisplayCustomTextStyle
                                                  .kTxtMedium
                                                  .copyWith(
                                                fontSize: 14.sp,
                                                color: isFavorite
                                                    ? AppColor.ucpWhite500
                                                    : AppColor.ucpBlack800,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            height12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isShop? UcpStrings.allAvailableItem : isRequest? UcpStrings.allItemRequestTxt : UcpStrings.allFavoriteItemTxt,
                                  style: CreatoDisplayCustomTextStyle.kTxtBold
                                      .copyWith(
                                      fontSize: 14.sp,
                                      letterSpacing: -1,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpBlack500),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                 bool? result=  await Get.to(CartSummary(allItemInCart:tempItemInCart));
                                 if(result!=null){
                                   if(result){
                                     bloc.add(GetShopItemsEvent());
                                     bloc.add(GetAllItemOnCartEvent());
                                   }
                                  }
                                 },
                                  child: Container(
                                    height: 40.h,
                                    width: 40.w,
                                    padding: EdgeInsets.all(6.h),
                                    decoration: const BoxDecoration(
                                        color: AppColor.ucpBlue50,
                                        shape: BoxShape.circle),
                                    child: badges.Badge(
                                      badgeStyle: const badges.BadgeStyle(
                                          badgeColor: AppColor.ucpOrange600),
                                      stackFit: StackFit.expand,
                                      position: badges.BadgePosition.custom(
                                          bottom: 15, start: 10),
                                      badgeContent: Text(
                                        allItemInCart.length.toString(),
                                        style: CreatoDisplayCustomTextStyle
                                            .kTxtMedium
                                            .copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.ucpWhite500),
                                      ),
                                      child: Image.asset(
                                        UcpStrings.ucpShoppingCart,
                                        height: 24.h,
                                        width: 24.w,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              )),
        );
      },
    );
  }

  Widget displayScreen(state) {
    if (isShop) {
      return SingleChildScrollView(
        child: ShopScreenListView(
          bloc: bloc,
          shopItemsList: allFavoriteItem2,
          state: state,
        ),
      );
    } else if (isRequest) {
      return Shoprequestscreen(bloc: bloc,);
    } else {
      return SingleChildScrollView(
        child: ShopFavoriteItemScreen(
          allFavoriteItems: allFavoriteItem2.where((element) => element.isFavourite==true).toList(),
          bloc: bloc,
        ),
      );
    }
  }
}