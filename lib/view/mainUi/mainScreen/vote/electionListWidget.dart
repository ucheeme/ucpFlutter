import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/constant.dart';

import '../../../../data/model/response/electionDetailResponse.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';

class ElectionItemWithCandidate extends StatefulWidget {
  ElectionDetails details;
   ElectionItemWithCandidate({super.key, required this.details});

  @override
  State<ElectionItemWithCandidate> createState() => _ElectionItemWithCandidateState();
}

class _ElectionItemWithCandidateState extends State<ElectionItemWithCandidate> {
  @override
  Widget build(BuildContext context) {

    return  Container(
      height: 200.h,
      width: 343.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color:  AppColor.ucpWhite500,

      ),
      child: Row(
        children: [
          SideWidget(details: widget.details,),
          CandidatesImage(details: widget.details,)
        ],
      ),
    );
  }
}
class SideWidget extends StatefulWidget {
  ElectionDetails details;
   SideWidget({super.key,required this.details});

  @override
  State<SideWidget> createState() => _SideWidgetState();
}

class _SideWidgetState extends State<SideWidget> {
  String hoursString = "";
  String daysString = "";
  String minutesString = "";
  String secondsString = "";
  String remainingTime ="";
  bool isPassed =false;
  bool isOn =true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      remainingTime =formatTime(endDateS: widget.details.endDateAndTime.toIso8601String(),
      startDateS: widget.details.startDateAndTime.toIso8601String());
    });
    super.initState();
  }
   formatTime({String endDateS="", String startDateS=""}) {
     final DateTime startDate = DateTime.parse(startDateS);
     final DateTime endDate = DateTime.parse(endDateS);

     // Timer to update every second.
     Timer.periodic(const Duration(seconds: 1), (Timer timer) {
       final DateTime now = DateTime.now();

       if (now.isBefore(startDate)) {
         // Current time is before the start date.
         setState(() {
           isPassed =false;
           isOn =false;
           remainingTime =dateFormat(startDate);
         });
         print("Event has not started yet. Starts on: ${dateFormat(startDate)}");
       }
       if (now.isAfter(endDate)) {
         // Current time is after the end date.
         setState(() {
           isPassed =true;
           isOn =false;
           remainingTime =dateFormat(endDate);
         });
        // print("Event ended on: ${dateFormat(endDate)}");
         timer.cancel();
       } else {
         // Current time is between start and end dates.
         final Duration remaining = endDate.difference(now);
         final int days = remaining.inDays;
         final int hours = remaining.inHours % 24;
         final int minutes = remaining.inMinutes % 60;
         final int seconds = remaining.inSeconds % 60;
         final String countdown = "${days}d ${hours}h ${minutes}m ${seconds}s";
         setState(() {
           isPassed =false;
           isOn =true;
           remainingTime = countdown;
         });
       }
     });

    //  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190.h,
      width: 189.w,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 11.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20.h,
              width: 155.w,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                color: AppColor.ucpOrange50,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 12.h,
                    width: 12.w,
                    child: Image.asset(UcpStrings.ucpTimer),
                  ),
                  Gap(3.34.w),
                  Text(checks(),
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    color: AppColor.ucpBlack600,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp
                  ),
                  ),
                  Gap(3.34.w),
                  Text(remainingTime,
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        color: checksColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp
                    ),
                  )
                ],
              ),
            ),
            Gap(37.h),
            SizedBox(
              height: 87.h,
              width: 175.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.details.title,
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        color: AppColor.ucpBlack500,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp
                    ),
                  ),

                  Row(
                    children: [
                      SizedBox(
                        height: 16.h,
                        width: 16.w,
                        child: Image.asset(UcpStrings.ucpGroup),
                      ),
                      Gap(3.34.w),
                      Text("${widget.details.contestants.length} Candidates",
                        style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            color: AppColor.ucpBlack800,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  String checks(){
    if(!isPassed&&!isOn){
      return "Starts on";
    }
    if(!isPassed&&isOn) {
      return "Closes in";
    }
    if (isPassed&&!isOn) {
      return "Closed on";
    }
    return "";
  }
  Color checksColor(){
    if(!isPassed&&!isOn){
      return AppColor.ucpSuccess50;
    }
    if(!isPassed&&isOn) {
      return AppColor.ucpOrange400;
    }
    if (isPassed&&!isOn) {
      return AppColor.ucpDanger150;
    }
    return Colors.transparent;
  }
}

class CandidatesImage extends StatefulWidget {
  ElectionDetails details;
   CandidatesImage({super.key,required this.details});

  @override
  State<CandidatesImage> createState() => _CandidatesImageState();
}

class _CandidatesImageState extends State<CandidatesImage> {
  int itemCount = 0;
  @override
  void initState() {

    print("iiiiii,,${widget.details.contestants.length}");
    if(widget.details.contestants.length>4){
      itemCount = 4;
    }else{
      itemCount = widget.details.contestants.length;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height:190.h,
      width: 150.w,
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        children: List.generate(itemCount, (index) {
          final Uint8List imageBytes = base64Decode(widget.details.contestants[index].profileImageBase64);
          print("I an");
          // If the total item count is odd and this is the last item, span 2 columns.
          final int span = (itemCount % 2 == 1 && index == itemCount - 1) ? 2 : 1;
          return StaggeredGridTile.count(
            crossAxisCellCount: span,
            mainAxisCellCount: 1,
            child: Container(
              height:76.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.details.contestants[index].image.isEmpty?null:AppColor.ucpBlue500,
                image: DecorationImage(image: MemoryImage(imageBytes),
                fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        }),
      ),

    );
  }
}
