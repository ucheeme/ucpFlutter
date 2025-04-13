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
import 'package:ucp/bloc/profile/profile_bloc.dart';
import 'package:ucp/data/model/request/addMemberBankDetailRequest.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/profile/profile.dart';


import '../../../../../data/model/response/listOfBankResponse.dart';
import '../../../../../data/model/response/memberData.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../../utils/sharedPreference.dart';
import '../../../../bottomSheet/SuccessNotification.dart';
import '../../../../bottomSheet/listOfBank.dart';

class AddBankDetailsMain extends StatefulWidget {
  MemberProfileData? memberProfileData;
   AddBankDetailsMain({super.key, this.memberProfileData});

  @override
  State<AddBankDetailsMain> createState() => _AddBankDetailsMainState();
}

class _AddBankDetailsMainState extends State<AddBankDetailsMain> {
  String bankName = "";
  String bankAccount = "";
  String accountName = "";
  TextEditingController bankController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bankAddressController = TextEditingController();
  late ProfileBloc bloc;
  ListOfBank? selectedBank;
  List<ListOfBank> bankList =[];
  MemberProfileData? memberProfileData;
  bool isEnable = false;
  @override
  void initState() {
    memberProfileData=widget.memberProfileData;
    bankList = tempBankList;
  WidgetsBinding.instance.addPostFrameCallback((_){

    if(widget.memberProfileData!=null){
      isEnable = false;
      setState(() {
        bankName = "${widget.memberProfileData?.bank}";
        bankAccount= "${widget.memberProfileData?.bankAccountNumber}";
        accountName = "${memberProfileData?.firstName} ${memberProfileData?.lastName}";
        memberProfileData = widget.memberProfileData;
        bankAddressController.text = "";
        nameController.text = "${memberProfileData?.firstName} ${memberProfileData?.lastName}";
        accountController.text = "${memberProfileData?.bankAccountNumber}";
        bankController.text = "${memberProfileData?.bank}";
      });
    }else{
      setState(() {
        isEnable = false;
      });

      if (tempBankList.isEmpty) {
        bloc.add(GetListOfBank());
      }
    }

  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc= BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    if (state is ProfileError) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        AppUtils.showSnack(state.errorResponse.message, context);
      });
      bloc.initial();
    }
    if(state is UcpBanks){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       bankList = state.response;
       tempBankList = bankList;
       _showBankListModal();
      });
      bloc.initial();
    }
    if (state is ProfileLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        memberProfileData = state.data;
        tempMemberProfileData = state.data;
        showCupertinoModalBottomSheet(
          topRadius: Radius.circular(15.r),
          backgroundColor: AppColor.ucpWhite500,
          context: context,
          builder: (context) {
            return Container(
              height: 400.h,
              color: AppColor.ucpWhite500,
              child: const LoadLottie(lottiePath: UcpStrings.ucpLottieSuccess1,
                bottomText:"Account Details Updated Successfully",
              ),
            );
          },
        ).then((value){
          Get.back(result: true);
          Get.back(result: true);
        });
      });
      bloc.initial();
    }
    if(state is MemberBankDetailsAdded){
      WidgetsBinding.instance.addPostFrameCallback((_){
        bloc.add(GetMemberProfileEvent());
      });
      bloc.initial();
    }
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: UCPLoadingScreen(
        visible: state is ProfileLoading,
        loaderWidget: LoadingAnimationWidget.discreteCircle(
          color: AppColor.ucpBlue500,
          size: 40.h,
          secondRingColor: AppColor.ucpBlue100,
        ),
        overlayColor: AppColor.ucpBlack400,
        transparency: 0.2,
        child: Scaffold(
          backgroundColor: AppColor.ucpWhite10,
          bottomSheet:  Container(
            height: 83.h,
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(
              color: AppColor.ucpBlue50,
            ),
            child: CustomButton(
              onTap: (){
                if(isEnable){
                  if(bankController.text.isNotEmpty
                      &&nameController.text.isNotEmpty
                      &&accountController.text.isNotEmpty){
                    bloc.add(AddMemberBankAccountDetails(
                        AddBankDetailRequest(
                          bank: selectedBank?.bankCode??"",
                          bankAccountNumber: bankAccount,
                          bankAccountName: bankName,
                          bankAddress: bankAddressController.text,
                        )
                    ));
                  }
                }else{
                  setState(() {
                    isEnable = true;
                  });
                }

              },
              height: 51.h,
              buttonText: "${UcpStrings.makeChangesTxt} ",
              borderRadius: 60.r,
              buttonColor:AppColor.ucpBlue500,
              textColor: AppColor.ucpWhite500,
            ),
          ),
          body:SizedBox(
            height: MediaQuery.of(context).size.height.h,
            child: ListView(
              padding:  EdgeInsets.symmetric(horizontal: 16.w,),
              children: [
                Gap(50.h),
                Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          if(tempMemberProfileData!=null){
                            Get.back(result: true);
                            Get.back(result: true);
                          }else {
                            Get.back();
                          }
                        },
                        child: Icon(Icons.arrow_back, size: 30.h,color: AppColor.ucpBlack500,)),
                    Gap(20.w),
                    Text(UcpStrings.memberProfileBankAccount,
                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                            .copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500)),
                  ],
                ),
                Gap(25.h),
                Container(
                  height: 160.h,
                  width: 343.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(UcpStrings.profileBaG))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Gap(20.h),
                      SizedBox(
                        height: 50.h,
                        width: 303.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 49.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(UcpStrings.bankNameTxt,
                                  style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                    color: AppColor.ucpWhite500,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400
                                  ),),
                                  Text(bankName,
                                    style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                        color: AppColor.ucpWhite500,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700
                                    ),),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: 49.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(UcpStrings.accountNumberTxt,
                                  style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                    color: AppColor.ucpWhite500,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400
                                  ),),
                                  Text(bankAccount,
                                    style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                        color: AppColor.ucpWhite500,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700
                                    ),),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(16.h),
                      SizedBox(
                        height: 50.h,
                        width: 303.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 49.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(UcpStrings.accountNameTxt,
                                  style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                    color: AppColor.ucpWhite500,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400
                                  ),),
                                  Text(accountName,
                                    style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                        color: AppColor.ucpWhite500,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700
                                    ),),

                                ],
                              ),
                            ),
                           Spacer()
                          ],
                        ),
                      ),
                      Gap(20.h),
                    ],
                  ),
                ),
                Gap(20.h),
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
                  isTouched: bankController.text.isNotEmpty,
                  textEditingController: bankController,
                  hintTxt: UcpStrings.sBankTxt,
                  keyboardType: TextInputType.name,
                  surffixWidget: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: const Icon(Ionicons.chevron_down),
                  ),
                  onTap: !isEnable ? null : () async {

                    if (tempBankList.isEmpty) {
                      bloc.add(GetListOfBank());
                    } else {
                      _showBankListModal();
                    }
                  },
                ),
                Text(
                  UcpStrings.accountNumberTxt,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                      .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500),
                ),
                height12,
                CustomizedTextField(
                  readOnly: !isEnable,
                  maxLength: 10,
                  onChanged: (val){
                    setState(() {
                      bankAccount=val;
                    });
                  },
                  isTouched: accountController.text.isNotEmpty,
                  textEditingController: accountController,
                  hintTxt: UcpStrings.accountNumberTxt,
                  keyboardType: TextInputType.number,
                ),
                Text(
                  UcpStrings.accountNameTxt,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                      .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500),
                ),
                height12,
                CustomizedTextField(
                  readOnly:  !isEnable,
                  onChanged: (val){
                    setState(() {
                      accountName=val;
                    });
                  },
                  isTouched: nameController.text.isNotEmpty,
                  textEditingController: nameController,
                  hintTxt: UcpStrings.accountNameTxt,
                  keyboardType: TextInputType.name,
                ),
                Text(
                  UcpStrings.bankAddressTxt,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                      .copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500),
                ),
                height12,
                CustomizedTextField(
                  readOnly: !isEnable,
                  onChanged: (val){
                    setState(() {

                    });
                  },
                  isTouched: bankAddressController.text.isNotEmpty,
                  textEditingController: bankAddressController,
                  hintTxt: UcpStrings.bankAddressTxt,
                  keyboardType: TextInputType.name,
                ),
              ],
            ),
          ) ,
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
        selectedBank=response;
        bankController.text = response.bankName;
       bankName = response.bankName;
      });
    }
  }

}
