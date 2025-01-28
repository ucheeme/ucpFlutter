import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/sharedPreference.dart';

import '../../data/model/response/listOfBankResponse.dart';
import '../../utils/appStrings.dart';
import '../../utils/colorrs.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableWidgets.dart';

class ListofbankBottomSheet extends StatefulWidget {
  List<ListOfBank> banks;
   ListofbankBottomSheet({super.key,required this.banks});

  @override
  State<ListofbankBottomSheet> createState() => _ListofbankBottomSheetState();
}

class _ListofbankBottomSheetState extends State<ListofbankBottomSheet> {
  int selectedindex = 0;

  TextEditingController searchController = TextEditingController();
  bool searchSelected = false;
  List<ListOfBank> listOfBank = [];
  ListOfBank? selectedBank;
  searchCooperativeList(String value) {
    setState(() {
      listOfBank = widget.banks
          .where((element) =>
          element.bankName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      listOfBank = listOfBank;
    });
  }
  @override
  void initState() {
    listOfBank = widget.banks;
    selectedBank = listOfBank[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite500,
        bottomSheet:   Container(
            height: 83.h,
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.ucpBlue50,     //Color( 0xffEDF4FF),
              // borderRadius: BorderRadius.only(
              //   bottomRight: Radius.circular(15.r),
              //   bottomLeft: Radius.circular(15.r),
              // ),
            ),
            child: CustomButton(
              onTap: () {
                saveToAccountRequest?.bank=selectedBank!.bankCode;
                Get.back(result: selectedBank);
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
        body: SingleChildScrollView(
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
                      Icon(Icons.arrow_back ,size: 28.h, color: AppColor.ucpBlack500),
                      Gap(10.w),
                      Text(
                        UcpStrings.sCooperativeTxt,
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
              listOfBank.isEmpty
                  ? SizedBox(
                height: 250.h,
                child: Center(
                  child: Text(
                    UcpStrings.emptyCoopTxt,
                    style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack500),
                  ),
                ),
              )
                  : SizedBox(
                height: 270.h,
                child: ListView(
                    children: listOfBank
                        .mapIndexed((element, index) =>
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBank = element;
                              selectedindex = index;
                            });
                          },
                          child: Container(
                              height: element.bankName.length > 30
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
                                radioText: element.bankName,
                                isMoreThanOne:
                                element.bankName.length > 30,
                                isDmSans: false,
                                isSelected: index == selectedindex,
                                onTap: () {
                                  setState(() {
                                    selectedindex = index;
                                  });
                                },
                                textHeight: element.bankName.length > 30
                                    ? 24.h
                                    : 16.h,
                              )),
                        ))
                        .toList()),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
