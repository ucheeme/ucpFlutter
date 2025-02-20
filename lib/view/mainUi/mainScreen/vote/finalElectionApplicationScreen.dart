import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';

class FinalElectionInFomation extends StatefulWidget {
  const FinalElectionInFomation({super.key});

  @override
  State<FinalElectionInFomation> createState() => _FinalElectionInFomationState();
}

class _FinalElectionInFomationState extends State<FinalElectionInFomation> {
  bool isApplyPosition = true;
  bool isAllElection = false;
  bool isElectionResult = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ucpWhite10,
      body: Stack(
       children: [
         SizedBox(
           child: ListView(
             padding: EdgeInsets.symmetric(horizontal: 16.w),
             children: [
               Gap(160.h),
               Text(
                 "Your application",
                 style: CreatoDisplayCustomTextStyle.kTxtMedium
                     .copyWith(
                     fontSize: 16.sp,
                     fontWeight: FontWeight.w500,
                     color: AppColor.ucpBlack500),
               ),
               //height12,
               Container(
                 height: 202.h,
                 width: 343.w,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(12.r),
                     topRight: Radius.circular(12.r),),
                   image: const DecorationImage(image: AssetImage(UcpStrings.sampleImageOne), fit: BoxFit.cover),
                 ),
               ),
               height20,
               Text(
                 "Mikael Jackson",
                 style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                   fontWeight: FontWeight.w500,
                   fontSize: 24.sp,
                   color: AppColor.ucpBlack500,
                 )
               ),
               Container(
                 height: 600.h,
                 child: SfPdfViewer.network("https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf"),
               )
             ],
           ),
         ),
         UCPCustomAppBar(
             height: MediaQuery.of(context).size.height*0.18,
             appBarColor:AppColor.ucpBlue25,
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Gap(20.h),
                   Text(
                    "Voting",
                     style: CreatoDisplayCustomTextStyle.kTxtMedium
                         .copyWith(
                         fontSize: 16.sp,
                         fontWeight: FontWeight.w500,
                         color: AppColor.ucpBlack500),
                   ),
                   height14,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Container(
                         height: 40.h,
                         width: 343.w,
                         padding: EdgeInsets.symmetric(
                             horizontal: 8.w, vertical: 5.h),
                         decoration: BoxDecoration(
                           color: AppColor.ucpBlue25,
                           borderRadius: BorderRadius.circular(40.r),
                         ),
                         child: Row(
                           children: [
                             GestureDetector(
                               onTap: () {
                                 setState(() {
                                   isApplyPosition = true;
                                   isAllElection = false;
                                   isElectionResult = false;
                                 });
                               },
                               child: AnimatedContainer(
                                 height: 33.h,
                                 width: 137.w,
                                 padding: EdgeInsets.symmetric(horizontal: 5.w),
                                 decoration: BoxDecoration(
                                   color: isApplyPosition
                                       ? AppColor.ucpBlue100
                                       : Colors.transparent,
                                   border: Border.all(color:isApplyPosition
                                       ?  AppColor.ucpBlue500 : Colors.transparent),
                                   borderRadius:
                                   BorderRadius.circular(12.r),
                                 ),
                                 duration:
                                 const Duration(milliseconds: 500),
                                 child: Center(
                                   child: Text(
                                     UcpStrings.applyForAPositionTxt,
                                     style: CreatoDisplayCustomTextStyle
                                         .kTxtMedium
                                         .copyWith(
                                       fontSize: 14.sp,
                                       color: isApplyPosition
                                           ? AppColor.ucpBlack500
                                           : AppColor.ucpBlack700,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                             GestureDetector(
                               onTap: () {
                                 setState(() {
                                   isApplyPosition = false;
                                   isAllElection = true;
                                   isElectionResult = false;
                                 });
                               },
                               child: AnimatedContainer(
                                 duration:
                                 const Duration(milliseconds: 400),
                                 height: 32.h,
                                 width: 84.w,
                                 decoration: BoxDecoration(
                                   color: isAllElection
                                       ? AppColor.ucpBlue600
                                       : Colors.transparent,
                                   borderRadius:
                                   BorderRadius.circular(40.r),
                                 ),
                                 child: Center(
                                   child: Text(
                                     UcpStrings.elcetionTxt,
                                     style: CreatoDisplayCustomTextStyle
                                         .kTxtMedium
                                         .copyWith(
                                       fontSize: 14.sp,
                                       color: isAllElection
                                           ? AppColor.ucpWhite500
                                           : AppColor.ucpBlack800,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                             GestureDetector(
                               onTap: () {
                                 setState(() {
                                   isApplyPosition = false;
                                   isAllElection = false;
                                   isElectionResult = true;
                                 });
                               },
                               child: AnimatedContainer(
                                 duration:
                                 const Duration(milliseconds: 500),
                                 height: 32.h,
                                 width: 90.w,
                                 decoration: BoxDecoration(
                                   color: isElectionResult
                                       ? AppColor.ucpBlue600
                                       : Colors.transparent,
                                   borderRadius:
                                   BorderRadius.circular(40.r),
                                 ),
                                 child: Center(
                                   child: Text(
                                     UcpStrings.resultEText,
                                     style: CreatoDisplayCustomTextStyle
                                         .kTxtMedium
                                         .copyWith(
                                       fontSize: 14.sp,
                                       color: isElectionResult
                                           ? AppColor.ucpWhite500
                                           : AppColor.ucpBlack800,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             )),

        ]
      ),
    );
  }
  // ImageProvider<Object> imageValue() {
  //   if(true){
  //     return  NetworkImage(userDetails!.profilePic!,);
  //   }else if(selectedImage != null){
  //     return FileImage(selectedImage!);
  //   }else{
  //     return const AssetImage("assets/image/images_png/tempImage.png");
  //   }
  // }
}
