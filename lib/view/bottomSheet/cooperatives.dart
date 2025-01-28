import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/data/model/response/cooperativeList.dart';
import 'package:ucp/data/model/response/loanProductResponse.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/appStrings.dart';

import '../../utils/colorrs.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableWidgets.dart';

class CooperativeListDesign extends StatefulWidget {
  List<CooperativeListResponse> cooperativeList;

  CooperativeListDesign({super.key, required this.cooperativeList});

  @override
  State<CooperativeListDesign> createState() => _CooperativeListDesignState();
}

class _CooperativeListDesignState extends State<CooperativeListDesign> {
  int? selectedIndex;
  TextEditingController searchController = TextEditingController();
  bool searchSelected = false;
  List<CooperativeListResponse> cooperativeList = [];
  CooperativeListResponse? selectedCooperative;
  searchCooperativeList(String value) {
    setState(() {
      cooperativeList = widget.cooperativeList
          .where((element) =>
              element.tenantName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      cooperativeList = cooperativeList;
    });
  }

  @override
  void initState() {
    cooperativeList = widget.cooperativeList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite500,
        body: Column(
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
                    // Icon(Icons.arrow_back ,size:18.h, color: AppColor.ucpBlack500),
                    // Gap(10.w),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
           cooperativeList.isEmpty
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

                        children: cooperativeList
                            .mapIndexed((element, index) =>
                            GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCooperative = element;
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                      height: element.tenantName.length > 30
                                          ? 70.h
                                          : 48.h,
                                      margin: EdgeInsets.only(
                                          bottom: 14.h, left: 16.w, right: 16.w),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12.h),
                                      decoration: BoxDecoration(
                                          color: (index == selectedIndex)
                                              ? AppColor.ucpBlue25
                                              : AppColor.ucpWhite500,
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: (index == selectedIndex)
                                                ? AppColor.ucpBlue500
                                                : AppColor.ucpWhite500,
                                          )),
                                      child: BottomsheetRadioButtonRightSide(
                                        radioText: element.tenantName,
                                        isMoreThanOne:
                                            element.tenantName.length > 30,
                                        isDmSans: false,
                                        isSelected: index == selectedIndex,
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                          });
                                        },
                                        textHeight: element.tenantName.length > 30
                                            ? 24.h
                                            : 16.h,
                                      )),
                                )
                        )
                            .toList()),
                  ),

            Container(
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
              Get.back(result: selectedCooperative);
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
  }
}



class LoanProductsLisDesign extends StatefulWidget {
  List<LoanProductList> loanProductList;
   LoanProductsLisDesign({super.key, required this.loanProductList});

  @override
  State<LoanProductsLisDesign> createState() => _LoanProductsLisDesignState();
}

class _LoanProductsLisDesignState extends State<LoanProductsLisDesign> {
  int? selectedIndex;
  TextEditingController searchController = TextEditingController();
  bool searchSelected = false;
  List<LoanProductList> loanProducts = [];
  LoanProductList? selectedCooperative;
  searchCooperativeList(String value) {
    setState(() {
      loanProducts = widget.loanProductList
          .where((element) =>
          element.productName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      loanProducts = loanProducts;
    });
  }

  @override
  void initState() {
    loanProducts = widget.loanProductList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                Get.back(result: selectedCooperative);
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
        backgroundColor: AppColor.ucpWhite500,
        body: Column(
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
                    // Icon(Icons.arrow_back ,size:18.h, color: AppColor.ucpBlack500),
                    // Gap(10.w),
                    Text(
                      UcpStrings.sLoanProductTxt,
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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            loanProducts.isEmpty
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

                  children: loanProducts
                      .mapIndexed((element, index) =>
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCooperative = element;
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                            height: element.productName.length > 30
                                ? 70.h
                                : 48.h,
                            margin: EdgeInsets.only(
                                bottom: 14.h, left: 16.w, right: 16.w),
                            padding:
                            EdgeInsets.symmetric(horizontal: 12.h),
                            decoration: BoxDecoration(
                                color: (index == selectedIndex)
                                    ? AppColor.ucpBlue25
                                    : AppColor.ucpWhite500,
                                borderRadius:
                                BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: (index == selectedIndex)
                                      ? AppColor.ucpBlue500
                                      : AppColor.ucpWhite500,
                                )),
                            child: BottomsheetRadioButtonRightSide(
                              radioText: element.productName,
                              isMoreThanOne:
                              element.productName.length > 30,
                              isDmSans: false,
                              isSelected: index == selectedIndex,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              textHeight: element.productName.length > 30
                                  ? 24.h
                                  : 16.h,
                            )),
                      )
                  )
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
