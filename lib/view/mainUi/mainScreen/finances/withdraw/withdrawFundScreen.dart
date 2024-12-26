import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
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
import 'package:ucp/view/mainUi/mainScreen/finances/withdraw/withdrawRequestScreen.dart';

import '../../../../../bloc/finance/finance_bloc.dart';
import '../../../../../data/model/request/withdrawalRequest.dart';
import '../../../../../data/model/response/memberSavingAccount.dart';
import '../../../../../data/model/response/withdrawBalanceInfo.dart';
import '../../../../../utils/appCustomClasses.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../../utils/sharedPreference.dart';
import '../../../../../utils/ucpLoader.dart';

class WithdrawFunds extends StatefulWidget {
  const WithdrawFunds({super.key});

  @override
  State<WithdrawFunds> createState() => _WithdrawFundsState();
}

class _WithdrawFundsState extends State<WithdrawFunds> {
  late FinanceBloc bloc;
  // bool isWithdraw = true;
  // bool isRequest = false;
  // bool isWithdrawFunds = false;
  List<WithdrawPaymentMode>modeOfPayment =[WithdrawPaymentMode(title: "Cash",paymentId: 1),WithdrawPaymentMode(title: "Cheque",paymentId: 2), WithdrawPaymentMode(title: "Member Account", paymentId: 3)];
  List<UserSavingAccounts>accounts= [];
  int selectedIndex = 0;
  int selectedMOPIndex = 0;
  String holderImager = UcpStrings.dashBoardB;
  int selectedBGIndex = 0;
  int pageNumber =1;
  int pageSize =10;
  List<WithdrawalBackground> memberAcctWithBackground = [];
  WithdrawPaymentMode selectedModeOfPayment=WithdrawPaymentMode(title: "Cash",paymentId: 1);

  List<String>backgroundImages=[UcpStrings.dashBoardB,UcpStrings.ucpMemberAccount1, UcpStrings.ucpMemberAccount2, UcpStrings.ucpMemberAccount3];
  UserSavingAccounts selectedOption=UserSavingAccounts(accountNumber: '', accountProduct: '');
  WithdrawAccountBalanceInfo selectedAccoutBalanceInfo = WithdrawAccountBalanceInfo(accountBalance: 0, loanInterest: 0, loanPrinicpal: 0, retirementAmt: 0);

  TextEditingController amountController = TextEditingController();
  bool isTapped = false;
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
        if(state is FinanceRequestWithdrawalSent){
          WidgetsBinding.instance.addPostFrameCallback((_){
          AppUtils.showSuccessSnack(state.response.data, context);
          Get.back(result: true);
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
            child: GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
                setState(() {
                  isTapped=false;
                });
              },
              child: Scaffold(
                backgroundColor:AppColor.ucpWhite10,
                extendBodyBehindAppBar: true,
                bottomSheet:   Container(
                    height: 83.h,
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColor.ucpBlue50,     //Color( 0xffEDF4FF),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15.r),
                        bottomLeft: Radius.circular(15.r),
                      ),
                    ),
                    child: CustomButton(
                      onTap: () {
                        if(amountController.text.isEmpty||selectedModeOfPayment==null||selectedOption==null){
                          AppUtils.showInfoSnack(UcpStrings.mustNotBeEmptyNull, context);
                        }else{
                          WithdrawalRequest withdrawalRequest = WithdrawalRequest(
                              productAccountNumber: selectedOption.accountNumber,
                              amount: double.parse(amountController.text.replaceAll(",", "")),
                              modeOfPayment: selectedModeOfPayment.paymentId);
                          bloc.add(RequestWithdrawEvent(withdrawalRequest));
                        }

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
                    )
                ),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Gap(120.h),
                              Container(
                                height: 230.h,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(holderImager))),
                                child: Column(
                                  children: [
                                    Gap(20.h),
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
                                      height: 63.h,
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
                                       Spacer(),
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
                                                letterSpacing: -1,
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
                                  height: Get.height.h,
                                  color: AppColor.ucpWhite10,
                                  child: Column(
                                    children: [
                                      Gap(20.h),
                                      height16,
                                      SizedBox(
                                        height: 400.h,
                                        width: MediaQuery.of(context).size.width,
                                        child:Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: 16.w),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(UcpStrings.enterDesiredAmountToWithdraw,
                                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                                color: AppColor.ucpBlack700
                                              ),),
                                              height8,
                                              CustomizedTextField(
                                                fillColor: AppColor.ucpWhite50,
                                                keyboardType: TextInputType.number,
                                                inputFormat: [ThousandSeparatorFormatter()],
                                                prefixWidget: Padding(
                                                  padding:  EdgeInsets.symmetric(horizontal: 8.w),
                                                  child: Text("NGN",style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                                      fontWeight: FontWeight.w500, fontSize: 14.sp,color: AppColor.ucpBlack800),),
                                                ),
                                                onTap: (){
                                                  setState(() {
                                                    isTapped=true;
                                                  });
                                                },
                                                isTouched: isTapped,
                                                isConfirmPasswordMatch: false,
                                                textEditingController: amountController,
                                              ),
                                              Text(UcpStrings.selectPaymentMode,
                                                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                    color: AppColor.ucpBlack800
                                                ),),
                                              height8,
                                              SizedBox(
                                                height: 200.h,
                                                child: ListView(

                                                    children: modeOfPayment
                                                        .mapIndexed((element, index) =>
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedModeOfPayment = element;
                                                              selectedMOPIndex = index;
                                                            });
                                                          },
                                                          child: Container(
                                                              height: element.title.length > 30
                                                                  ? 70.h
                                                                  : 48.h,
                                                              margin: EdgeInsets.only(
                                                                  bottom: 14.h, ),
                                                              padding:
                                                              EdgeInsets.symmetric(horizontal: 12.h),
                                                              decoration: BoxDecoration(
                                                                  color: (index == selectedMOPIndex)
                                                                      ? AppColor.ucpBlue25
                                                                      : AppColor.ucpWhite500,
                                                                  borderRadius:
                                                                  BorderRadius.circular(12.r),
                                                                  border: Border.all(
                                                                    color: (index == selectedMOPIndex)
                                                                        ? AppColor.ucpBlue500
                                                                        : AppColor.ucpWhite500,
                                                                  )),
                                                              child: BottomsheetRadioButtonRightSide(
                                                                radioText: element.title,
                                                                isMoreThanOne:
                                                                element.title.length > 30,
                                                                isDmSans: false,
                                                                isSelected: index == selectedMOPIndex,
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedMOPIndex = index;
                                                                  });
                                                                },
                                                                textHeight: element.title.length > 30
                                                                    ? 24.h
                                                                    : 16.h,
                                                              )),
                                                        )
                                                    )
                                                        .toList()),
                                              ),
                                            ],
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                         // dashboard shortcuts

                        ],
                      ),
                    ),
                    UCPCustomAppBar(
                        height: 95.h,
                        appBarColor: AppColor.ucpWhite10.withOpacity(0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Gap(30.h),
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
                                Text(UcpStrings.withdrawFunds,
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
            ));
      },
    );
  }
}

class WithdrawPaymentMode{
  String title;
  int paymentId;
  WithdrawPaymentMode({
   required this.title,
   required this.paymentId
});
}