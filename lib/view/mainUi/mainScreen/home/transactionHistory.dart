import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/bloc/transactionHistory/transaction_history_bloc.dart';
import 'package:ucp/data/model/response/transactionHistoryResponse.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/home/homeWidgets.dart';

import '../../../../data/model/request/transactionRequest.dart';
import '../../../../data/model/response/userAcctResponse.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../errorPages/noNotification.dart';

class TransactionHistoryScreen extends StatefulWidget {
  String title;

  TransactionHistoryScreen({super.key, required this.title});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  bool isAll = true;
  bool isInflow = false;
  bool isOutflow = false;
  int currentPage = 1;// Track the current page
  int totalCount = 0;
  bool isLoading = false; // Show loading indicator
  bool hasMore = true; // Flag to indicate if there are more pages
  List<UserTransaction> transactionList = [];
  late TransactionHistoryBloc bloc;
  String transactionMonth ="";
  List<UserAccounts> userAccountList = [];
  List<UserTransaction> inflowList = [];
  List<UserTransaction> outflowList = [];
  Map<String, List<UserTransaction>> groupedTransactions = {};
  Map<String, List<UserTransaction>> inflowGroupedTransactions = {};
  Map<String, List<UserTransaction>> outflowGroupedTransactions = {};
  double itemHeight = 150.h;
@override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((_){
    // if(tempTransactionList.isEmpty){
       bloc.add(GetUserAccountSummary());
    // }
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TransactionHistoryBloc>(context);
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        if (state is AccountSummaryDetails) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            userAccountList=state.response;
            bloc.add(GetTransactionHistory(TransactionRequest(
                month: '3',
                pageNumber: currentPage.toString(),
                pageSize: '10',
                acctNumber: state.response[0].accountNumber)));
          });
          bloc.initial();
        }
        if (state is TransactionHistory) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            tempTransactionList = state.response.transactionList;
            totalCount = state.response.totalCount;
            transactionList = state.response.transactionList;
            transactionList.sort((a, b) => a.trandate!.compareTo(b.trandate!));
            for (var element in transactionList) {
                if(element.credit!=null){
                  inflowList.add(element);
                }else{
                  outflowList.add(element);
                }
            }

            for (var transaction in transactionList) {
              String month = DateFormat('MMMM').format(transaction.trandate!);
              groupedTransactions.putIfAbsent(month, () => []).add(transaction);
            }
            for (var transaction in inflowList) {
              String month = DateFormat('MMMM').format(transaction.trandate!);
              inflowGroupedTransactions.putIfAbsent(month, () => []).add(transaction);
            }

            for (var transaction in outflowList) {
              String month = DateFormat('MMMM').format(transaction.trandate!);
              inflowGroupedTransactions.putIfAbsent(month, () => []).add(transaction);
            }

            // bloc.add(GetTransactionHistory(TransactionRequest(acctNumber: '')));
          });
          bloc.initial();
        }
        return UCPLoadingScreen(
          visible: state is TransactionIsLoading,
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
               SizedBox(
                 height: Get.height,
                 child: ListView(
                   children: [
                     Gap(120.h),
                     Padding(
                       padding:  EdgeInsets.symmetric(horizontal: 16.w),
                       child: SizedBox(height:Get.height,child: _buildTransactionLisWidget()),
                     ),
                   ],
                 ),
               ),
                UCPCustomAppBar(
                    height: 150.h,
                    appBarColor: AppColor.ucpWhite10.withOpacity(0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(40.h),
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
                            Text(
                              "${formatFirstTitle(widget.title.toLowerCase())} ${UcpStrings.transactionHistoryTxt}",
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpBlack500),
                            )
                          ],
                        ),
                        height10,
                        Container(
                          height: 40.h,
                          width: 192.w,
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
                                    isAll = true;
                                    isInflow = false;
                                    isOutflow = false;
                                  });
                                },
                                child: AnimatedContainer(
                                  height: 32.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: isAll
                                        ? AppColor.ucpBlue600
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(40.r),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  child: Center(
                                    child: Text(
                                      UcpStrings.allTxt,
                                      style: CreatoDisplayCustomTextStyle
                                          .kTxtMedium
                                          .copyWith(
                                        fontSize: 14.sp,
                                        color: isAll
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
                                    isAll = false;
                                    isInflow = true;
                                    isOutflow = false;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(seconds: 2),
                                  height: 32.h,
                                  width: 62.w,
                                  decoration: BoxDecoration(
                                    color: isInflow
                                        ? AppColor.ucpBlue600
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(40.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      UcpStrings.inFlowTxt,
                                      style: CreatoDisplayCustomTextStyle
                                          .kTxtMedium
                                          .copyWith(
                                        fontSize: 14.sp,
                                        color: isInflow
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
                                    isAll = false;
                                    isInflow = false;
                                    isOutflow = true;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(seconds: 2),
                                  height: 32.h,
                                  width: 74.w,
                                  decoration: BoxDecoration(
                                    color: isOutflow
                                        ? AppColor.ucpBlue600
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(40.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      UcpStrings.outFlowTxt,
                                      style: CreatoDisplayCustomTextStyle
                                          .kTxtMedium
                                          .copyWith(
                                        fontSize: 14.sp,
                                        color: isOutflow
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
                        )
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildTransactionLisWidget() {
    if(isAll){
      print("this is total: ${totalCount}");
      if(groupedTransactions.isEmpty){
        return EmptyNotificationsScreen(
            press: () {
          bloc.add(GetTransactionHistory(TransactionRequest(
              month: DateTime.now().month.toString(),
              pageNumber: '1',
              pageSize: '10',
              acctNumber: userAccountList[0].accountNumber)));
        }
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // Load more items when reaching the bottom
            if(totalCount > currentPage){
              hasMore = true;
              currentPage++;
            }
            bloc.add(GetTransactionHistory(TransactionRequest(
                month: '3',
                pageNumber: currentPage.toString(),
                pageSize: '10',
                acctNumber: userAccountList[0].accountNumber)));
          }
          return true;
        },
        child: ListView.builder(
           // physics: const NeverScrollableScrollPhysics(),
            itemCount: groupedTransactions.length,
            itemBuilder: (context, index) {
              groupedTransactions.forEach((month, transactionList) {});
              return SizedBox(
                height:200.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("${groupedTransactions.entries.elementAt(index).key} transactions",
                    //   style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp,
                    //       fontWeight: FontWeight.w500, color: AppColor.ucpBlack600),),
                    // height12,
                    SizedBox(
                      height:100,
                      child: ListView(
                        children: groupedTransactions.entries.elementAt(index).value.mapIndexed((element, index)=>
                            TransactWidget(transaction: element,
                                transactionType: element.debit==null?
                                "credit":"debit")
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }
    if(isInflow){
      if(inflowGroupedTransactions.isEmpty){
        return EmptyNotificationsScreen(
            press: () {

              bloc.add(GetTransactionHistory(TransactionRequest(
                  month: DateTime.now().month.toString(),
                  pageNumber:currentPage.toString(),
                  pageSize: '10',
                  acctNumber: userAccountList[0].accountNumber)));
            }
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
             // Load more items when reaching the bottom
            if(totalCount > currentPage){
              hasMore = true;
              currentPage++;
            }
            bloc.add(GetTransactionHistory(TransactionRequest(
                month: DateTime.now().month.toString(),
                pageNumber: currentPage.toString(),
                pageSize: '10',
                acctNumber: userAccountList[0].accountNumber)));
          }
          return true;
        },
        child: ListView.builder(
            itemCount: inflowGroupedTransactions.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == inflowGroupedTransactions.length) {
                return const Center(child: CircularProgressIndicator());
              }
              inflowGroupedTransactions.forEach((month, transactionList) {});
              return SizedBox(
                height: MediaQuery.of(context).size.height*
                    getHeight(inflowGroupedTransactions.entries.elementAt(index).value.length),
                width: 300.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${inflowGroupedTransactions.entries.elementAt(index).key} transactions",
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp,
                          fontWeight: FontWeight.w500, color: AppColor.ucpBlack600),),
                    height12,
                    Expanded (
                      child: Column(
                        children: inflowGroupedTransactions.entries.elementAt(index).value.mapIndexed((element, index)=>
                            TransactWidget(transaction: element,
                                transactionType: "credit")
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    }
    if(isOutflow){
      if(outflowGroupedTransactions.isEmpty){
        return EmptyNotificationsScreen(
          press: () {
            bloc.add(GetTransactionHistory(TransactionRequest(
                month: DateTime.now().month.toString(),
                pageNumber: currentPage.toString(),
                pageSize: '10',
                acctNumber: userAccountList[0].accountNumber)));
          },
        );
      }
      return ListView.builder(
          itemCount: outflowGroupedTransactions.length,
          itemBuilder: (context, index) {
            outflowGroupedTransactions.forEach((month, transactionList) {});
            return SizedBox(
              height: MediaQuery.of(context).size.height*
                  getHeight(outflowGroupedTransactions.entries.elementAt(index).value.length),
              width: 300.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${outflowGroupedTransactions.entries.elementAt(index).key} transactions",
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp,
                        fontWeight: FontWeight.w500, color: AppColor.ucpBlack600),),
                  height12,
                  Expanded (
                    child: Column(
                      children: outflowGroupedTransactions.entries.elementAt(index).value.mapIndexed((element, index)=>
                          TransactWidget(transaction: element,
                              transactionType:"debit")
                      ).toList(),
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return SizedBox.shrink();
  }

  }

