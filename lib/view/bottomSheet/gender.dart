import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/appStrings.dart';
import '../../utils/colorrs.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableWidgets.dart';
class GenderOptions extends StatefulWidget {
  const GenderOptions({super.key});

  @override
  State<GenderOptions> createState() => _GenderOptionsState();
}

class _GenderOptionsState extends State<GenderOptions> {
  bool isSelectedMale = false;
  bool isSelectedFemale = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ucpWhite00,
      bottomSheet:   GestureDetector(
        onTap: () {

          setState(() {
            isSelectedMale = false;
            isSelectedFemale=true;
          });
          Get.back(result: UcpStrings.femaleTxt,);
        },
        child: Container(
            height: 48.h,
            margin: EdgeInsets.only(
                bottom: 14.h, left: 15.w, right: 15.w),
            padding:
            EdgeInsets.symmetric(horizontal: 12.h),
            decoration: BoxDecoration(
                color: (isSelectedFemale)
                    ? AppColor.ucpBlue25
                    : AppColor.ucpWhite500,
                borderRadius:
                BorderRadius.circular(12.r),
                border: Border.all(
                  color: (isSelectedFemale)
                      ? AppColor.ucpBlue500
                      : AppColor.ucpWhite500,
                )),
            child: BottomsheetRadioButtonRightSide(
              radioText:UcpStrings.femaleTxt,
              isMoreThanOne:false,
              isDmSans: false,
              isSelected:  isSelectedFemale,
              onTap: () {
                setState(() {
                  isSelectedMale = false;
                  isSelectedFemale=true;
                });
              },
              textHeight: 16.h,
            )),
      ),
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
                UcpStrings.genderTxt,
                style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: AppColor.ucpBlack500),
              ),
            ),
          ),
          // height10,
          height30,
        GestureDetector(
          onTap: () {
            Get.back(result: UcpStrings.maleTxt,);
            setState(() {
              isSelectedMale = true;
              isSelectedFemale=false;
            });
          },
          child: Container(
              height: 48.h,
              margin: EdgeInsets.only(
                  bottom: 14.h, left: 15.w, right: 15.w),
              padding:
              EdgeInsets.symmetric(horizontal: 12.h),
              decoration: BoxDecoration(
                  color: (isSelectedMale)
                      ? AppColor.ucpBlue25
                      : AppColor.ucpWhite500,
                  borderRadius:
                  BorderRadius.circular(12.r),
                  border: Border.all(
                    color: (isSelectedMale)
                        ? AppColor.ucpBlue500
                        : AppColor.ucpWhite500,
                  )),
              child: BottomsheetRadioButtonRightSide(
                radioText:UcpStrings.maleTxt,
                isMoreThanOne:false,
                isDmSans: false,
                isSelected:  isSelectedMale,
                onTap: () {
                  setState(() {
                    isSelectedMale = true;
                  });
                },
                textHeight: 16.h,
              )),
        ),
          // GestureDetector(
          //   onTap: (){
          //     Get.back(result: UcpStrings.maleTxt,);
          //   },
          //   child: Container(
          //     height: 48.h,
          //     width: 347.w,
          //     padding: EdgeInsets.symmetric(horizontal: 10.w),
          //     decoration: BoxDecoration(
          //       color: AppColor.ucpWhite50,
          //       borderRadius: BorderRadius.circular(12.r),
          //     ),
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text(UcpStrings.maleTxt,
          //         style: CustomTextStyle.kTxtMedium.copyWith(
          //             fontSize: 14.sp,
          //             fontWeight: FontWeight.w400,
          //             color: AppColor.ucpBlack500
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          height20,



        ],
      ),
    );
  }
}
