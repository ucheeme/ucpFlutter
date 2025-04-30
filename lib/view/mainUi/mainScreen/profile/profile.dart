import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:super_profile_picture/super_profile_picture.dart';
import 'package:ucp/bloc/dashboard/dashboard_bloc.dart';
import 'package:ucp/bloc/onboarding/onBoardingValidation.dart';
import 'package:ucp/bloc/profile/profile_bloc.dart';
import 'package:ucp/data/model/response/memberData.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/customValidator.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/retirement/retirementScreen.dart';
import 'package:ucp/view/mainUi/mainScreen/home/withdraw.dart';
import 'package:ucp/view/mainUi/mainScreen/profile/profileWidget.dart';
import 'package:ucp/view/mainUi/mainScreen/profile/support.dart';
import 'package:ucp/view/mainUi/mainScreen/shop/itemsInCart.dart';
import 'package:ucp/view/mainUi/mainScreen/vote/eligiblePosition.dart';
import 'package:ucp/view/onboardingSplash/splashScreen.dart';

import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../errorPages/underConstruction.dart';
import '../../bottomNav.dart';
import '../../onBoardingFlow/loginFlow/loginD.dart';
import 'EditProfile.dart';
import 'bankdetails/addBankDetails.dart';
import 'changePassword.dart';
import 'contributions.dart';
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
    if(bioMetric){
      setState(() {
        isBiometric = true;
      });
    }
    if(tempMemberProfileData!=null){
      setState(() {
        memberProfileData = tempMemberProfileData!;
      });
    }else{
      bloc.add(GetMemberProfileEvent());
   }
  });
    super.initState();
  }
bool isBiometric = false;
bool isPushNotification = false;
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
            //memberImageResponse?.profileImage=state.data.profileImage??"";
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
            backgroundColor: AppColor.ucpWhite10,
              extendBodyBehindAppBar: true,
              extendBody: true,
              body: Stack(
                children: [
                  ListView(
                    children: [
                      Gap(100.h),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.w,),
                        child: Container(
                         // height: 174.h,
                          width: 243.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: tempMemberProfileData?.profileImage!=null?
                                  NetworkImage(tempMemberProfileData!.profileImage!)
                                      :AssetImage(UcpStrings.profileBaG))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              height20,
                              Container(
                                height: 70.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image:
                                      memberImageResponse==null?
                                  AssetImage(UcpStrings.tempImage):
                                  NetworkImage(
                                     memberImageResponse?.profileImage??"",
                                  )

                                  )
                                ),
                              ),
                              // height14,
                              SizedBox(
                                height: 112.h,
                               // width: 211.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${memberProfileData.firstName??""} ${memberProfileData.lastName??""}",
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
                                width: 343.w,
                                child: Column(
                                  children: [
                                    height8,
                                    ProfileListDesign(
                                      onTap: (){
                                        if(element.isToggle){
                                          setState(() {
                                            if(index==1){
                                              isBiometric=!isBiometric;
                                              isBiometricEnabled=isBiometric;
                                              MySharedPreference.enableBiometric(isBiometric);
                                            }else if(index==6){
                                              isPushNotification=!isPushNotification;
                                            }
                                          });
                                        }
                                      },
                                      profileDataValue: element,
                                      isToggle:chooseOpinion(index),),
                                    height8,
                                    Visibility(
                                        visible: index!=profileData.length-1,
                                        child: Divider(color: AppColor.ucpBlue50,)),
                                  ],
                                ),
                              ),
                            )).toList()
                          ),
                        ),
                      ),
                      SizedBox(height: 100.h,),
                    ],
                  ),
                  UCPCustomAppBar(
                      height: 93.h,
                      appBarColor: AppColor.ucpWhite10,
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
  bool chooseOpinion(int index){
    if(index==1){
      return isBiometric;
    }else if(index==6){
      return isPushNotification;
    }else{
      return false;
    }
  }
  cta(int index) async {
  switch(index){
    case 0:
      Get.to( EditProfileScreen(),curve: Curves.easeIn);
      break;
    // case 1:
    //  // Get.to(WithdrawScreen(),curve: Curves.easeIn);
    //   break;
    // case 2:
    //  // Get.to(RetirementScreen(),curve: Curves.easeIn);
    //   break;
    case 1: null;
      break;
    case 2:
      Get.to( ChangePasswordScreen(),curve: Curves.easeIn);
      break;
    case 3:
      Get.to( ContributionScreen(),curve: Curves.easeIn);
      break;
      case 4:
      Get.to(MemberBankDetailScreen(),curve: Curves.easeIn);
      break;
      case 5:
      Get.to(SupportScreen(),curve: Curves.easeIn);
      break;
      case 6:null;
      break;
      case 7: {
        bool response=  await showSlidingModalLogOut(context);
        if (response) {
          tempBankList.clear();
          tempMemberProfileData = null;
          tempTransactionList.clear();
          tempMemberAccounts.clear();
          tempLoansGuarantors.clear();
          tempLoanFrequencies.clear();
          tempLoanProducts.clear();
          tempMemberSavingAccounts.clear();
          tempPaymentModes.clear();
          accessToken = "";
          tempAccounts.clear();
          tempMemberSavingHistory.clear();
          tempRetirementHistory.clear();
          tempWithdrawTransactionHistory.clear();
          tempPositionEligibleList.clear();
          tempItemInCart.clear();
          tempPassword="";
          purchasedSummaryListTemp.clear();
          firstNameTemp = "";
          Get.offAll(LoginFlow(), predicate: (route) => false);
         // setState(() {});
        }
      }

      break;
  }
  }
}
