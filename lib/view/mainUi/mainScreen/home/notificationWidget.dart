import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ucp/data/model/response/notificationResponse.dart';
import 'package:ucp/utils/colorrs.dart';

import '../../../../utils/constant.dart';

class NotificationWidgetDesign extends StatefulWidget {
  final UcpNotification notificationData;

  NotificationWidgetDesign({
    required this.notificationData,

    super.key});

  @override
  State<NotificationWidgetDesign> createState() => _NotificationWidgetDesignState();
}

class _NotificationWidgetDesignState extends State<NotificationWidgetDesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 90.h,
        width: double.infinity,

        padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 16.w),
        decoration: BoxDecoration(
            color:widget.notificationData.isRead?AppColor.ucpWhite500:AppColor.ucpWhite100,
            // color: Colors.blue,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColor.ucpWhite10)
        ),
        child: Row(
          children: [
            SizedBox(
              height: 68.h,
              width: 300.w,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(widget.notificationData.category??"",style: CustomTextStyle.kTxtBold.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: AppColor.ucpBlack500
                      ),),
                      Gap(8),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(widget.notificationData.createdOn.format('D, M j, H:i'),style: CustomTextStyle.kTxtRegular.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp,
                            color:AppColor.ucpBlack500
                        ),),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                    child: Text(widget.notificationData.message??"",style: CustomTextStyle.kTxtMedium.copyWith(
                      color: AppColor.ucpBlack500,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                      maxLines: 4,
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
