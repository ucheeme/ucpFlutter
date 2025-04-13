import 'package:date_time_format/date_time_format.dart';
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
import 'package:ucp/bloc/dashboard/dashboard_bloc.dart';
import 'package:ucp/data/model/response/listOfBankResponse.dart';
import 'package:ucp/data/repository/profileRepo.dart';
import 'package:ucp/utils/apputils.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/bottomSheet/listOfBank.dart';
import 'package:ucp/view/bottomSheet/webViewScreen.dart';

import '../../data/model/request/saveToAccount.dart';
import '../../utils/appStrings.dart';
import '../../utils/cameraOption.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableFunctions.dart';
import '../../utils/designUtils/reusableWidgets.dart';
import 'SuccessNotification.dart';

class MakeDeposit extends StatefulWidget {
  ScrollController? scrollController;
  String title = "Make Deposit";
  PaymentRequest? paymentRequest;
  bool isFromSavings =false;
   MakeDeposit({super.key, this.scrollController,this.paymentRequest,
     required this.title, required this.isFromSavings,
   });

  @override
  State<MakeDeposit> createState() => _MakeDepositState();
}

class _MakeDepositState extends State<MakeDeposit> {
  TextEditingController bankController = TextEditingController();
  TextEditingController bankAcctController = TextEditingController();
  TextEditingController bankTellerController = TextEditingController();
  TextEditingController datePaidController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
        if (state is DashboardError) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            Get.back();
            Get.back();
            AppUtils.showInfoSnack(state.errorResponse.message, context);
          });
          bloc.initial();
        }
        if (state is UcpBanks) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            bankList= state.response;
            tempBankList = state.response;
          });
          bloc.initial();
        }
        if(state is PaymentSuccessState){
          WidgetsBinding.instance.addPostFrameCallback((_){
            if(state.response.payStackResponse!=null){
              _stepSlide(state.response.payStackResponse!.authorizationUrl);
            }else{
              showSuccessAlert(context);
            }
          });
          bloc.initial();
        }
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: UCPLoadingScreen(
            visible:  state is DashboardIsLoading,
            loaderWidget: LoadingAnimationWidget.discreteCircle(
              color: AppColor.ucpBlue500,
              size: 40.h,
              secondRingColor: AppColor.ucpBlue100,
            ),
            overlayColor: AppColor.ucpBlack400,
            transparency: 0.2,
            child: Scaffold(
              backgroundColor: AppColor.ucpWhite10,
              bottomSheet:   Container(
                  height: 83.h,
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: const BoxDecoration(
                    color: AppColor.ucpBlue50,     //Color( 0xffEDF4FF),
                    // borderRadius: BorderRadius.only(
                    //   bottomRight: Radius.circular(15.r),
                    //   bottomLeft: Radius.circular(15.r),
                    // ),
                  ),
                  child: CustomButton(
                    onTap: () {
                      if(saveToAccountRequest?.modeOfpayment == "2"){
                        if(bankController.text.isEmpty){
                          AppUtils.showInfoSnack("Please select bank",context,);
                        }else if(bankAcctController.text.isEmpty){
                          AppUtils.showInfoSnack( "Please enter bank account number",context);
                        }else if(bankTellerController.text.isEmpty){
                          AppUtils.showInfoSnack( "Please enter bank teller name",context);
                        }else if(datePaidController.text.isEmpty){
                          AppUtils.showInfoSnack("Please select date paid",context,);
                        }else if(fileNameController.text.isEmpty){
                          AppUtils.showInfoSnack("Please select file",context,);
                        }else{
                          if(widget.isFromSavings){
                            bloc.add(MakePaymentEvent(createPaymentRequest()));
                          }else{
                            // saveToAccountRequest.description=descriptionController.text;
                            // saveToAccountRequest.bankAccountNumber=bankAcctController.text;
                            // saveToAccountRequest.bankTeller=bankController.text;
                            // saveToAccountRequest.paidDate=datePaidController.text;
                            // saveToAccountRequest.bankTeller=bankTellerController.text;
                            // ucpFilePath = fileNameController.text;
                            Get.back(result: [saveToAccountRequest, true]);
                          }
                        }
                      }else{
                        if(widget.isFromSavings){
                          bloc.add(MakePaymentEvent(createPaymentRequest()));
                        }else{
                          // saveToAccountRequest.description=descriptionController.text;
                          // saveToAccountRequest.bankAccountNumber=bankAcctController.text;
                          // saveToAccountRequest.bankTeller=bankController.text;
                          // saveToAccountRequest.paidDate=datePaidController.text;
                          // saveToAccountRequest.bankTeller=bankTellerController.text;
                          // ucpFilePath = fileNameController.text;
                          Get.back(result: [saveToAccountRequest, true]);
                        }

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
              appBar: AppBar(
                backgroundColor: AppColor.ucpWhite500,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Get.back();
                  },
                ),
                title: Text(
                  widget.title,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColor.ucpBlack500),
                ),
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  //physics: NeverScrollableScrollPhysics(),
                  controller: widget.scrollController,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   height: 59.h,
                    //   width: double.infinity,
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 16.w,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: AppColor.ucpBlue25, //Color( 0xffEDF4FF),
                    //     borderRadius: BorderRadius.only(
                    //       topRight: Radius.circular(15.r),
                    //       topLeft: Radius.circular(15.r),
                    //     ),
                    //   ),
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Row(
                    //       children: [
                    //         // GestureDetector(
                    //         //     onTap: ()=>Get.back(),
                    //         //     child: Icon(Icons.arrow_back ,size: 28.h, color: AppColor.ucpBlack500)),
                    //         // Gap(10.w),
                    //         Text(
                    //           UcpStrings.sMakePaymentTxt,
                    //           style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    //               fontWeight: FontWeight.w500,
                    //               fontSize: 16.sp,
                    //               color: AppColor.ucpBlack500),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                                  List<dynamic>response= await showCupertinoModalBottomSheet(
                                      topRadius:
                                      Radius.circular(20.r),
                                      context: context,
                                      backgroundColor:AppColor.ucpWhite500,
                                      shape:RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(24.r),topLeft: Radius.circular(24.r)),
                                      ),
                                      builder: (context) => SizedBox(
                                          height: 313.h,
                                          child: CameraOption())
                                  );
                                  if(response[1]!=null){
                                    print("This is image ${response[1]}");
                                    setState(() {
                                      fileNameController.text = response[0].toString();
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
                        maxLines: 2,
                        hintText: 'Type your text here...',
                        hintStyle: TextStyle(fontSize: 16),
                        textStyle: TextStyle(fontSize: 16),
                        controller:descriptionController,
                        onChanged: (text) {
                          saveToAccountRequest.description = text;
                        },
                      ),
                    ),
                   SizedBox(height: 100.h,)

                  ],
                ),
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
        saveToAccountRequest.bank = response.bankCode!;
      });
    }
  }

  PaymentRequest createPaymentRequest() {
    return PaymentRequest(
        amount: widget.paymentRequest?.amount??saveToAccountRequest.amount,
        modeOfpayment: widget.paymentRequest?.modeOfpayment??saveToAccountRequest.modeOfpayment,
        description: widget.paymentRequest?.description??saveToAccountRequest.description,
        accountNumber: widget.paymentRequest?.accountNumber??saveToAccountRequest.accountNumber,
        bank: widget.paymentRequest?.bank??saveToAccountRequest.bank,
        bankAccountNumber: bankAcctController.text.trim(),
        bankTeller:bankTellerController.text,
        paidDate:  saveToAccountRequest.paidDate);
  }
  _stepSlide(String url) async {
    FocusManager.instance.primaryFocus?.unfocus();
    bool response = await  showCupertinoModalBottomSheet(
        isDismissible: true,
        enableDrag: false,
        elevation: 20.h,
        topRadius:
        Radius.circular(10.r),
        context: context,
        builder: (context) => SafeArea(
          bottom: true,
          child: Stack(
              children:[
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                    ),
                    child: Icon(Icons.close, color: AppColor.ucpDanger150,),
                  ),
                ),
                SizedBox(
                    height: 700.h,
                    child: WebViewScreen(url: url,)
                ),

              ]
          ),
        )
    );


  }
}
launchPaystack(String url,context) async {
  FocusManager.instance.primaryFocus?.unfocus();
  bool response = await  showCupertinoModalBottomSheet(
      isDismissible: true,
      enableDrag: false,
      elevation: 20.h,
      topRadius:
      Radius.circular(10.r),
      context: context,
      builder: (context) => SafeArea(
        bottom: true,
        child: Stack(
            children:[
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black
                  ),
                  child: Icon(Icons.close, color: AppColor.ucpDanger150,),
                ),
              ),
              SizedBox(
                  height: 700.h,
                  child: WebViewScreen(url: url,)
              ),

            ]
        ),
      )
  );


}
showSuccessAlert(context){
  showCupertinoModalBottomSheet(
    topRadius: Radius.circular(15.r),
    backgroundColor: AppColor.ucpWhite500,
    context: context,
    builder: (context) {
      return Container(
        height: 400.h,
        color: AppColor.ucpWhite500,
        child: LoadLottie(lottiePath: UcpStrings.ucpLottieSuccess1,
          bottomText: "Payment Successful",
        ),
      );
    },
  ).then((value){
    Get.back(result: true);
  });
}