import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ucp/utils/CustomToggleButton.dart';
import 'package:ucp/utils/appStrings.dart';

import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';

class ProfileDataValue{
  String title;
  String image;
  bool isToggle;
  ProfileDataValue({required this.title,required this.image,required this.isToggle});
}

List<ProfileDataValue> profileData =[
  ProfileDataValue(title:profileDataString[0], image:UcpStrings.ucpEditProfileImage, isToggle: false),
  ProfileDataValue(title:profileDataString[1], image:UcpStrings.ucpWithdrawProfileImage, isToggle: false),
  ProfileDataValue(title:profileDataString[2], image:UcpStrings.ucpRetirementProfileImage, isToggle: false),
  ProfileDataValue(title:profileDataString[3], image:UcpStrings.ucpBiometericProfileImage, isToggle: true),
  ProfileDataValue(title:profileDataString[4], image:UcpStrings.ucpChangePasswordProfileImage, isToggle: false),
  ProfileDataValue(title:profileDataString[5], image:UcpStrings.ucpContributionProfileImage, isToggle: false),
  ProfileDataValue(title:profileDataString[6], image:UcpStrings.ucpBankAcctProfileImage, isToggle: false),
  ProfileDataValue(title:profileDataString[7], image:UcpStrings.ucpSupportProfileImage, isToggle: false),
  ProfileDataValue(title:profileDataString[8], image:UcpStrings.ucpPushNotProfileImage, isToggle: true),
  ProfileDataValue(title:profileDataString[9], image:UcpStrings.ucpLogOut, isToggle: false),
];
class ProfileListDesign extends StatefulWidget {
  ProfileDataValue profileDataValue;
   ProfileListDesign({super.key,required this.profileDataValue});

  @override
  State<ProfileListDesign> createState() => _ProfileListDesignState();
}

class _ProfileListDesignState extends State<ProfileListDesign> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 40.h,
      width: 303.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(

              child: Row(
                children: [
                  Image.asset(widget.profileDataValue.image,height: 40.h,width: 40.w,),
                 Gap(8.w),
                  Text(widget.profileDataValue.title,
                      style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: AppColor.ucpBlack500
                      )),
                ],
              )),
          widget.profileDataValue.isToggle?
              CustomToggleSwitch(value: false):
          SizedBox(
            height: 20.h,
            width: 20.w,
            child: ColoredBox(
              color: Colors.transparent,
              child: Image.asset(
                UcpStrings.ucpArrowForward,
                height: 20.h,
                width: 20.w,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

