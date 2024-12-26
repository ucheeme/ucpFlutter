import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopFavorites.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/shopListWidget.dart';

import '../../../../bloc/shop/shop_bloc.dart';
import '../../../../data/model/request/addToCartRequest.dart';
import '../../../../data/model/request/markAsFavorite.dart';
import '../../../../data/model/request/removeFavItem.dart';
import '../../../../data/model/response/shopList.dart';
import '../../../../utils/colorrs.dart';

class ShopScreenListView extends StatefulWidget {
  ShopBloc bloc;
  ShopState state;
  List<ItemsMarkedAsFavorite> shopItemsList;
   ShopScreenListView({super.key,
     required this.shopItemsList,
     required this.bloc,required this.state});

  @override
  State<ShopScreenListView> createState() => _ShopScreenListViewState();
}

class _ShopScreenListViewState extends State<ShopScreenListView> {
  int? selectedIndex;
  List<ItemsMarkedAsFavorite> shopItemsList =[];
  late ShopBloc bloc;
  late ShopState state;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
     setState(() {
       bloc = widget.bloc;
       state = widget.state;
       shopItemsList = widget.shopItemsList;
     });

    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                        if(element.isFavourite) {
                          bloc.add(RemoveItemAsFavEvent(RemoveItemAsFavRequest(id: element.id)));
                        }else{
                          bloc.add(MarkItemAsFavoriteEvent(MarkAsFavoriteRequest(itemCode: element.itemCode)));
                        }
                      },
                      //isFavourite: selectedIndex==index,
                      state:state,
                      addToCartAction: (){
                        setState(() {
                          selectedIndex = index;
                        });
                        bloc.add(AddItemToCartEvent(
                            AddItemToCartRequest(
                                itemCode: element.itemCode,
                                quantity: 0,
                                transactionOptionId: 1) ));
                      }, isFavourite: element.isFavourite,
                    ),
                  )).toList(),
            )

        ),
      ],
    );
  }
}
