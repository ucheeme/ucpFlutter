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
import 'package:ucp/bloc/finance/finance_bloc.dart';
import 'package:ucp/data/model/response/loanRequestBreakDown.dart';
import 'package:ucp/data/repository/FinanceRepo.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/repaymentWidget.dart';

import '../../../../../data/model/response/loanApplicationResponse.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/animatedArc.dart';
import '../../../../../utils/designUtils/animatedPieChart.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';

class LoanRequestDetailScreen extends StatefulWidget {
  FinanceBloc bloc;
  LoanRequests loanRequests;
  bool isRequestBreakdown;
   LoanRequestDetailScreen({super.key,required this.isRequestBreakdown,required this.bloc,required this.loanRequests});

  @override
  State<LoanRequestDetailScreen> createState() =>
      _LoanRequestDetailScreenState();
}

class _LoanRequestDetailScreenState extends State<LoanRequestDetailScreen> {
  late FinanceBloc bloc;
  List<LoanRequestBreakdownList> loanBreakdownList = [
    LoanRequestBreakdownList(date: "02/15/2025 11:15:13", principal: 0.0, interest: 0.0, total: 0.0, balance: 0.0, instalDue: 0),
    LoanRequestBreakdownList(date: "02/15/2025 11:15:13", principal: 0.0, interest: 0.0, total: 0.0, balance: 0.0, instalDue: 0),
  ];
  @override
  void initState() {
    bloc = widget.bloc;
    WidgetsBinding.instance.addPostFrameCallback((_){
      String loanFrequency= "";
      String loanProduct= "";
      for(var element in tempLoanProducts){
        if(widget.loanRequests.productName.toLowerCase()==element.productName.toLowerCase()){
          //setState(() {
            loanProduct = element.productCode.toString();
         // });
        }
      }
      for(var element in tempLoanFrequencies){
        if(widget.loanRequests.frequency.toLowerCase()==element.freqName.toLowerCase()){
         // setState(() {
            loanFrequency = element.freqCode.toString();
        //  });
        }
      }
      print("the loan frequency is $loanFrequency and the loan product is $loanProduct");
      bloc.add(LoanRequestBreakdownEvent(
          LoanRequestBreakdownRequestBody(
              loanProdCode:loanProduct,
              loanAmount:widget.loanRequests.loanAmount,
              loanTenor: widget.loanRequests.duration.toString(),
              loanFrequency: loanFrequency,
              loanInterest: widget.loanRequests.interestRate)));
    });
    super.initState();
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
                           image: const DecorationImage(image: AssetImage(UcpStrings.dashBoardB),fit: BoxFit.cover),
                          borderRadius:BorderRadius.circular(20.r),),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.loanRequests.productName,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpOrange300,
                                )),
                            Text(NumberFormat.currency(symbol: 'NGN', decimalDigits: 0).
                            format(double.parse(widget.loanRequests.loanAmount.toString())),
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
                                  end: 0.0,
                                  child: Padding(
                                    padding:  EdgeInsets.only(top: 50.h),
                                    child: SizedBox(
                                      height: 105.h,
                                      width: 280.w,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 24.33.h,
                                            width: 80.33.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.r),
                                              color:widget.loanRequests.status.toLowerCase() == "pending"
                                                  ? AppColor.ucpOrange100
                                                  : widget.loanRequests.status.toLowerCase() == "approved"||
                                                  widget.loanRequests.status.toLowerCase() == "disbursed"
                                                  ? AppColor.ucpSuccess50:AppColor.ucpDanger75,
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 7.h,
                                                  width: 7.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:widget.loanRequests.status.toLowerCase() == "pending"
                                                        ? AppColor.ucpOrange500
                                                        : widget.loanRequests.status.toLowerCase() == "approved"||
                                                        widget.loanRequests.status.toLowerCase() == "disbursed"
                                                        ? AppColor.ucpSuccess150:AppColor.ucpDanger150,
                                                  ),
                                                ),
                                                Gap(3.33.w),
                                                Text(widget.loanRequests.status,
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
                                          Visibility(
                                            visible: widget.isRequestBreakdown,
                                            child: Text(UcpStrings.nxtpaymentDue,
                                                style: CreatoDisplayCustomTextStyle.kTxtRegular
                                                    .copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.ucpBlack25)),
                                          ),
                                          Text(NumberFormat.currency(name: "NGN", decimalDigits: 0).format(widget.loanRequests.loanAmount),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 46.h,
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
                                                convertDate(loanBreakdownList.first.date),
                                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                                    .copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.ucpBlack500)),

                                            Text(convertDate(loanBreakdownList.last.date),
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
                                        Text("${NumberFormat.currency(name: "NGN", decimalDigits: 0).format(loanBreakdownList.first.total)} per ${widget.loanRequests.frequency.toLowerCase()}",

                                            style: CreatoDisplayCustomTextStyle.kTxtMedium .copyWith(
                                              fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.ucpBlack500
                                            )),
                                        Text("${loanBreakdownList.length} ${widget.loanRequests.frequency.toLowerCase()}",
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
                        height:loanBreakdownList.length*80.h,
                        width: 343.w,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        decoration: BoxDecoration(
                            color: AppColor.ucpWhite500,
                            borderRadius:BorderRadius.circular(16.r)
                        ),
                        child: Column(
                          children: loanBreakdownList.mapIndexed((element, index)
                          => Padding(
                            padding:  EdgeInsets.only(left: 10.w,right: 10.w),
                            child: Column(
                              children: [
                                Gap(24.h),
                                Repaymentwidget(data: element,index: index+1,total: widget.loanRequests.loanAmount,),
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
                            Text("${UcpStrings.loanRequestBreakDownTxt} ",
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
