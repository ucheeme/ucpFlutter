import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/bloc/finance/finance_bloc.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';

import '../../../../../data/model/response/cooperativeList.dart';
import '../../../../../data/model/response/loanProductResponse.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../bottomSheet/cooperatives.dart';

class ApplyForLoan extends StatefulWidget {

  ApplyForLoan({super.key,});

  @override
  State<ApplyForLoan> createState() => _ApplyForLoanState();
}

class _ApplyForLoanState extends State<ApplyForLoan> {
  late FinanceBloc bloc;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String loanFrequency = "";
      String loanProduct = "";
    });
    super.initState();
  }
  final loanAmountController = TextEditingController();
  final reasonForLoanController = TextEditingController();
  final loanProductController = TextEditingController();
  final netMonthlyPayController = TextEditingController();
  final loanDurationController = TextEditingController();
  final frequencyController = TextEditingController();
  String loanProduct ="";
  String loanDuration="";

  Future<void> _showLoanProductSelectionModal() async {
    LoanProductList? response = await showCupertinoModalBottomSheet(
      topRadius: Radius.circular(15.r),
      backgroundColor: AppColor.ucpWhite500,
      context: context,
      builder: (context) {
        return Container(
          height: 485.h,
          color: AppColor.ucpWhite500,
          child: LoanProductsLisDesign(loanProductList: tempLoanProducts),
        );
      },
    );

    if (response != null) {
      setState(() {
        loanProductController.text = response.productName;
     loanProduct = response.productCode;
      });
      // bloc.validation.setCooperative(response);
    }
  }


  @override
  Widget build(BuildContext context) {
    bloc=BlocProvider.of<FinanceBloc>(context);
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
            body: ListView(
              children: [
                Gap(110.h),
                Padding(
                  padding:  EdgeInsets.only(left: 16.w),
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
                    height: MediaQuery.of(context).size.height,
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
                          textEditingController: loanProductController,
                          hintTxt: UcpStrings.sLoanProductTxt,
                          keyboardType: TextInputType.name,
                           isTouched: loanProductController.text.isNotEmpty,
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
                          isTouched: loanAmountController.text.isNotEmpty,
                          textEditingController: loanAmountController,
                          onChanged:(value){
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
                          textEditingController: loanDurationController,
                          hintTxt: UcpStrings.loanDuration,
                          keyboardType: TextInputType.name,
                          isTouched: loanDurationController.text.isNotEmpty,
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
                            visible:netMonthlyPayController.text.isNotEmpty,
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
                          isTouched: netMonthlyPayController.text.isNotEmpty,
                          textEditingController: netMonthlyPayController,
                          onChanged:(value){
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
                        CustomizedTextField(
                          prefixWidget: Visibility(
                              visible:frequencyController.text.isNotEmpty,
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
                          hintTxt: UcpStrings.frequency,
                          isTouched: frequencyController.text.isNotEmpty,
                          textEditingController: frequencyController,
                          onChanged:(value){
                            setState(() {});
                          },
                          error: "",
                        ),

                      ],
                    ),
                  ),
                ),
                Container(
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
                        // Get.back(result: selectedCooperative);
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
