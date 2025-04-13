import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ucp/view/mainUi/mainScreen/vote/ElectionApplicationFormScreen.dart';
import 'package:http/http.dart' as http;
import '../../../../utils/appStrings.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';

class FinalElectionInFomation extends StatefulWidget {
  String contestantName;
   FinalElectionInFomation({super.key, required this.contestantName});

  @override
  State<FinalElectionInFomation> createState() => _FinalElectionInFomationState();
}

class _FinalElectionInFomationState extends State<FinalElectionInFomation> {
  bool isApplyPosition = true;
  bool isAllElection = false;
  bool isElectionResult = false;
  bool isLoading = true;
  Uint8List? transparentImageBytes;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      final result = await BackgroundRemover.instance.removeBg(
        contestantProfileImage!.readAsBytesSync(),
      );
      ByteData? byteData=await result.toByteData(format: ImageByteFormat.png);
      print("this is value: ${byteData?.buffer.asUint8List()}");
      print("this is value: ${await result.toByteData()}");
      print("this is value: $result");
      setState(() {
        transparentImageBytes = byteData?.buffer.asUint8List();
        isLoading = false;
      });
    });
    super.initState();
    BackgroundRemover.instance.initializeOrt();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ucpWhite10,
      body: Stack(
       children: [
         isLoading? const Center(
           child: CircularProgressIndicator(
             color: AppColor.ucpBlue500,
           ),
         ):
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
               // Stack(
               //   children: [
               //     Container(
               //       height: 202.h,
               //       width: 343.w,
               //       decoration: BoxDecoration(
               //         borderRadius: BorderRadius.only(
               //           topLeft: Radius.circular(12.r),
               //           topRight: Radius.circular(12.r),),
               //         image:  const DecorationImage(image:AssetImage(UcpStrings.contestanctBG), fit: BoxFit.cover),
               //       ),
               //
               //     ),
               //     Container(
               //       height: 202.h,
               //       width: 343.w,
               //       decoration: BoxDecoration(
               //         borderRadius: BorderRadius.only(
               //           topLeft: Radius.circular(12.r),
               //           topRight: Radius.circular(12.r),),
               //         image:  DecorationImage(image: contestantProfileImage==null?AssetImage(UcpStrings.sampleImageOne):
               //         MemoryImage(transparentImageBytes!),
               //             fit: BoxFit.contain),
               //       ),
               //     )
               //   ],
               // ),
               Container(
                 height: 202.h,
                 width: 343.w,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(12.r),
                     topRight: Radius.circular(12.r),),
                   image:  DecorationImage(image: contestantProfileImage==null?const AssetImage(UcpStrings.sampleImageOne):
                   FileImage(contestantProfileImage!),
                       fit: BoxFit.cover),
                 ),
               ),
               height20,
               Text(
                 widget.contestantName,
                 style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                   fontWeight: FontWeight.w500,
                   fontSize: 24.sp,
                   color: AppColor.ucpBlack500,
                 )
               ),
               Container(
                 height: 400.h,
                 color: Colors.transparent,
                 child: SfPdfViewer.file(contestantsManifesto!),
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
                                 Get.back();
                                 Get.back();
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
