import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:super_profile_picture/super_profile_picture.dart';
import 'package:ucp/bloc/profile/profile_bloc.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/profile/profile.dart';


import '../../../../bloc/dashboard/dashboard_bloc.dart' as dashboard;
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/cameraOption.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../bottomSheet/SuccessNotification.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ProfileBloc bloc;
@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_){
    bloc.validation.fullNameController.text = "${tempMemberProfileData?.firstName} "
        "${tempMemberProfileData?.otherName} ${tempMemberProfileData?.lastName} ";
    bloc.validation.emailController.text = "${tempMemberProfileData?.email}";
    bloc.validation.phoneController.text = "${tempMemberProfileData?.phone}";
    bloc.validation.addressController.text = "${tempMemberProfileData?.residentState}, ${tempMemberProfileData?.residentCountry}";
    bloc.validation.setFullName(  bloc.validation.fullNameController.text);
    bloc.validation.setEmail(  bloc.validation.emailController.text);
    bloc.validation.setPhoneNumber(  bloc.validation.phoneController.text);
    bloc.validation.setAddress(  bloc.validation.addressController.text);
    bloc.validation.memberController.text ="Member 0001";
    bloc.validation.setMember(bloc.validation.memberController.text);
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
        if(state is MemberImageState){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            dashboard.memberImageResponse = state.response;
            showCupertinoModalBottomSheet(
              topRadius: Radius.circular(15.r),
              backgroundColor: AppColor.ucpWhite500,
              context: context,
              builder: (context) {
                return Container(
                  height: 400.h,
                  color: AppColor.ucpWhite500,
                  child: const LoadLottie(lottiePath: UcpStrings.ucpLottieSuccess1,
                    bottomText: "Profile Updated Successfully",
                  ),
                );
              },
            ).then((value){
              Get.back(result: true);
            });
          });
          bloc.initial();
        }
        if(state is ProfileUpdated){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            bloc.add(GetMemberImage());
          });
          bloc.initial();
        }
        return GestureDetector(
          onTap: ()=> FocusScope.of(context).unfocus(),
          child: UCPLoadingScreen(
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
              bottomSheet: StreamBuilder<Object>(
                stream: bloc.validation.completeEditProfileValidation,
                builder: (context, snapshot) {
                  return Container(
                      height: 83.h,
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: const BoxDecoration(
                        color: AppColor.ucpBlue50,
                      ),
                      child: CustomButton(
                        onTap:snapshot.hasData? () {
                          bloc.add(UpdateProfileEvent(bloc.validation.updateProfileRequest()));
                        }:(){},
                        borderRadius: 30.r,
                        buttonColor: snapshot.hasData?AppColor.ucpBlue500:AppColor.ucpBlue300,
                        buttonText: UcpStrings.saveChangesTxt,
                        height: 51.h,
                        textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: AppColor.ucpWhite500,
                        ),
                        textColor: AppColor.ucpWhite500,
                      )
                  );
                }
              ),
              body: Stack(
                children: [
                  ListView(
                    children: [
                      Gap(100.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          height: 197.h,
                          width: 343.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(UcpStrings.profileBaG))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 100.h,
                                width: 104.w,
                                child: SuperProfilePicture(
                                  border: Border.all(
                                      color: AppColor.ucpBlue100, width: 2.w),
                                  label: "",
                                  radius: 30.r,
                                  image:profileImage()
                                ),
                              ),
                              height8,
                              GestureDetector(
                                onTap: ()async{
                                  List<dynamic>response= await showCupertinoModalBottomSheet(
                                      topRadius:
                                      Radius.circular(20.r),
                                      context: context,
                                      backgroundColor:AppColor.ucpWhite500,
                                      shape:RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(24.r),topLeft: Radius.circular(24.r)),
                                      ),
                                      builder: (context) => SizedBox(
                                          height: 313.h,
                                          child: CameraOption())
                                  );
                                  if(response[1]!=null){
                                    print("This is image ${response[1]}");
                                    setState(() {
                                      selectedImage = response[1];
                                    });
                                  }
                                },
                                child: Container(
                                  height: 32.h,
                                  width: 184.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: AppColor.ucpBlue50,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        UcpStrings.ucpAddImage, height: 16.h,
                                        width: 16.w,),
                                      Text(UcpStrings.changePhotoTxt,
                                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                                            .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                            color: AppColor.ucpBlack500
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
                      Gap(26.h),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(UcpStrings.fullNameTxt,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack700
                            ),),
                          height12,
                          StreamBuilder<Object>(
                              stream:bloc.validation.fullname,
                              builder: (context, snapshot) {
                                return CustomizedTextField(
                                  textEditingController: bloc.validation.fullNameController,
                                  hintTxt: UcpStrings.enterFNTxt,
                                  isTouched:bloc.validation.fullNameController.text.isNotEmpty,
                                  error: snapshot.error?.toString(),
                                  keyboardType: TextInputType.name,
                                  onChanged:bloc.validation.setFullName,
                                );
                              }
                          ),
                          Text(UcpStrings.eMailTxt,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack700
                            ),),
                          height12,
                          StreamBuilder<Object>(
                              stream:bloc.validation.email,
                              builder: (context, snapshot) {
                                return CustomizedTextField(
                                  textEditingController: bloc.validation.emailController,
                                  hintTxt: UcpStrings.enterEmailTxt,
                                  isTouched:bloc.validation.emailController.text.isNotEmpty,
                                  error: snapshot.error?.toString(),
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged:bloc.validation.setEmail,
                                );
                              }
                          ),
                          Text(UcpStrings.phoneNumberTxt,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack700
                            ),),
                          height12,
                          StreamBuilder<Object>(
                              stream:bloc.validation.phoneNumber,
                              builder: (context, snapshot) {
                                return CustomizedTextField(
                                  textEditingController: bloc.validation.phoneController,
                                  hintTxt: UcpStrings.enterPhoneTxt,
                                  isTouched:bloc.validation.phoneController.text.isNotEmpty,
                                  error: snapshot.error?.toString(),
                                  keyboardType: TextInputType.phone,
                                  onChanged:bloc.validation.setPhoneNumber,
                                );
                              }
                          ),
                          Text(UcpStrings.homeAddressTxt,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack700
                            ),),
                          height12,
                          StreamBuilder<Object>(
                              stream:bloc.validation.address,
                              builder: (context, snapshot) {
                                return CustomizedTextField(
                                  textEditingController: bloc.validation.addressController,
                                  hintTxt: UcpStrings.enterHomeAddressTxt,
                                  isTouched:bloc.validation.addressController.text.isNotEmpty,
                                  error: snapshot.error?.toString(),
                                  keyboardType: TextInputType.text,
                                  onChanged:bloc.validation.setAddress,
                                );
                              }
                          ),
                          Text(UcpStrings.memberIdTxt,
                            style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.ucpBlack700
                            ),),
                          height12,
                          StreamBuilder<Object>(
                              stream:bloc.validation.memberId,
                              builder: (context, snapshot) {
                                return CustomizedTextField(
                                  readOnly: true,
                                  textEditingController: bloc.validation.memberController,
                                  hintTxt: UcpStrings.enterMemberIdTxt,
                                  isTouched:bloc.validation.memberController.text.isNotEmpty,
                                  error: snapshot.error?.toString(),
                                  keyboardType: TextInputType.text,
                                  onChanged:bloc.validation.setMember,
                                );
                              }
                          ),
                        ],
                      ),
                      ),
                      SizedBox(height: 80.h,)
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
                              Text(UcpStrings.editprofileTxt,
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
              ),
            ),
          ),
        );
      },
    );
  }
  String? selectedImage;
  profileImage(){
    if(selectedImage!=null){
      final value = convertBase64Image(selectedImage!);
      return MemoryImage(value);
    }else{
      if(dashboard.memberImageResponse?.profileImage==null||dashboard.memberImageResponse!.profileImage!.isEmpty){
        return  const AssetImage(UcpStrings.tempImage,);
      }else if(dashboard.memberImageResponse?.profileImage!=null||dashboard.memberImageResponse!.profileImage!.isNotEmpty){
        return NetworkImage(dashboard.memberImageResponse!.profileImage!);
      }
    }

  }
}
