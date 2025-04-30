import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/bloc/finance/finance_bloc.dart';
import 'package:ucp/bloc/finance/loanController.dart';
import 'package:ucp/data/model/response/loanApplicationResponse.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/bottomSheet/guarantorDesign.dart';

import '../../../../../data/model/response/cooperativeList.dart';
import '../../../../../data/model/response/loanProductResponse.dart';
import '../../../../../data/model/response/purchasedItemSummartResponse.dart';
import '../../../../../data/repository/FinanceRepo.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../bottomSheet/cooperatives.dart';
import 'loanRequestDetails.dart';
bool isRequestsFromApply = false;
class ApplyForLoan extends StatefulWidget {
LoanController controller;
  ApplyForLoan({super.key,required this.controller});

  @override
  State<ApplyForLoan> createState() => _ApplyForLoanState();
}

class _ApplyForLoanState extends State<ApplyForLoan> {
  late FinanceBloc bloc;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
      for (var element in tempLoanFrequencies) {
        print("the frequency is ${element.freqName}");
      }
      if (tempLoanProducts.isEmpty) {
        bloc.add(GetAllLoanProductsEvent());
      }
      if (tempLoanFrequencies.isEmpty) {
        bloc.add(GetAllLoanFrequenciesEvent());
      } else {
        //  frequencyController.text = tempLoanFrequencies[0].freqName;
      }
      String loanFrequency = "";
      String loanProduct = "";
    });
    super.initState();
  }

String loanInterest = "";

  Future<void> _showLoanProductSelectionModal() async {
    LoanProductList? response = await showCupertinoModalBottomSheet(
      topRadius: Radius.circular(15.r),
      backgroundColor: AppColor.ucpWhite500,
      context: context,
      builder: (context) {
        return Container(
          height: 500.h,
          color: AppColor.ucpWhite500,
          child: LoanProductsLisDesign(loanProductList: tempLoanProducts),
        );
      },
    );

    if (response != null) {
      setState(() {
        widget.controller.loanProductController.text = response.productName;
        widget.controller.loanProduct = response.productCode;

        bloc.add(GetLoanFrequencyForProductEvent(widget.controller.loanProduct));
      });

      // bloc.validation.setCooperative(response);
    }
  }



  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<FinanceBloc>(context);
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
        if (state is LoanFrequencyInterestState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.controller.interestController.text = "${state.response.interestRate}%";
            loanInterest =state.response.interestRate;
            widget.controller.loanFreq = state.response.frequency;
            widget.controller.frequencyController.text = state.response.frequency;
            widget.controller.loanInterest = state.response.interestRate;
            // frequencyController.text=tempLoanFrequencies.where((e) =>
            // e.freqCode==loanFreq).first.freqName;
          });
          bloc.initial();
        }
        if (state is AllLoanFrequenciesState) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              tempLoanFrequencies = state.response;
            });
          });
          bloc.initial();
        }
        if (state is AllLoanProductsState) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            tempLoanProducts = state.response;
          });
          bloc.initial();
        }

        if(state is AllLoanGuarantorsState){
          WidgetsBinding.instance.addPostFrameCallback((_) async {
          double amountEntered= double.parse(widget.controller.loanAmountController.text.replaceAll(",", "").trim());
          print("this is interest1 ${loanInterest}");
          double interest = double.parse(  widget.controller.interestController.text.split(".")[0]);
            tempLoansGuarantors = state.response;
            LoanRequests loanrequest = LoanRequests(
                applicationNumber: "",
                productName:    widget.controller.loanProductController.text,
                loanAmount: (amountEntered*(interest/100))+amountEntered,
                duration: int.parse(   widget.controller.loanDurationController.text),
                status:"Pending",
                date: getOneMonthLater(DateTime.now()),
                interestRate:    widget.controller.loanInterest,
                frequency: getFrequencyName(widget.controller.loanFreq));
            bool response=await Get.to(LoanRequestDetailScreen(
              isRequestBreakdown: false,
              bloc: bloc,
              isLoanApplication: true,
              loanRequests:loanrequest, controller: widget.controller,));
            if(response){
              widget.controller.clear();
              bloc.add(DoneApplicationEvent());
            }
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
          child: GestureDetector(
           onTap:  () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: AppColor.ucpWhite10,
              body: ListView(
              children: [
                Gap(110.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    UcpStrings.loanapplicationForm,
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack500
                    ),
                  ),
                ),
                Gap(20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height + 42.h,
                    width: 343.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UcpStrings.sLoanProductTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack600),
                        ),
                        height12,
                        CustomizedTextField(
                          readOnly: true,
                          textEditingController:    widget.controller.loanProductController,
                          hintTxt: UcpStrings.sLoanProductTxt,
                          keyboardType: TextInputType.name,
                          isTouched:    widget.controller.loanProductController.text.isNotEmpty,
                          surffixWidget: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: const Icon(Ionicons.chevron_down),
                          ),
                          onTap: () => _showLoanProductSelectionModal(),
                        ),
                        // height20,
                        Text(
                          UcpStrings.enterLoanAmount,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack600),
                        ),
                        height12,
                        CustomizedTextField(
                          prefixWidget: Visibility(
                              visible:    widget.controller.loanAmountController.text.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.w, right: 8.w),
                                child: Text(
                                  "NGN",
                                  style: CreatoDisplayCustomTextStyle
                                      .kTxtBold
                                      .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      color: AppColor.ucpBlack500),
                                ),
                              )),
                          inputFormat: [ThousandSeparatorFormatter(),],
                          isConfirmPasswordMatch: false,
                          keyboardType: TextInputType.number,
                          hintTxt: UcpStrings.enterLoanAmount,
                          isTouched:    widget.controller.loanAmountController.text.isNotEmpty,
                          textEditingController:    widget.controller.loanAmountController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          error: "",
                        ),
                        Text(
                          UcpStrings.loanDuration,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack600),
                        ),
                        height12,
                        CustomizedTextField(
                          readOnly: false,
                          textEditingController:    widget.controller.loanDurationController,
                          hintTxt: UcpStrings.loanDuration,
                          keyboardType: TextInputType.number,
                          isTouched:    widget.controller.loanDurationController.text.isNotEmpty,
                          // onTap: () => _showLoanProductSelectionModal(),
                        ),
                        Text(
                          UcpStrings.netMonthPay,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack600),
                        ),
                        height12,
                        CustomizedTextField(
                          prefixWidget: Visibility(
                              visible:    widget.controller.netMonthlyPayController.text.isNotEmpty,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.w, right: 8.w),
                                child: Text(
                                  "NGN",
                                  style: CreatoDisplayCustomTextStyle
                                      .kTxtBold
                                      .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      color: AppColor.ucpBlack500),
                                ),
                              )),
                          inputFormat: [ThousandSeparatorFormatter(),],
                          isConfirmPasswordMatch: false,
                          keyboardType: TextInputType.number,
                          hintTxt: UcpStrings.netMonthPay,
                          isTouched:    widget.controller.netMonthlyPayController.text.isNotEmpty,
                          textEditingController:    widget.controller.netMonthlyPayController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          error: "",
                        ),
                        Text(
                          UcpStrings.frequency,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack600),
                        ),
                        height12,
                        Container(
                          height: 51.h,
                          width: 343.w,
                          padding: EdgeInsets.only(left: 10.w),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColor.ucpWhite10,
                            border: Border.all(color:    widget.controller.loanFreq.isNotEmpty?AppColor.ucpBlue300:AppColor.ucpWhite10),
                          ),
                          child: Text(   widget.controller.loanFreq.isNotEmpty?getFrequencyName(   widget.controller.loanFreq):"Frequency",
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium
                                .copyWith(
                                fontSize: 14.sp,
                                color:AppColor.ucpBlack400,
                                fontWeight: FontWeight.w500,),
                                                  ),
                        ),
                        height12,
                        Text(
                          UcpStrings.loanInterestForProduct,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack600),
                        ),
                        height12,
                        CustomizedTextField(
                          readOnly: true,
                          isConfirmPasswordMatch: false,
                          keyboardType: TextInputType.number,
                          hintTxt: UcpStrings.loanInterestForProduct,
                          isTouched:    widget.controller.interestController.text.isNotEmpty,
                          textEditingController:    widget.controller.interestController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          error: "",
                        ),
                        Text(
                          UcpStrings.reasonForLoan,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack600),
                        ),
                        height12,
                        MultilineTextInput(
                          maxLines: 3,
                          hintText: 'Type your text here...',
                          hintStyle: TextStyle(fontSize: 16),
                          textStyle: TextStyle(fontSize: 16),
                          controller:    widget.controller.reasonForLoanController,
                          onChanged: (text) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
                            ),
            ),
          ),
        );
      },
    );
  }

  String getFrequencyName(String freq) {
    print("the frequency is $freq");
    for (var element in tempLoanFrequencies) {
      if (element.freqCode == freq) {
        return element.freqName!;
      }
    }
    return "";
  }
}

DateTime getOneMonthLater(DateTime inputDate) {
  return DateTime(
    inputDate.year,
    inputDate.month + 1,
    inputDate.day,
  );
}
