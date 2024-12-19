import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/bloc/dashboard/dashboard_bloc.dart';
import 'package:ucp/data/model/response/listOfBankResponse.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/view/bottomSheet/listOfBank.dart';

import '../../utils/appStrings.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableFunctions.dart';
import '../../utils/designUtils/reusableWidgets.dart';

class MakeDeposit extends StatefulWidget {
  ScrollController? scrollController;
   MakeDeposit({super.key, this.scrollController});

  @override
  State<MakeDeposit> createState() => _MakeDepositState();
}

class _MakeDepositState extends State<MakeDeposit> {
  TextEditingController bankController = TextEditingController();
  TextEditingController bankAcctController = TextEditingController();
  TextEditingController bankTellerController = TextEditingController();
  TextEditingController datePaidController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  String tellerName = "No file selected";
  late DashboardBloc bloc;
  List<ListOfBank> bankList = [];
  @override
  void initState() {
    print("I am ${saveToAccountRequest?.modeOfpayment}");
 WidgetsBinding.instance.addPostFrameCallback((_) {
   if(tempBankList.isEmpty) {
     bloc.add(GetListOfBank());
   }else{
     setState(() {
       bankList = tempBankList;
     });
   }
 });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DashboardBloc>(context);
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is UcpBanks) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            bankList= state.response;
            tempBankList = state.response;
          });
          bloc.initial();
        }
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            controller: widget.scrollController,
            physics: NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                controller: widget.scrollController,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 59.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.ucpBlue25, //Color( 0xffEDF4FF),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.r),
                        topLeft: Radius.circular(15.r),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: ()=>Get.back(),
                              child: Icon(Icons.arrow_back ,size: 28.h, color: AppColor.ucpBlack500)),
                          Gap(10.w),
                          Text(
                            UcpStrings.sMakePaymentTxt,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: AppColor.ucpBlack500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  height10,
                  Visibility(
                    visible: saveToAccountRequest?.modeOfpayment == "2"? true : false,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              UcpStrings.sBankTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                            height12,
                            CustomizedTextField(
                              readOnly: true,
                              textEditingController: bankController,
                              hintTxt: UcpStrings.sBankTxt,
                              keyboardType: TextInputType.name,
                              surffixWidget: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: const Icon(Ionicons.chevron_down),
                              ),
                              onTap: () async {
                                if (tempBankList.isEmpty) {
                                  bloc.add(GetListOfBank());
                                } else {
                                  _showBankListModal();
                                }
                              },
                            ),
                            Text(
                              UcpStrings.sEnterBankAccountTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                            height12,
                            CustomizedTextField(
                              readOnly: false,
                              maxLength: 10,
                              textEditingController: bankAcctController,
                              hintTxt: UcpStrings.sEnterBankAccountTxt,
                              keyboardType: TextInputType.number,
                            ),
                            Text(
                              UcpStrings.sEnterBankTellTxt,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                            height12,
                            CustomizedTextField(
                              readOnly: false,
                              textEditingController: bankTellerController,
                              hintTxt: UcpStrings.sEnterBankTellTxt,
                              keyboardType: TextInputType.name,
                            ),
                            Text(
                              UcpStrings.datePaidText,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                            height12,
                            CustomizedTextField(
                              readOnly: true,
                              textEditingController: datePaidController,
                              hintTxt: UcpStrings.datePaidText,
                              keyboardType: TextInputType.datetime,
                              surffixWidget: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child:  Icon(Ionicons.calendar,size: 24.h,color: AppColor.ucpBlue500,),
                              ),
                              onTap: () async {
                                DateTime?response= await selectDate(datePaidController, context: context);
                                if (response != null) {
                                  setState(() {
                                    datePaidController.text = response.format("Y-m-d");
                                    saveToAccountRequest?.paidDate = response.format("Y-m-d");
                                  });
                                }
                              },
                            ),
                            Text(
                              UcpStrings.uploadTellerText,
                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                  .copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                            height12,
                            CustomizedTextField(
                              readOnly: true,
                              textEditingController: fileNameController,
                              hintTxt: UcpStrings.uploadTellerText,
                              keyboardType: TextInputType.datetime,
                              surffixWidget: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Icon(Icons.upload_file,size: 24.h,color: AppColor.ucpBlue500,),
                              ),
                              onTap: () async {
                                DateTime?response= await selectDate(datePaidController, context: context);
                                if (response != null) {
                                  setState(() {
                                    datePaidController.text = response.format("Y-m-d");
                                    saveToAccountRequest?.paidDate = response.format("Y-m-d");
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      )),
                  height30,
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      UcpStrings.decriptionTxt,
                      style: CreatoDisplayCustomTextStyle.kTxtMedium
                          .copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.ucpBlack500),
                    ),
                  ),
                  height12,
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w),
                    child: MultilineTextInput(
                      maxLines: 8,
                      hintText: 'Type your text here...',
                      hintStyle: TextStyle(fontSize: 16),
                      textStyle: TextStyle(fontSize: 16),
                      controller: TextEditingController(),
                      onChanged: (text) {
                        print('Text changed: $text');
                      },
                    ),
                  ),
                  height30,
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
                         // Get.back(result: selectedBank);
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
          ),
        );
      },
    );
  }
 _showBankListModal() async {
    ListOfBank? response=  await showCupertinoModalBottomSheet(
      topRadius: Radius.circular(15.r),
      backgroundColor: AppColor.ucpWhite500,
      context: context,
      builder: (context) {
        return Container(
          height: 500.h,
          color: AppColor.ucpWhite500,
          child:ListofbankBottomSheet(banks: bankList),
        );
      },
    );
    if(response !=null){
      print(response.bankName);
      setState(() {
        bankController.text = response.bankName;
        saveToAccountRequest?.bank = response.bankName!;
      });
    }
  }
}
