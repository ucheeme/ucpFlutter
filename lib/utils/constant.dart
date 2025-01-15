import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colorrs.dart';

void statusBarTheme(){
  SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
}

EdgeInsets customPadding= EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h);

class AppConstantData{
  AppConstantData();
  bool sessionExpired = false;
  bool requireUpdate = false;
  bool isProduction = true;
  bool isLogin = false;
}
///Height
var height4=SizedBox(height: 4.h,);
var height6=SizedBox(height: 6.h,);
var height8=SizedBox(height: 8.h,);
var height10=SizedBox(height: 10.h,);
var height12=SizedBox(height: 12.h,);
var height14=SizedBox(height: 14.h,);
var height16=SizedBox(height: 16.h,);
var height20=SizedBox(height: 20.h,);
var height22=SizedBox(height: 22.h,);
var height24=SizedBox(height: 24.h,);
var height26=SizedBox(height: 26.h,);
var height28=SizedBox(height: 28.h,);
var height30=SizedBox(height: 30.h,);
var height35=SizedBox(height: 35.h,);
var height40=SizedBox(height: 40.h,);
var height45=SizedBox(height: 45.h,);
var height47=SizedBox(height: 47.h,);
var height50=SizedBox(height: 50.h,);
var height55=SizedBox(height: 55.h,);
var height60=SizedBox(height: 60.h,);
var height70=SizedBox(height: 70.h,);
var height85=SizedBox(height: 85.h,);
var height90=SizedBox(height: 90.h,);
var height120=SizedBox(height: 120.h,);


class CustomTextStyle{
  static TextStyle kTxtRegular = TextStyle(
    color: AppColor.ucpBlack800,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'DM Sans Light',
  );

  static TextStyle kTxtMedium = TextStyle(
    color:AppColor.ucpBlack800,
    fontSize: 16.sp,

    fontWeight: FontWeight.w600,
    fontFamily: 'DM Sans Medium',
  );

  static TextStyle kTxtLight = TextStyle(
    color: AppColor.ucpBlack800,
    fontSize: 18.sp,

    fontWeight: FontWeight.w400,
    fontFamily: 'DM Sans Regular',
  );
  static TextStyle kTxtBold= TextStyle(
    color: AppColor.ucpBlack800,
    fontSize: 38.sp,

    fontWeight: FontWeight.w800,
    fontFamily: 'DM Sans',
  );
}

class CreatoDisplayCustomTextStyle{
  static TextStyle kTxtRegular = TextStyle(
    color: AppColor.ucpBlack800,
    fontSize: 12.sp,
    letterSpacing: -0.35.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Creato Display',
  );

  static TextStyle kTxtMedium = TextStyle(
    color:AppColor.ucpBlack800,
    fontSize: 16.sp,
    letterSpacing: -0.35.sp,
    fontWeight: FontWeight.w600,
    fontFamily: 'Creato Display Medium',
  );

  static TextStyle kTxtLight = TextStyle(
    color: AppColor.ucpBlack800,
    fontSize: 18.sp,
    letterSpacing: -0.35.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Creato Display Regular',
  );
  static TextStyle kTxtBold= TextStyle(
    color: AppColor.ucpBlack800,
    fontSize: 38.sp,
    letterSpacing: -0.35.sp,
    fontWeight: FontWeight.w800,
    fontFamily: 'Creato Display Bold',
  );
}

