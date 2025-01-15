import 'package:custom_grid_view/custom_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/ItemRequestShop.dart';

import '../../../../bloc/shop/shop_bloc.dart';
import '../../../../data/model/response/purchasedItemSummartResponse.dart';
import '../../../../data/repository/FinanceRepo.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/sharedPreference.dart';
import '../../../../utils/ucpLoader.dart';
import 'orderRequestItem.dart';

class Shoprequestscreen extends StatefulWidget {
   ShopBloc bloc;
   Shoprequestscreen({super.key,required this. bloc});

  @override
  State<Shoprequestscreen> createState() => _ShoprequestscreenState();
}
class _ShoprequestscreenState extends State<Shoprequestscreen> {
  late ShopBloc bloc;
  int? selectedIndex;
  int currentPage = 1;
  int pageSize = 10;
  int totalPageSize = 0;
  bool hasMore = true;
  List<PurchasedSummary> purchasedSummaryList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    print("I am here,${purchasedSummaryListTemp.length}");
    bloc = widget.bloc;
    WidgetsBinding.instance.addPostFrameCallback((_) {

      if(purchasedSummaryListTemp.isNotEmpty){
        setState(() {
          purchasedSummaryList=purchasedSummaryListTemp;
        });
       }else{
        bloc.add(GetPurchasedItemRequestItemsEvent(
            PaginationRequest(pageSize: pageSize, currentPage: currentPage)));
      }

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bloc = BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(state.errorResponse.message, context);
          });
          bloc.initial();
        }
        if(state is ShopPurchasedItemsSummaryLoaded){
          WidgetsBinding.instance.addPostFrameCallback((_){
            totalPageSize= state.purchasedItemsSummary.totalCount;
            for (var element in state.purchasedItemsSummary.modelResult) {
              purchasedSummaryList.add(element);
            }
            purchasedSummaryListTemp=purchasedSummaryList;
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
            backgroundColor: AppColor.ucpWhite50,
            body: purchasedSummaryList.isNotEmpty?
            ListView(
              children: [
                Gap(140.h),
                NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      // Load more items when reaching the bottom
                      if (totalPageSize > currentPage) {
                        hasMore = true;
                        currentPage++;
                      }
                      bloc.add(GetPurchasedItemRequestItemsEvent(
                          PaginationRequest(pageSize: pageSize, currentPage: currentPage)));
                    }
                    return true;
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: purchasedSummaryList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                           Get.to(OrderRequestBreakdownScreen(bloc: bloc,
                             orderId:purchasedSummaryList[index].orderId,
                             orderStatus: purchasedSummaryList[index].status.name ,));
                          },
                          child: Container(
                            //  height: 185.h,
                              margin: EdgeInsets.symmetric(vertical: 14.h),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: ItemRequestShopWidget(purchasedSummary: purchasedSummaryList[index])),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ):

            Center(child: Text("No data found",style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.ucpBlack500
            ),),),
          ),
        );
      },
    );
  }
}

//ItemRequestShopWidget