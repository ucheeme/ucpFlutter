import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/utils/appExtentions.dart';

import '../../../../../bloc/finance/finance_bloc.dart';
import '../../../../../data/model/response/memberSavingAccount.dart';
import '../../../../../data/model/response/withdrawBalanceInfo.dart';
import '../../../../../data/model/response/withdrawTransactionHistory.dart';
import '../../../../../data/repository/FinanceRepo.dart';
import '../../../../../utils/appCustomClasses.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../../utils/sharedPreference.dart';
import '../../../../../utils/ucpLoader.dart';
import '../../../../bottomSheet/enterAmoun.dart';
import '../../home/homeWidgets.dart';
import '../../home/transactionHistory.dart';
import '../withdraw/withdrawFundScreen.dart';
import '../withdraw/withdrawRequestScreen.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  late FinanceBloc bloc;
  bool isWithdraw = true;
  bool isRequest = false;
  bool isWithdrawFunds = false;

  List<UserSavingAccounts>accounts= [];
  int selectedIndex = 0;
  String holderImager = UcpStrings.dashBoardB;
  int selectedBGIndex = 0;
  int pageNumber =1;
  int pageSize =10;
  List<WithdrawalBackground> memberAcctWithBackground = [];
  List<WithdrawTransactionHistory> memberSavingHistory = [];
  List<String>backgroundImages=[UcpStrings.dashBoardB,UcpStrings.ucpMemberAccount1, UcpStrings.ucpMemberAccount2, UcpStrings.ucpMemberAccount3];
  UserSavingAccounts selectedOption=UserSavingAccounts(accountNumber: '', accountProduct: '');
  WithdrawAccountBalanceInfo selectedAccoutBalanceInfo = WithdrawAccountBalanceInfo(accountBalance: 0, loanInterest: 0, loanPrinicpal: 0, retirementAmt: 0);


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(tempMemberSavingAccounts.isEmpty) {
        bloc.add(const GetMemberSavingAccounts());
      }
      else{
        setState(() {
          accounts= tempMemberSavingAccounts;
          selectedOption= accounts[0];
        });
        for(var element in accounts){
          if(selectedBGIndex<=3){
            memberAcctWithBackground.add(
                WithdrawalBackground(
                    userSavingAccounts: element,
                    backgroundImage: backgroundImages[selectedBGIndex]
                ));
          }else{
            selectedBGIndex=0;
            memberAcctWithBackground.add(
                WithdrawalBackground(
                    userSavingAccounts: element,
                    backgroundImage: backgroundImages[selectedBGIndex]
                ));
          }
          selectedBGIndex++;
        }
        bloc.add(GetMemberAccountBalance(WithdrawAccountBalanceRequest(
            accountNumber: selectedOption.accountNumber, accountName:selectedOption.accountProduct)));
      }

      // if(tempWithdrawTransactionHistory.isEmpty){
      bloc.add(GetWithdrawalHistoryEvent( PaginationRequest(pageSize: pageSize, currentPage: pageNumber)));
      // }else{
      //   memberSavingHistory = tempWithdrawTransactionHistory;
      // }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc = context.read<FinanceBloc>();
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(
                "${state.errorResponse.message} ${state.errorResponse.data}",
                context);
          });
          bloc.initial();
        }
        if(state is FinanceMemberAccounts){
          WidgetsBinding.instance.addPostFrameCallback((_){
            accounts = state.memberAccountsList;
            tempMemberSavingAccounts= accounts;
            for(var element in accounts){
              if(selectedBGIndex<=3){
                memberAcctWithBackground.add(
                    WithdrawalBackground(
                        userSavingAccounts: element,
                        backgroundImage: backgroundImages[selectedBGIndex]
                    ));
              }else{
                selectedBGIndex=0;
                memberAcctWithBackground.add(
                    WithdrawalBackground(
                        userSavingAccounts: element,
                        backgroundImage: backgroundImages[selectedBGIndex]
                    ));
              }
              selectedBGIndex++;
            }

          });
          bloc.initial();
        }
        if(state is FinanceMemberAccountBalance){
          WidgetsBinding.instance.addPostFrameCallback((_){
            selectedAccoutBalanceInfo = state.withdrawAccountBalanceInfo;
          });
          bloc.initial();
        }
        if(state is FinanceMemberSavingHistory){
          WidgetsBinding.instance.addPostFrameCallback((_){
            tempMemberSavingHistory = state.response.modelResult;
            memberSavingHistory = state.response.modelResult;
          });
          bloc.initial();
        }
        return UCPLoadingScreen(
            visible: state is FinanceIsLoading,
            loaderWidget: LoadingAnimationWidget.discreteCircle(
              color: AppColor.ucpBlue500,
              size: 40.h,
              secondRingColor: AppColor.ucpBlue100,
            ),
            overlayColor: AppColor.ucpBlack400,
            transparency: 0.5,
            child: Scaffold(
              backgroundColor:AppColor.ucpWhite10,
              extendBodyBehindAppBar: true,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Stack(
                      children: [
                        CustomMaterialIndicator(
                          onRefresh: onRefresh, // Your refresh logic
                          backgroundColor: Colors.white,
                          indicatorBuilder: (context, controller) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: CircularProgressIndicator(
                                color: Colors.redAccent,
                                value: controller.state.isLoading ? null : math.min(controller.value, 1.0),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Gap(100.h),
                              Container(
                                height: 280.h,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(holderImager))),
                                child: Column(
                                  children: [
                                    Gap(30.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      child: SizedBox(
                                        height: 40.h,
                                        child: ListView.builder(
                                            itemCount: memberAcctWithBackground.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    holderImager =memberAcctWithBackground[index].backgroundImage;
                                                    selectedIndex = index;
                                                    selectedOption =
                                                        memberAcctWithBackground[index].userSavingAccounts;
                                                  });
                                                  bloc.add(GetMemberAccountBalance(WithdrawAccountBalanceRequest(
                                                      accountNumber: selectedOption.accountNumber, accountName:selectedOption.accountProduct)));
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
                                                      formatFirstTitle(memberAcctWithBackground[index].userSavingAccounts.accountProduct),
                                                      // formatFirstTitle("CONTRIBUTOR"),
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
                                                formatFirstTitle(selectedOption?.accountProduct ?? ""),
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
                                            selectedAccoutBalanceInfo!.accountBalance.isNegative
                                                ? "- ${NumberFormat.currency(symbol: 'NGN', decimalDigits: 0).format(double.parse(selectedAccoutBalanceInfo!.accountBalance.toString().replaceAll("-", "")))}"
                                                : NumberFormat.currency(
                                                symbol: 'NGN',
                                                decimalDigits: 0)
                                                .format(selectedAccoutBalanceInfo
                                                ?.accountBalance ?? 0),
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
                              SingleChildScrollView(
                                child: Container(
                                  height: memberSavingHistory.isEmpty?600.h:Get.height.h,
                                  color: AppColor.ucpWhite10,
                                  child: Column(
                                    children: [
                                      Gap(80.h),
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
                                      memberSavingHistory.isEmpty?
                                      SizedBox(
                                        height: 200.h,
                                        child: Center(
                                          child: Text(UcpStrings.emptyTransactionTxt,style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                              color: AppColor.ucpBlack500
                                          )),
                                        ),
                                      ):
                                      SizedBox(
                                        height: 550.h,
                                        child:
                                        ListView(
                                          padding: EdgeInsets.symmetric(horizontal:16.w),
                                          children: memberSavingHistory
                                              .mapIndexed(
                                                  (element, index) => Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 14.h),
                                                child: WithdrawalTransactionWidgets(
                                                  transaction: element,),
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
                        ),
                        // dashboard shortcuts
                        Positioned(
                            top: 320.h,
                            left: 100.w,
                            right: 100.w,
                            child: Container(
                              height: 120.h,
                              // width: 80.w,
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              // padding: EdgeInsets.symmetric(vertical: 4.h),
                              decoration: BoxDecoration(
                                  color: AppColor.ucpWhite500,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                      color: AppColor.ucpBlue100, width: 0.5.w)),
                              child: shortCut(
                                  onTap:() async {
                                    await showCupertinoModalBottomSheet(
                                        topRadius: Radius.circular(15.r),
                                        backgroundColor:
                                        AppColor.ucpWhite500,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: Container(
                                                height: 220.h,
                                                color: AppColor.ucpWhite500,
                                                child: EnterAmountBottomSheet()),
                                          );
                                        });
                                  },
                                  UcpStrings.addFundsTxt,
                                  CircleWithIconSingleColor(
                                    image: UcpStrings.ucpAddFundsIcon,
                                    color: AppColor.ucpBlue50,
                                  )),
                            )),
                      ],
                    ),
                  ),
                  UCPCustomAppBar(
                      height: 100.h,
                      appBarColor: AppColor.ucpWhite500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(50.h),
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
                              Text("${UcpStrings.savingTxt} ",
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
            ));
      },
    );
  }
  Widget shortCut(String text, Widget child, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 81.h,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
            Gap(10.h),
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

  Future<void> onRefresh() async{
    bloc.add(GetWithdrawalHistoryEvent( PaginationRequest(pageSize: pageSize, currentPage: pageNumber)));
  }
}
