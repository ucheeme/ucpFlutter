import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/utils/designUtils/reusableWidgets.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/profile/profile.dart';

import '../../../../../bloc/profile/profile_bloc.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import 'addBankMainDetails.dart';

class MemberBankDetailScreen extends StatefulWidget {
  const MemberBankDetailScreen({super.key});

  @override
  State<MemberBankDetailScreen> createState() => _MemberBankDetailScreenState();
}

class _MemberBankDetailScreenState extends State<MemberBankDetailScreen> {
  late ProfileBloc bloc;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(tempMemberProfileData==null){
        bloc.add(GetMemberProfileEvent());
      }else{
        Get.to(AddBankDetailsMain(memberProfileData: tempMemberProfileData));
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
        body:SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w,),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back, size: 30.h,color: AppColor.ucpBlack500,)),
                    Gap(20.w),
                    Text(UcpStrings.memberProfileBankAccount,
                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                            .copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500)),
                  ],
                ),
              ),
              Gap(193.h),
              Center(
                child: SizedBox(
                  height: 275.h,
                  width: 343.w,
                  child: Column(
                    children: [
                      Image.asset(UcpStrings.noBankAcctIcon,height: 126.h,width: 115.w,),
                      Gap(30.h),
                      Text(UcpStrings.noBankAcctTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.ucpBlack500)),
                      Gap(30.h),
                      CustomButton(
                          onTap: (){
                            Get.to(AddBankDetailsMain());
                          },
                          height: 51.h,
                          textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpWhite500,
                          ),
                          buttonColor: AppColor.ucpBlue600,
                          borderRadius: 25.r,
                          buttonText: "Add Bank Account")
                    ],
                  ),
                ),
              )
            ],
          ),
        ) ,
      ),
    );
  },
);
  }
}
