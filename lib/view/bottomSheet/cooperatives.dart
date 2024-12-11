import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ucp/data/model/response/cooperativeList.dart';
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
    return Scaffold(
      backgroundColor: AppColor.ucpWhite00,
      body: Column(
        children: [
          Container(
            height: 59.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            decoration: BoxDecoration(
              color: AppColor.ucpBlue50, //Color( 0xffEDF4FF),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.r),
                topLeft: Radius.circular(15.r),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                UcpStrings.sCooperativeTxt,
                style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: AppColor.ucpBlack500),
              ),
            ),
          ),
          height10,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                  height: 350.h,
                  child: ListView(
                      children: cooperativeList
                          .mapIndexed((element, index) =>
                          GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                    height: element.tenantName.length > 30
                                        ? 70.h
                                        : 48.h,
                                    margin: EdgeInsets.only(
                                        bottom: 14.h, left: 15.w, right: 15.w),
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
                              ))
                          .toList()),
                )
        ],
      ),
    );
  }
}
