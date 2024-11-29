
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';

import 'colorrs.dart';
import 'constant.dart';
import 'designUtils/reusableWidgets.dart';

class AppUtils{
  static void debug(dynamic msg){
    if (kDebugMode) {
      print(msg);
    }
  }
  static void showSnack(String msg, BuildContext? context){
    CherryToast.error(toastDuration: const Duration(seconds: 2),
        animationType: AnimationType.fromTop,
        title:   Text(msg)
    ).show(context!);
  }
  static void showSuccessSnack(String msg, BuildContext? context){
    CherryToast.success(
        animationType: AnimationType.fromTop,
        title:   Text(msg,)
    ).show(context!);
  }
  static void showInfoSnack(String msg, BuildContext? context){
    CherryToast.info(
        animationType: AnimationType.fromTop,
        title:   Text(msg)
    ).show(context!);
  }
  static void showInfoSnackFromBottom(String msg, BuildContext? context,{double height =40}){
    CherryToast.info(
        toastPosition: Position.bottom,
        width: Get.width,
        height: height.h,
        displayIcon: false,
        displayCloseButton: false,
        backgroundColor: AppColor.ucpDanger150,
        animationType: AnimationType.fromBottom,
        description:   Text(msg,textAlign:TextAlign.center,style:CustomTextStyle.kTxtMedium.copyWith(
          color: AppColor.ucpBlack600,
          fontSize: 13.sp,
        ),)
    ).show(context!);
  }
  static void showInfoSnackFromBottom2(String msg, BuildContext? context,{double height =40}){
    CherryToast.warning(
      autoDismiss: false,
      toastPosition: Position.bottom,
      width: Get.width,
      borderRadius: 0.r,
      displayIcon: false,
      displayCloseButton: true,
      backgroundColor: AppColor.ucpDanger150,
      animationType: AnimationType.fromBottom,
      title:   Text("Attention",textAlign:TextAlign.center,style:CustomTextStyle.kTxtMedium.copyWith(
        color: AppColor.ucpBlack600,
        fontSize: 13.sp,
      ),
      ),
      description:  Text(msg,textAlign:TextAlign.center,style:CustomTextStyle.kTxtMedium.copyWith(
        color: AppColor.ucpBlack600,
        fontSize: 13.sp,
      ),),
    ).show(context!);
  }
  static String currency(BuildContext context) {
    var format = NumberFormat.simpleCurrency(name: "NGN");
    return "NGN";
  }
  static UcpDefaultResponse defaultErrorResponse({String msg = "Error occurred"}){
    var returnValue =  UcpDefaultResponse(data: null,message: "Error occurred",
        errors: ["Developer Error"], isSuccessful: false, statusCode: 0);
    returnValue.message = msg;
    print("Developer Error Detail: $msg");
    return returnValue;
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern as String);
    if (!regex.hasMatch(value)) {
      return false;
    }
    else {
      return true;
    }
  }
  bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp =  RegExp(pattern);
    if (value.isEmpty) {
      return false;
    }
    if (value.length != 10 && value.length != 11) {
      return false;
    }
    else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  bool isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r"[a-z]"))) return false;
    if (!password.contains(RegExp(r"[A-Z]"))) return false;
    if (!password.contains(RegExp(r"[0-9]"))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }



}

bool validateEmail(String value) {
  Pattern pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern as String);
  if (!regex.hasMatch(value)) {
    return false;
  }
  else {
    return true;
  }
}
bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp =  RegExp(pattern);
  if (value.isEmpty) {
    return false;
  }
  if (value.length < 10) {
    return false;
  }
  // else if (!regExp.hasMatch(value)) {
  //   return false;
  // }
  return true;
}

bool isPasswordValid(String password) {
  if (password.length < 8) return false;
  if (!password.contains(RegExp(r"[a-z]"))) return false;
  if (!password.contains(RegExp(r"[A-Z]"))) return false;
  if (!password.contains(RegExp(r"[0-9]"))) return false;
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
  return true;
}
String getTimeDifference(String timeStamp){
  DateTime currentTime = DateTime.now();
  DateTime elapseTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(timeStamp));
  if (currentTime.difference(elapseTime).inDays > 0)
  {
    return "${currentTime.difference(elapseTime).inDays} day(s) ago";
  }
  if (currentTime.difference(elapseTime).inHours > 0)
  {
    return "${currentTime.difference(elapseTime).inHours} hour(s) ago";
  }
  if (currentTime.difference(elapseTime).inMinutes > 0)
  {
    return "${currentTime.difference(elapseTime).inMinutes} minute(s) ago";
  }
  return "${currentTime.difference(elapseTime).inSeconds} sec(s) ago";
}

void showSlidingModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Makes the background transparent
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7, // This is 60% of the screen height
        minChildSize: 0.4,     // Minimum height when you drag down
        maxChildSize: 0.7,     // Maximum height
        builder: (_, controller) {
          return Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.only(left: 12.w,right: 12.w,bottom: 42.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: ListView(

              controller: controller, // For scrollable content
              children: [
                // Align(
                //   alignment: Alignment.topRight,
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: SizedBox(
                //         height: 24.h,
                //         width: 24.w,
                //         child: Image.asset(closeImage)),
                //   ),
                // ),
                height50,
                // SizedBox(
                //   height: 98.h,
                //   width: 98.w,
                //   child: Image.asset(emailIcon),
                // ),
                Gap(28.h),
                Text(
                  'Check your mail',
                  textAlign: TextAlign.center,
                  style:CustomTextStyle.kTxtBold.copyWith(color: AppColor.ucpBlack300,
                      fontSize: 24.sp,fontWeight: FontWeight.w400),
                ),
                height12,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    'We have sent a password recovery instruction to your email.',
                    textAlign: TextAlign.center,
                    style:CustomTextStyle.kTxtMedium.copyWith(color: AppColor.ucpBlack300,
                        fontSize: 14.sp,fontWeight: FontWeight.w400),
                  ),
                ),
                Gap(56.h),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 34.w),
                  child: CustomButton(
                    onTap: () async {
                      // Android: Will open mail app or show native picker.
                      // iOS: Will open mail app if single mail app found.
                      // var result = await OpenMailApp.openMailApp();
                      //
                      // // If no mail apps found, show error
                      // if (!result.didOpen && !result.canOpen) {
                      //   showNoMailAppsDialog(context);
                      //
                      //   // iOS: if multiple mail apps found, show dialog to select.
                      //   // There is no native intent/default app system in iOS so
                      //   // you have to do it yourself.
                      // } else if (!result.didOpen && result.canOpen) {
                      //   showDialog(
                      //     context: context,
                      //     builder: (_) {
                      //       return MailAppPickerDialog(
                      //         mailApps: result.options,
                      //       );
                      //     },
                      //   );
                      // }
                    },
                    buttonText:'Open email app',
                    buttonColor: AppColor.ucpBlue500,
                    textColor: AppColor.ucpWhite30,
                    borderRadius: 8.r,
                    height: 46.h,
                    width: 222.w,
                  ),
                ),
                height10,
                TextButton(
                  onPressed: () {
                    Get.back();
                    // Get.to(ResetPasswordSignIn());
                    },
                  child: Text(
                    'Done',
                    style: CustomTextStyle.kTxtBold.copyWith(color: AppColor.ucpBlue800,
                        fontSize: 12.sp,fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}