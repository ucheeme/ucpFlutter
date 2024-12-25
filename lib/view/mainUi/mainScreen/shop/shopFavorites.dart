import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopListWidget.dart';

import '../../../../bloc/shop/shop_bloc.dart';
import '../../../../data/model/request/addToCartRequest.dart';
import '../../../../data/model/response/favoriteItemsResponse.dart';
import '../../../../data/model/response/shopList.dart';

class ShopFavoriteItemScreen extends StatefulWidget {
  List<ItemsMarkedAsFavorite> allFavoriteItems=[];
  ShopBloc bloc;
  ShopFavoriteItemScreen({super.key,required this.allFavoriteItems,required this.bloc});

  @override
  State<ShopFavoriteItemScreen> createState() => _ShopFavoriteItemScreenState();
}

class _ShopFavoriteItemScreenState extends State<ShopFavoriteItemScreen> {
  int? selectedIndex;
  List<ItemsMarkedAsFavorite> shopItemsList=[];
  @override
  void initState() {
    shopItemsList=widget.allFavoriteItems;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    widget.bloc= BlocProvider.of<ShopBloc>(context);
    return  BlocBuilder<ShopBloc, ShopState>(
  builder: (context, state) {
    return Column(
      children: [
        Gap(160.h),
        Container(
            height: Get.height.h,
            child:ListView(
              children: shopItemsList.mapIndexed(
                      (element,index)=>Padding(
                    padding:  EdgeInsets.only(left: 14.w,right: 14.w,bottom: 10.h),
                    child: ShopListItemDesign(
                      shopItem: element,
                      bloc: widget.bloc,
                      selectedIndex: selectedIndex??0,
                      index: index,
                      addToFavorite: (){
                        setState(() {
                          selectedIndex=index;
                        });
                      },
                      //isFavourite: selectedIndex==index,
                      state:state,
                      addToCartAction: (){
                        setState(() {
                          selectedIndex = index;
                        });
                        widget.bloc.add(AddItemToCartEvent(
                            AddItemToCartRequest(
                                itemCode: element.itemCode,
                                quantity: 0,
                                transactionOptionId: 1) ));
                      }, isFavourite: true,
                    ),
                  )).toList(),
            )

        ),
      ],
    );
  },
);
  }
}

class ItemsMarkedAsFavorite{
  String itemCode;
  String itemName;
  dynamic itemPrice;
  int quantity;
  bool isFavourite;
  ItemsMarkedAsFavorite({
    required this.itemCode,
    required this.quantity,
    required this.itemName,
    required this.itemPrice,
    required this.isFavourite});
}