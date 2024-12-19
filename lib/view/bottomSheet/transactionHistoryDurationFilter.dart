import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/appExtentions.dart';

import '../../utils/appStrings.dart';
import '../../utils/colorrs.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableWidgets.dart';

class FilterDurationBottomSheet extends StatefulWidget {
  const FilterDurationBottomSheet({super.key});

  @override
  State<FilterDurationBottomSheet> createState() => _FilterDurationBottomSheetState();
}

class _FilterDurationBottomSheetState extends State<FilterDurationBottomSheet> {
  int? selectedIndex;
  List<int> durations =[3,6,12,24,36,48,60];
   @override
  void initState() {
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite50,
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
              height20,
               SizedBox(
                height: 270.h,
                child: ListView(
                    children: durations
                        .mapIndexed((element, index) =>
                        GestureDetector(
                          onTap: () {
                            setState(() {

                              selectedIndex = index;
                            });
                          },
                          child: Container(
                              height: 48.h,
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
                                radioText:"${element} ${UcpStrings.monthsTxt}",
                                isMoreThanOne:false,
                                isDmSans: false,
                                isSelected: index == selectedIndex,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                textHeight: 24.h,
                              )),
                        ))
                        .toList()),
              ),
              CustomButton(
                onTap: () {
                  Get.back(result: durations[selectedIndex!]);
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

              )
            ],
          ),
        ),
      ),
    );
  }
}