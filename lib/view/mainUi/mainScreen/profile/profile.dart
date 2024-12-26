import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:super_profile_picture/super_profile_picture.dart';
import 'package:ucp/bloc/profile/profile_bloc.dart';
import 'package:ucp/data/model/response/memberData.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/home/withdraw.dart';
import 'package:ucp/view/mainUi/mainScreen/profile/profileWidget.dart';

import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../errorPages/underConstruction.dart';
MemberProfileData? tempMemberProfileData;
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc bloc;
  MemberProfileData memberProfileData=MemberProfileData();
@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_){
    if(tempMemberProfileData!=null){
      memberProfileData = tempMemberProfileData!;
    }else{
      bloc.add(GetMemberProfileEvent());
    }

  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(state.errorResponse.message, context);
          });
          bloc.initial();
        }
        if (state is ProfileLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            memberProfileData = state.data;
            tempMemberProfileData = state.data;
          });
          bloc.initial();
        }
        return UCPLoadingScreen(
          visible: state is ProfileLoading,
          loaderWidget: LoadingAnimationWidget.discreteCircle(
            color: AppColor.ucpBlue500,
            size: 40.h,
            secondRingColor: AppColor.ucpBlue100,
          ),
          overlayColor: AppColor.ucpBlack400,
          transparency: 0.2,
          child: Scaffold(
              extendBodyBehindAppBar: true,
              extendBody: true,
              body: Stack(
                children: [
                  ListView(
                    children: [
                      Gap(90.h),
                      SizedBox(
                        height: 299.h, width: 343.w,
                        child: Center(
                          child: Stack(
                            children: [
                              Image.asset(UcpStrings.profileBaG,),
                              Positioned(
                                top: 40.h,
                                bottom: 50.h,
                                 left: 20,
                                 right: 20,

                                child: SizedBox(
                                  height: 235.h,
                                  width: 311.w,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 85.h,
                                        width: 85.w,
                                        child: SuperProfilePicture(
                                          label: "",
                                          radius: 30,
                                          image: AssetImage(
                                            UcpStrings.tempImage,),

                                        ),
                                      ),
                                      height14,
                                      SizedBox(
                                        height: 110.h,
                                        width: 211.w,
                                        child: Column(
                                          children: [
                                            Text("${memberProfileData?.firstName} ${memberProfileData?.lastName}",
                                              style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                              fontWeight: FontWeight.w500,
                                                fontSize: 20.sp,
                                                color: AppColor.ucpWhite500
                                            )),
                                            Text(memberProfileData!.email??"no email",
                                              style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                              fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                                color: AppColor.ucpWhite50
                                            )),
                                            Text(memberProfileData!.phone??"no phone number",
                                              style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                              fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                                color: AppColor.ucpWhite50
                                            )),
                                            Text(memberProfileData!.employeeId??"no phone number",
                                              style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                                              fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                                color: AppColor.ucpWhite50
                                            )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      height20,
                      Container(
                        // height: 656.h,
                        width: 343.w,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColor.ucpWhite500
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: profileData.mapIndexed((element,index)=>
                            GestureDetector(
                              onTap:()=>cta(index),
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    height16,
                                    ProfileListDesign(profileDataValue: element),
                                    height16,
                                    Visibility(
                                        visible: index!=profileData.length-1,
                                        child: Divider(color: AppColor.ucpBlue50,)),
                                  ],
                                ),
                              ),
                            )).toList()
                          ),
                        ),
                      )
                    ],
                  ),
                  UCPCustomAppBar(
                      height: 93.h,
                      appBarColor: AppColor.ucpWhite10.withOpacity(0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          height30,
                          Row(
                            children: [
                              Text(UcpStrings.profileTxt,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.ucpBlack500),
                              )
                            ],
                          ),
                        ],
                      )),
                ],
              )
          ),
        );
      },
    );
  }
  cta(int index){
  switch(index){
    case 0:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
    case 1:
      Get.to(WithdrawScreen(),curve: Curves.easeIn);
      break;
    case 2:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
    case 3:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
    case 4:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
    case 5:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
      case 6:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
      case 7:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
      case 8:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
      case 9:
      Get.to( UnderMaintenanceScreen(),curve: Curves.easeIn);
      break;
  }
  }
}
