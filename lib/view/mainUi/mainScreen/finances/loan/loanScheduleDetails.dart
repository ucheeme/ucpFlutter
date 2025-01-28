import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/bloc/finance/finance_bloc.dart';
import 'package:ucp/data/model/request/loanApplicationRequest.dart';
import 'package:ucp/data/model/response/loanRequestBreakDown.dart';
import 'package:ucp/data/repository/FinanceRepo.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/bottomSheet/SuccessNotification.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/repaymentWidget.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/repaymentWidgetRefund.dart';

import '../../../../../bloc/finance/loanController.dart';
import '../../../../../data/model/response/allGuarantors.dart';
import '../../../../../data/model/response/loanApplicationResponse.dart';
import '../../../../../data/model/response/loanProductResponse.dart';
import '../../../../../data/model/response/loanScheduleForRefund.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/animatedArc.dart';
import '../../../../../utils/designUtils/animatedPieChart.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../bottomSheet/guarantorDesign.dart';

class LoanScheduleDetail extends StatefulWidget {
  FinanceBloc bloc;
 List<LoanScheduleForRefundResponse> loanRequests;
  bool isRequestBreakdown;
  Widget? bottomSheet;
  LoanController controller;
  LoanScheduleDetail({super.key,
    required this.isRequestBreakdown,
    required this.controller,
    this.bottomSheet,
    required this.bloc,required this.loanRequests});

  @override
  State<LoanScheduleDetail> createState() =>
      _LoanRequestDetailScreenState();
}

class _LoanRequestDetailScreenState extends State<LoanScheduleDetail> {
  late FinanceBloc bloc;
  List<LoanRequestBreakdownList> loanBreakdownList = [];
  List<LoanScheduleForRefundResponse> paidLoans =[];
  List<LoanScheduleForRefundResponse> unpaidLoans =[];
  LoanScheduleForRefundResponse? currentMonthPay;
  double totalAmountPaid =0;
  @override
  void initState() {
    bloc = widget.bloc;
    if(widget.loanRequests.last.paymentStatus.toLowerCase()=="paid"){
      setState(() {
        currentMonthPay = widget.loanRequests.last;
      });
    }else{
      for(var element in widget.loanRequests){
        print("${element.paymentStatus}prrrrtt1");
        if(element.paymentStatus.toLowerCase()=="outstanding") {
          print("prrrrtt");
          currentMonthPay = element;
          setState(() {
            currentMonthPay=currentMonthPay;
          });
          break;
        }
      }
    }

    paidLoans = widget.loanRequests.where((element) => element.paymentStatus.toLowerCase()=="paid").toList();
    unpaidLoans =widget.loanRequests.where((element) => element.paymentStatus.toLowerCase()=="outstanding").toList();
    super.initState();
  }

  Future<void> _showGuarantorSelectionModal() async {

    List<LoanGuantorsList>? response = await   showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.ucpWhite500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.3,
        builder: (context, scrollController) {
          return  Container(
            height: 485.h,
            color: AppColor.ucpWhite500,
            child: GuantorListDesign(allGuantors: tempLoansGuarantors,
              scrollController: scrollController,),
          );
        },
      ),
    );

    if (response != null) {
      setState(() {

      });

      // bloc.validation.setCooperative(response);
    }
  }

  @override
  Widget build(BuildContext context) {
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

        if (state is LoanRequestBreakdownState) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            loanBreakdownList = state.response;
          });
          bloc.initial();
        }
        if(state is LoanApplicationState){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showCupertinoModalBottomSheet(
              topRadius: Radius.circular(15.r),
              backgroundColor: AppColor.ucpWhite500,
              context: context,
              builder: (context) {
                return Container(
                  height: 400.h,
                  color: AppColor.ucpWhite500,
                  child: LoadLottie(lottiePath: UcpStrings.ucpLottieStampSeal,
                    bottomText: state.response.message,
                  ),
                );
              },
            ).then((value){
              Get.back(result: true);
            });
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
          transparency: 0.2,
          child: Scaffold(
            backgroundColor: AppColor.ucpWhite10,
            extendBodyBehindAppBar: true,
            extendBody: true,
            bottomSheet:Container(
              height: currentMonthPay?.status.toLowerCase()=="complete"?83.h:150.h,
              color: AppColor.ucpBlue300.withOpacity(0.2),
              padding:EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 51.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.r),
                      //  ? AppColor.ucpDanger150:AppColor.ucpSuccess150,
                      color: currentMonthPay?.status.toLowerCase()=="complete"?AppColor.ucpSuccess50:AppColor.ucpDanger75,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Loan status:",
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColor.ucpBlack500,
                          ),
                        ),
                        Container(
                          height: 25.h,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: currentMonthPay?.status.toLowerCase()=="complete"?AppColor.ucpSuccess100:AppColor.ucpDanger150,
                          ),
                          child: Center(
                            child: Text(
                              currentMonthPay?.status??"",
                              textAlign: TextAlign.center,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: AppColor.ucpWhite500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: currentMonthPay?.status.toLowerCase()!="complete",
                    child: CustomButton(
                      onTap: () {
                       // _showGuarantorSelectionModal();
                      },
                      borderRadius: 30.r,
                      buttonColor: AppColor.ucpBlue500,
                      buttonText: UcpStrings.applyForLoan,
                      height: 51.h,
                      textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: AppColor.ucpWhite500,
                      ),
                      textColor: AppColor.ucpWhite500,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pay Loan",
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppColor.ucpWhite500,
                              ),
                            ),

                            Text(NumberFormat.currency( symbol: 'NGN', decimalDigits: 0).format(double.parse(currentMonthPay?.totalAmount.toString()??"0")),
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppColor.ucpWhite500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),),
            body: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: [
                      Gap(110.h),
                      Container(
                        height:92.h,
                        width: 343.w,
                        decoration: BoxDecoration(
                          image:  const DecorationImage(image: AssetImage(UcpStrings.dashBoardB),fit: BoxFit.cover),
                          borderRadius:BorderRadius.circular(20.r),),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(currentMonthPay?.productName??"",
                                textAlign: TextAlign.center,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpOrange300,
                                )),
                            Text(NumberFormat.currency(symbol: 'NGN', decimalDigits: 0).
                            format(double.parse(currentMonthPay?.totalAmount.toString()??"0")),
                                style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.ucpWhite500,
                                )),
                          ],
                        ),
                      ),
                      Gap(8.h),
                      Container(
                        height: 355.8.h,
                        width: 343.w,
                        padding: EdgeInsets.only(top: 40.h,left: 20.w,right: 20.w),
                        decoration: BoxDecoration(
                          color: AppColor.ucpWhite500,
                          borderRadius:BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 200.h,
                                width: 300.w,
                                child: AnimatedArc(
                                  end: (((currentMonthPay!.totalRepayAmount*paidLoans.length)-(currentMonthPay?.interestAmount * paidLoans.length))/currentMonthPay?.totalAmount)*3.15,
                                  child: Padding(
                                    padding:  EdgeInsets.only(top: 50.h),
                                    child: SizedBox(
                                      height: 105.h,
                                      width: 280.w,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 24.33.h,
                                            width: 90.33.w,
                                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.r),
                                              color:currentMonthPay?.status.toLowerCase() == "outstanding"
                                                  ? AppColor.ucpDanger75:AppColor.ucpSuccess50,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 7.h,
                                                  width: 7.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:currentMonthPay?.status.toLowerCase() == "outstanding"
                                                        ? AppColor.ucpDanger150:AppColor.ucpSuccess150,
                                                  ),
                                                ),
                                                Gap(3.33.w),
                                                Text(currentMonthPay?.status??"",
                                                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColor.ucpBlack800
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Gap(20.h),
                                          Text(currentMonthPay?.status.toLowerCase()=="complete"?"":UcpStrings.nxtpaymentDue,
                                              style: CreatoDisplayCustomTextStyle.kTxtRegular
                                                  .copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.ucpBlack25)),
                                          Text(NumberFormat.currency(name: "NGN", decimalDigits: 0).format((currentMonthPay!.totalRepayAmount*paidLoans.length)),
                                              style: CreatoDisplayCustomTextStyle.kTxtBold .copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 22.sp,
                                                  color: AppColor.ucpBlack500
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            Gap(10.h),

                            SizedBox(
                              height: 81.h,
                              child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 48.5.h,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(UcpStrings.startDate,
                                                style: CreatoDisplayCustomTextStyle.kTxtRegular
                                                    .copyWith(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.ucpBlack25)),

                                            Text(UcpStrings.endDate,
                                                style: CreatoDisplayCustomTextStyle.kTxtRegular
                                                    .copyWith(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.ucpBlack25))

                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                formatDate(currentMonthPay?.startDate.toIso8601String()??""),
                                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                                    .copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.ucpBlack500)),

                                            Text(formatDate(currentMonthPay?.maturityDate.toIso8601String()??""),
                                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                                    .copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.ucpBlack500)),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${NumberFormat.currency(name: "NGN", decimalDigits: 0).
                                        format(currentMonthPay?.totalRepayAmount)} per ${removeNumbers(currentMonthPay?.loanTerm??"")}",

                                            style: CreatoDisplayCustomTextStyle.kTxtMedium .copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.ucpBlack500
                                            )),
                                        Text(currentMonthPay?.loanTerm.trim()??"",
                                            style: CreatoDisplayCustomTextStyle.kTxtMedium .copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.ucpBlack500
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Gap(20.h),
                      Text(UcpStrings.loanRepaymentBreakdown,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack500)),
                      height14,
                      Container(
                        height: widget.loanRequests.isEmpty?100.h:widget.loanRequests.length*90.h,
                        width: 343.w,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        decoration: BoxDecoration(
                            color: AppColor.ucpWhite500,
                            borderRadius:BorderRadius.circular(16.r)
                        ),
                        child:  widget.loanRequests.isEmpty?
                        Center(child:   Text(UcpStrings.fetchingData,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium
                                .copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack500)),)
                            :Column(
                          children: widget.loanRequests.mapIndexed((element, index)
                          => Padding(
                            padding:  EdgeInsets.only(left: 10.w,right: 10.w),
                            child: Column(
                              children: [
                                Gap(24.h),
                                RefundWidget(data: element,index: index+1,total:double.parse(currentMonthPay?.totalAmount.toString()??"0"),),
                              ],
                            ),
                          )).toList(),
                        ),
                      )

                    ],
                  ),
                ),
                UCPCustomAppBar(
                    height: 80.h,
                    appBarColor: AppColor.ucpWhite10.withOpacity(0.3),
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
                            Text("${currentMonthPay?.productName.trim()} loan breakdown ",
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
        );
      },
    );
  }
}

String removeNumbers(String text) {
  return text.replaceAll(RegExp(r'[0-9]'), '');
}