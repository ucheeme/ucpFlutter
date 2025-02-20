import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../data/model/response/allElections.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../finances/loan/repaymentWidgetRefund.dart';
class ElectionPositionWidget extends StatefulWidget {
  PositionEligible positionEligibleList;
  ElectionPositionWidget({super.key, required this.positionEligibleList});

  @override
  State<ElectionPositionWidget> createState() => _ElectionPositionWidgetState();
}

class _ElectionPositionWidgetState extends State<ElectionPositionWidget> {
  Color borderColor = Color(0xFFF6911E);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      //width: 343.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColor.ucpWhite500,
      ),
      child: Row(
        children: [
          Container(
            height: 35.h,
            width: 35.w,
            decoration: BoxDecoration(
              border: Border.all(color:borderColor.withOpacity(0.5), width: 2.w),
              shape: BoxShape.circle,
              color: getRandomColor(),
            ),
            child: Center(
              child: Text(
                generateThreeLetterCode(widget.positionEligibleList.positionName),
                style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.ucpWhite500),
              ),
            ),
          ),
          Gap(10.w),
          SizedBox(
            height: 50.33.h,
            width: 245.w,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 21.h,
                    child: Text(widget.positionEligibleList.positionName,style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack500
                    ),),
                  ),
                  Gap(6.h),
                  Row(
                    children: [
                      Container(
                        height: 20.33.h,
                        width: 50.33.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color:AppColor.ucpOrange100,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 7.h,
                              width: 7.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:AppColor.ucpOrange500
                              ),
                            ),
                            Gap(3.33.w),
                            Text("Free",
                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.ucpBlack800
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(12.w),
                      Text(formatDate(widget.positionEligibleList.electionStartDate.toIso8601String())
                        ,style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                         fontSize: 14.sp, fontWeight: FontWeight.w400,
                            color: AppColor.ucpBlack700),),
                    ],
                  ),
                  // SizedBox(
                  //   height: 20.h,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(" months",style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                  //           fontSize: 14.sp,
                  //           fontWeight: FontWeight.w400,
                  //           color: AppColor.ucpBlack700
                  //       ),),
                  //
                  //     ],
                  //   ),
                  // ),
                ]),
          ),
          Icon(Icons.arrow_forward_ios,color: AppColor.ucpBlack500,size: 18.w,)
        ],
      ),
    );
  }

  Color getRandomColor() {
    List<Color> colors = [
      Color(0xFFF6911E), // Orange
      Color(0xFF1985B3), // Blue
      Color(0xFF0452C8), // Dark Blue
    ];

    Random random = Random();
    Color randomColor = colors[random.nextInt(colors.length)];
    setState(() {
      borderColor=randomColor;
    });

    return randomColor;
  }
}

String generateThreeLetterCode(String input) {
  // Extract uppercase letters from the input string
  List<String> uppercaseLetters = input.replaceAll(RegExp(r'[^A-Z]'), '').split('');

  // If there are at least 3 uppercase letters, return the first 3
  if (uppercaseLetters.length >= 3) {
    return uppercaseLetters.sublist(0, 3).join();
  }

  // If there are less than 3 uppercase letters, fill with first available lowercase vowels
  List<String> vowels = input.split('').where((char) => 'aeiouAEIOU'.contains(char)).toList();

  List<String> result = List.from(uppercaseLetters);

  for (var vowel in vowels) {
    if (result.length < 3) {
      result.add(vowel.toUpperCase()); // Convert vowels to uppercase
    }
  }

  // If still less than 3, fill with any remaining letters
  if (result.length < 3) {
    List<String> remainingChars = input.replaceAll(RegExp(r'[^a-zA-Z]'), '').split('');
    for (var char in remainingChars) {
      if (result.length < 3) {
        result.add(char.toUpperCase());
      }
    }
  }

  // Ensure exactly 3 characters are returned
  return result.take(3).join();
}
