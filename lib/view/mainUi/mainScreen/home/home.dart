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
import 'package:ucp/bloc/dashboard/dashboard_bloc.dart';
import 'package:ucp/data/model/request/transactionRequest.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/constant.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/home/transactionHistory.dart';

import '../../../../data/model/response/dashboardResponse.dart';
import '../../../../data/model/response/transactionHistoryResponse.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import 'homeWidgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  Account? selectedOption;

  late DashboardBloc bloc;
  List<UserTransaction> transactionList = [];
  List<Account> accounts = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(tempAccounts.isEmpty){
        bloc.add(GetDashboardDataEvent());
      }else{
        setState(() {
          accounts = tempAccounts;
          selectedOption =tempAccounts[0];
        });
      }
      if(tempTransactionList.isEmpty){
        bloc.add(GetUserAccountSummary());
      }else{
        setState(() {
          transactionList = tempTransactionList;
        });
      }


    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = context.read<DashboardBloc>();
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(
                "${state.errorResponse.message} ${state.errorResponse.data}",
                context);
          });
          bloc.initial();
        }
        if (state is DashboardData) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            tempAccounts = state.response.accounts;
            accounts = state.response.accounts;
            setState(() {
              selectedOption = accounts[0];
            });
          });
          bloc.initial();
        }
        if (state is AccountSummaryDetails) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            bloc.add(GetTransactionHistory(TransactionRequest(
                month: '3',
                pageNumber: '1',
                pageSize: '15',
                acctNumber: state.response[0].accountNumber)));
          });
          bloc.initial();
        }
        if (state is TransactionHistory) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            transactionList = state.response.transactionList;
            // bloc.add(GetTransactionHistory(TransactionRequest(acctNumber: '')));
          });
          bloc.initial();
        }
        return UCPLoadingScreen(
          visible: state is DashboardIsLoading,
          loaderWidget: LoadingAnimationWidget.discreteCircle(
            color: AppColor.ucpBlue500,
            size: 40.h,
            secondRingColor: AppColor.ucpBlue100,
          ),
          overlayColor: AppColor.ucpBlack400,
          transparency: 0.2,
          child: Scaffold(
            backgroundColor: AppColor.ucpWhite10,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                //Main screen design
                SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 350.h,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(UcpStrings.dashBoardB))),
                            child: Column(
                              children: [
                                Gap(120.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: SizedBox(
                                    height: 40.h,
                                    child: ListView.builder(
                                        itemCount: accounts.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                                selectedOption =
                                                    accounts[index];
                                              });
                                            },
                                            child: Container(
                                              height: 40.h,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 10.h),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4.w),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                  color: index == selectedIndex
                                                      ? AppColor.ucpWhite500
                                                      : Colors.transparent),
                                              child: Center(
                                                child: Text(
                                                  accounts[index].acctProduct,
                                                  style: CreatoDisplayCustomTextStyle
                                                      .kTxtMedium
                                                      .copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: index ==
                                                                  selectedIndex
                                                              ? AppColor
                                                                  .ucpBlack500
                                                              : AppColor
                                                                  .ucpBlue50),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                height40,
                                SizedBox(
                                  height: 79.h,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            selectedOption?.acctProduct ?? "",
                                            style: CreatoDisplayCustomTextStyle
                                                .kTxtMedium
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                    color:
                                                        AppColor.ucpOrange300),
                                          ),
                                          Container(
                                            height: 4.h,
                                            width: 4.w,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 3.h),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColor.ucpWhite500),
                                          ),
                                          Text(
                                            UcpStrings.balanceTxt,
                                            style: CreatoDisplayCustomTextStyle
                                                .kTxtMedium
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                    color: AppColor.ucpWhite30),
                                          ),
                                        ],
                                      ),
                                      height10,
                                      Text(
                                        selectedOption!.bookbalance.isNegative
                                            ? "- ${NumberFormat.currency(symbol: 'NGN', decimalDigits: 0).format(double.parse(selectedOption!.bookbalance.toString().replaceAll("-", "")))}"
                                            : NumberFormat.currency(
                                                    symbol: 'NGN',
                                                    decimalDigits: 0)
                                                .format(selectedOption
                                                    ?.bookbalance),
                                        style: CreatoDisplayCustomTextStyle
                                            .kTxtBold
                                            .copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24.sp,
                                                color: AppColor.ucpWhite500),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: Get.height.h-90.h,
                            color: AppColor.ucpWhite10,
                            child: Expanded(
                              child: Column(
                                children: [
                                  Gap(62.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: Image.asset(
                                        UcpStrings.ucpApplyLoanImage),
                                  ),
                                  height16,
                                  SizedBox(
                                    height: 48.h,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            UcpStrings.recetTransTxt,
                                            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.sp,
                                                    color: AppColor.ucpBlack800),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 28.h,
                                              width: 80.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w),
                                              decoration: BoxDecoration(
                                                  color: AppColor.ucpBlue50,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          19.r)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    UcpStrings.seeAll,
                                                    style:
                                                        CreatoDisplayCustomTextStyle
                                                            .kTxtMedium
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14.sp,
                                                                color: AppColor
                                                                    .ucpBlack800),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: AppColor.ucpBlack920,
                                                    size: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  height12,
                                  SizedBox(
                                    height: 300.h,
                                    child: Column(
                                      children: transactionList
                                          .mapIndexed(
                                              (element, index) => Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 14.h),
                                                    child: TransactWidget(
                                                      transaction: element,
                                                      transactionType: element.debit==null?"credit":"debit",
                                                    ),
                                                  ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      // dashboard shortcuts
                      Positioned(
                          top: 290.h,
                          child: Container(
                            height: 100.h,
                            width: 343.w,
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            // padding: EdgeInsets.symmetric(vertical: 4.h),
                            decoration: BoxDecoration(
                                color: AppColor.ucpWhite500,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                    color: AppColor.ucpBlue100, width: 0.5.w)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                shortCut(
                                  onTap: () {
                                    Get.to(TransactionHistoryScreen(title: selectedOption!.acctProduct,));
                                  },
                                    UcpStrings.addFundsTxt,
                                    CircleWithIconSingleColor(
                                      image: UcpStrings.ucpAddFundsIcon,
                                      color: AppColor.ucpBlue50,
                                    )),
                                shortCut(
                                    onTap: () {
                                      Get.to(TransactionHistoryScreen(title: selectedOption!.acctProduct,));
                                    },
                                    UcpStrings.historyTxt,
                                    CircleWithIconSingleColor(
                                      image: UcpStrings.ucpHistoryIcon,
                                      color: AppColor.ucpBlue50,
                                    )),
                                shortCut(
                                    onTap: () {
                                      Get.to(TransactionHistoryScreen(title: selectedOption!.acctProduct,),
                                      curve: Curves.easeIn);
                                    },
                                    UcpStrings.withdrawTxt,
                                    CircleWithIconSingleColor(
                                      image: UcpStrings.ucpWithdrawIcon,
                                      color: AppColor.ucpBlue50,
                                    )),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                UCPCustomAppBar(child:Padding(
                  padding: EdgeInsets.only(top: 14.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        // width: 163.w,
                        child: Row(
                          children: [
                            Container(
                              height: 32.h,
                              width: 32.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColor.ucpOrange200)),
                            ),
                            Gap(8.w),
                            Text(
                              "Hi ${memberLoginDetails?.employeeName}",
                              style: CreatoDisplayCustomTextStyle
                                  .kTxtMedium
                                  .copyWith(
                                  color: AppColor.ucpWhite500,
                                  fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: BoxDecoration(
                            color: AppColor.ucpWhite500,
                            shape: BoxShape.circle),
                        child: Center(
                          child: badges.Badge(
                            badgeContent: Text(
                              '3',
                              style: CreatoDisplayCustomTextStyle
                                  .kTxtMedium
                                  .copyWith(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpWhite500),
                            ),
                            child: Image.asset(
                              UcpStrings.ucpNotificationImage,
                              height: 24.h,
                              width: 24.w,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget shortCut(String text, Widget child, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 81.h,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            child,
            Gap(8.h),
            Text(
              text,
              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.ucpBlack500),
            )
          ],
        ),
      ),
    );
  }
}
