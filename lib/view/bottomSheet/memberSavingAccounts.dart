import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/bloc/dashboard/dashboard_bloc.dart';
import 'package:ucp/bloc/onboarding/onBoardingValidation.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/view/bottomSheet/paymentmodebottomsheet.dart';

import '../../data/model/response/memberSavingAccount.dart';
import '../../utils/appStrings.dart';
import '../../utils/colorrs.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableFunctions.dart';
import '../../utils/designUtils/reusableWidgets.dart';

class MemberSavingAccountsBottomSheets extends StatefulWidget {
   MemberSavingAccountsBottomSheets({super.key});

  @override
  State<MemberSavingAccountsBottomSheets> createState() => _MemberSavingAccountsBottomSheetsState();
}

class _MemberSavingAccountsBottomSheetsState extends State<MemberSavingAccountsBottomSheets> {
  int selectedindex = 0;

  TextEditingController searchController = TextEditingController();
  bool searchSelected = false;
  List<UserSavingAccounts> savingAccounts = [];
  UserSavingAccounts? selectedSavingAccount;
  searchCooperativeList(String value) {
    setState(() {
      savingAccounts = tempSavingAccounts
          .where((element) =>
          element.accountProduct.toLowerCase().contains(value.toLowerCase()))
          .toList();
      savingAccounts = savingAccounts;
    });
  }
  late DashboardBloc bloc;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(tempSavingAccounts.isNotEmpty){
        setState(() {
          savingAccounts = tempSavingAccounts;
        });

      }else{
      bloc.add(GetMemberSavingAccounts());
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<DashboardBloc>(context);
    return  BlocBuilder<DashboardBloc, DashboardState>(
  builder: (context, state) {
    if(state is MemberAccounts){
      WidgetsBinding.instance.addPostFrameCallback((_){
        tempSavingAccounts = state.response;
          savingAccounts = state.response;
      });
      //savingAccounts = state.response;
      bloc.initial();
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite500,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
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
                          onTap: (){
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back ,size: 28.h, color: AppColor.ucpBlack500)),
                      Gap(10.w),
                      Text(
                        UcpStrings.sMemberAccountTxt,
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
              state is DashboardIsLoading?
              const Center(child: CircularProgressIndicator(color: AppColor.ucpBlue50,)):
                  SizedBox(
                    height: 480.h,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: SizedBox(
                            height: 51.h,
                            child: CupertinoSearchTextField(
                              controller: searchController,
                              placeholder: UcpStrings.searchTxt,
                              placeholderStyle: CustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.ucpBlack500),
                              onSubmitted: (value) {
                                setState(() {
                                  searchSelected = false;
                                });
                              },
                              onChanged: searchCooperativeList,
                              decoration: BoxDecoration(
                                color: AppColor.ucpWhite500,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                    color: searchSelected
                                        ? AppColor.ucpBlue500
                                        : AppColor.ucpWhite100),
                              ),
                              onTap: () {
                                setState(() {
                                  searchSelected = true;
                                });
                              },
                            ),
                          ),
                        ),
                        height20,
                        savingAccounts.isEmpty
                            ? SizedBox(
                          height: 250.h,
                          child: Center(
                            child: Text(
                              "${UcpStrings.noAvaliableTxt} Account",
                              style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack500),
                            ),
                          ),
                        )
                            : SizedBox(
                          height: 250.h,
                          child: ListView(
                              children: savingAccounts
                                  .mapIndexed((element, index) =>
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSavingAccount = element;
                                        selectedindex = index;
                                      });
                                    },
                                    child: Container(
                                        height: element.accountProduct.length > 30
                                            ? 70.h
                                            : 48.h,
                                        margin: EdgeInsets.only(
                                            bottom: 14.h, left: 15.w, right: 15.w),
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 12.h),
                                        decoration: BoxDecoration(
                                            color: (index == selectedindex)
                                                ? AppColor.ucpBlue25
                                                : AppColor.ucpWhite500,
                                            borderRadius:
                                            BorderRadius.circular(12.r),
                                            border: Border.all(
                                              color: (index == selectedindex)
                                                  ? AppColor.ucpBlue500
                                                  : AppColor.ucpWhite500,
                                            )),
                                        child: BottomsheetRadioButtonRightSide(
                                          radioText: "${formatFirstTitle(element.accountProduct)} - ${element.accountNumber}",
                                          isMoreThanOne:
                                          element.accountProduct.length > 30,
                                          isDmSans: false,
                                          isSelected: index == selectedindex,
                                          onTap: () {
                                            setState(() {
                                              selectedindex = index;
                                            });
                                          },
                                          textHeight: element.accountProduct.length > 30
                                              ? 24.h
                                              : 16.h,
                                        )),
                                  ))
                                  .toList()),
                        ),
                        height24,
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
                                saveToAccountRequest?.accountNumber= selectedSavingAccount!.accountNumber;
                           //  Get.back();
                                _showUserAccountModal();
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

            ],
          ),
        ),
      ),
    );
  },
);
  }
  Future<void> _showUserAccountModal() async {
    await showCupertinoModalBottomSheet(
      topRadius: Radius.circular(15.r),
      backgroundColor: AppColor.ucpWhite500,
      context: context,
      builder: (context) {
        return Container(
          height: 500.h,
          color: AppColor.ucpWhite500,
          child:PaymentModeBottomSheet(),
        );
      },
    );
  }
}
