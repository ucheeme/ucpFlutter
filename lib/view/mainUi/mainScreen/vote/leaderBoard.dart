import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/constant.dart';

import '../../../../utils/appStrings.dart';

class LeaderboardScreen extends StatelessWidget {
  List<Map<String, dynamic>> rankData =
  [
    {"rank": 1, "name": "Precious Akinnukawe", "votes": 2345, "color": AppColor.ucpOrange200, "borderColor": AppColor.ucpOrange500},
    {"rank": 2, "name": "Precious Akinnukawe", "votes": 1990, "color": AppColor.ucpLightBlue200, "borderColor": AppColor.ucpLightBlue600},
    {"rank": 3, "name": "Prosper Kawe", "votes": 1492, "color": AppColor.ucpBlue200, "borderColor": AppColor.ucpBlue500},
    {"rank": 4, "name": "Ezekiel Hassan", "votes": 1089, "color": AppColor.ucpSuccess100.withOpacity(0.3), "borderColor": AppColor.ucpSuccess100},
    {"rank": 5, "name": "Ezekiel Hassan", "votes": 30, "color": AppColor.ucpCSK200, "borderColor": AppColor.ucpCSK500},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w,),
        height: Get.height-80.h,
        child: SingleChildScrollView(
          child: Column(
          
            children: [
               Gap(40.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Image.asset(
                          UcpStrings.ucpBackArrow,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                    ),
                  ),
                  Gap(12.w),
                  Text( "Election results",
                    style: CreatoDisplayCustomTextStyle.kTxtMedium
                        .copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack500),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildWinnerColumn('assets/images/image1.png', '1st', AppColor.ucpOrange500, 243.h),
                  Gap(17.w),
                  _buildWinnerColumn('assets/images/image2.png', '2nd', AppColor.ucpLightBlue600, 181.h),
                  Gap(17.w),
                  _buildWinnerColumn('assets/images/image3.png', '3rd', AppColor.ucpBlue500,150.h),
                ],
              ),
              SizedBox(height: 20),
              // Leaderboard List
              Column(children:    rankData.mapIndexed((element,index) {
                return _buildRankItem(
                  element["rank"],
                  element["name"],
                  element["votes"],
                  element["color"],
                  borderColor: element["borderColor"],
                );
              }).toList(), ),
          
              // Expanded(
              //   child: ListView(
              //     padding: EdgeInsets.zero,
              //     children: [
              //       _buildRankItem(1, 'Precious Akinnukawe', 2345, AppColor.ucpOrange200, borderColor: AppColor.ucpOrange500),
              //       _buildRankItem(2, 'Precious Akinnukawe', 1990, AppColor.ucpLightBlue200,borderColor: AppColor.ucpLightBlue600),
              //       _buildRankItem(3, 'Prosper Kawe', 1492, AppColor.ucpBlue200,borderColor: AppColor.ucpBlue500),
              //       _buildRankItem(4, 'Ezekiel Hassan', 1089, AppColor.ucpSuccess100.withOpacity(0.3),borderColor: AppColor.ucpSuccess100),
              //       _buildRankItem(5, 'Ezekiel Hassan', 30, AppColor.ucpCSK200,borderColor: AppColor.ucpCSK500),
              //     ],
              //   ),
              // ),
              Gap(50.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  positionBar(100.w, AppColor.ucpOrange500, '100'),
                  Gap(4.w),
                  positionBar(80.w, AppColor.ucpLightBlue600, '80'),
                  Gap(4.w),
                  positionBar(60.w, AppColor.ucpBlue600, '50'),
                  Gap(4.w),
                  positionBar(40.w, AppColor.ucpSuccess150, '1000'),
                  Gap(4.w),
                  positionBar(30.w, AppColor.ucpCSK600, 'Others'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget positionBar(double width, Color color,String numberOfVote){
    return SizedBox(
      height: 25.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10.h,
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Text(numberOfVote,style: CreatoDisplayCustomTextStyle.kTxtRegular
              .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w400),)
        ],
      ),
    );
  }

  Widget _buildWinnerColumn(String image, String position, Color color, double height) {
    return Column(
      children: [
        Visibility(
            visible: position == '1st',
            child: Image.asset("assets/images/crown.png",height: 34.h,width: 60.w,)),
        Container(
          height: height,
          width: 91.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:  EdgeInsets.all(4.w),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(image),
                ),
              ),

              Text(
                position,
                style: CustomTextStyle.kTxtBold.copyWith(
                    fontSize: 40.sp, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem(int rank, String name, int votes, Color color,{Color? borderColor}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding:rank == 1? EdgeInsets.zero:EdgeInsets.only(left: 10.w) ,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), bottomLeft: Radius.circular(12.r)),
      ),
      child: Row(
      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          rank == 1?Container(
            width: 44.87.w,
            height: 50.h,
            margin: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), bottomLeft: Radius.circular(12.r)),),
          ):const SizedBox.shrink(),
          Container(
            width:rank == 1?280.w:320.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                  visible: rank!=1,
                  child:  Text.rich(
                    TextSpan(
                      text: "$rank", // Main number
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.aboveBaseline,
                          baseline: TextBaseline.alphabetic,
                          child: Text(
                            getOrdinalSuffix(rank), // Superscript suffix
                            style: TextStyle(fontSize: 12, fontFeatures: [FontFeature.superscripts()], color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                Gap(8.w),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/image${rank}.png'),
                ),
                SizedBox(width: 10),
                Text(
                   name ,
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                Spacer(),

                Text('$votes votes', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Spacer(),
          Container(
            width: 5.w,
            height: 50.h,
            color: borderColor,
          )
        ],
      ),
    );
  }
  String getOrdinalSuffix(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) return "th";
    switch (number % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

}
