import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../colorrs.dart';
import '../constant.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onTap,
    this.borderRadius,
    this.buttonColor,
    this.textColor,
    this.borderColor,
    required this.buttonText,
    this.height,
    this.width,
    this.textStyle,
    this.textfontSize,
    this.icon,
    this.hasIcon,
    Key? key,
  }) : super(key: key);

  VoidCallback onTap;
  IconData? icon;
  Color? buttonColor;

  double? borderRadius;

  Color? textColor;
  TextStyle? textStyle;
  String buttonText;
  bool? hasIcon;
  Color? borderColor;
  double? width;
  double? height;
  double? textfontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: buttonColor ?? Colors.white,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: icon == null ? false : true,
                    child: Icon(
                      icon,
                      color: AppColor.ucpBlack950,
                    )),
                Visibility(
                    visible: icon == null ? false : true, child: Gap(5.w)),
                Text(
                  buttonText,
                  style: textStyle ??
                      TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: textfontSize ?? 16.sp,
                        fontFamily: 'Creato Display',
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomizedTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? labeltxt;
  final String? hintTxt;
  final bool? obsec;
  bool? isConfirmPasswordMatch;
  final Widget? surffixWidget;
  final Function(String)? onChanged;
  final bool? readOnly;
  bool? isPasswordVisible;
  bool? isTouched = false;
  bool? isProfile = false;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final int? maxLines;
  final int? maxLength;
  final String? suffixText;
  final Widget? prefixWidget;
  final String? prefix;
  final Function()? onEditingComplete;
  String? error;
  final List<TextInputFormatter>? inputFormat;

  CustomizedTextField(
      {super.key,
      this.isProfile,
      this.prefix,
      this.prefixWidget,
      this.prefixIconConstraints,
      this.error,
      this.isConfirmPasswordMatch,
      this.onEditingComplete,
      this.maxLines,
      this.textEditingController,
      this.keyboardType,
      this.textInputAction,
      this.labeltxt,
      this.hintTxt,
      this.obsec,
      this.surffixWidget,
      this.inputFormat,
      this.readOnly,
      this.onChanged,
      this.validator,
      this.onTap,
      this.suffixIconConstraints,
      this.maxLength,
      this.suffixText,
      this.isTouched,
      this.isPasswordVisible});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            autofocus: false,
            cursorColor: AppColor.ucpBlue400,
            obscureText: obsec ?? false,
            textCapitalization: TextCapitalization.sentences,
            controller: textEditingController,
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.center,
            readOnly: readOnly ?? false,
            onTap: onTap,
            textInputAction: textInputAction,
            inputFormatters: inputFormat ?? [],
            onEditingComplete: onEditingComplete,
            onChanged: onChanged,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            validator: validator ??
                (value) {
                  if (value!.isEmpty) {
                    return "Fill empty field";
                  } else {
                    return null;
                  }
                },
            style: CustomTextStyle.kTxtMedium.copyWith(
                color: AppColor.ucpBlack800,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp),
            decoration: InputDecoration(
                hintText: hintTxt,
                contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                //hintTextDirection: TextDirection.LTR,
                isDense: true,
                suffixText: suffixText,
                prefixText: prefix,
                prefixIcon: prefixWidget ?? const SizedBox.shrink(),
                prefixIconConstraints: suffixIconConstraints ??
                    BoxConstraints(
                      minWidth: 19.w,
                      minHeight: 19.h,
                    ),
                suffixIconConstraints: suffixIconConstraints ??
                    BoxConstraints(minWidth: 19.w, minHeight: 19.h),
                suffixIcon: surffixWidget ?? const SizedBox.shrink(),
                fillColor: AppColor.ucpWhite10,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColor.ucpWhite10, width: 0.5.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.ucpWhite10),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                errorBorder: (error == null || error == "")
                    ? null
                    : OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor.ucpDanger75, width: 0.2.w),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.ucpBlack200),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColor.ucpBlue100, width: 0.5.w),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                hintStyle: CustomTextStyle.kTxtRegular.copyWith(
                    color: const Color(0xff79747E),
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp)),
          ),
          Gap(4.h),
          Text(
            error ?? "",
            style: CustomTextStyle.kTxtMedium.copyWith(
                color: (isConfirmPasswordMatch != null &&
                        isConfirmPasswordMatch == false)
                    ? AppColor.ucpDanger150
                    : AppColor.ucpSuccess150,
                fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}

class BorderlessTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? labeltxt;
  final String? hintTxt;
  final bool? obsec;
  bool? isConfirmPasswordMatch;
  final Widget? surffixWidget;
  final Function(String)? onChanged;
  final bool? readOnly;
  bool? isPasswordVisible;
  bool isTouched = false;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final int? maxLines;
  final int? maxLength;
  final String? suffixText;
  final Widget? prefixWidget;
  final String? prefix;
  final Function()? onEditingComplete;
  String? error;
  final List<TextInputFormatter>? inputFormat;

  BorderlessTextField(
      {super.key,
      this.prefix,
      this.prefixWidget,
      this.prefixIconConstraints,
      this.error,
      this.isConfirmPasswordMatch,
      this.onEditingComplete,
      this.maxLines,
      this.textEditingController,
      this.keyboardType,
      this.textInputAction,
      this.labeltxt,
      this.hintTxt,
      this.obsec,
      this.surffixWidget,
      this.inputFormat,
      this.readOnly,
      this.onChanged,
      this.validator,
      this.onTap,
      this.suffixIconConstraints,
      this.maxLength,
      this.suffixText,
      required this.isTouched,
      this.isPasswordVisible});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: textEditingController,
      keyboardType: keyboardType,
      textAlign: TextAlign.end,
      textAlignVertical: TextAlignVertical.center,
      readOnly: readOnly ?? false,
      onTap: onTap,
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return "Fill empty field";
            } else {
              return null;
            }
          },
      style: CustomTextStyle.kTxtMedium.copyWith(
          color: AppColor.ucpBlack300,
          fontWeight: FontWeight.w400,
          fontSize: 16.sp),
      decoration: InputDecoration(
          hintText: hintTxt,
          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
          //hintTextDirection: TextDirection.LTR,
          isDense: true,
          fillColor: isTouched ? AppColor.ucpBlack200 : AppColor.ucpBlack700,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.ucpBlack700, width: 0.5.w),
            // borderRadius: BorderRadius.circular(4.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.ucpBlack700),
            // borderRadius: BorderRadius.circular(4.r),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.ucpBlack700),
            // borderRadius: BorderRadius.circular(4.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.ucpBlue100, width: 0.5.w),
            // borderRadius: BorderRadius.circular(4.r),
          ),
          hintStyle: CustomTextStyle.kTxtRegular.copyWith(
              color: const Color(0xff79747E),
              fontWeight: FontWeight.w400,
              fontSize: 16.sp)),
    );
  }
}

class UCPWelcomeOption extends StatefulWidget {
  String? iconImage;
  String headerText;
  String bodyText;
  bool isSelected;
  Function()? onTap;

  UCPWelcomeOption(
      {super.key,
      required this.bodyText,
      this.onTap,
      required this.headerText,
      this.iconImage,
      required this.isSelected});

  @override
  State<UCPWelcomeOption> createState() => _UCPWelcomeOptionState();
}

class _UCPWelcomeOptionState extends State<UCPWelcomeOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 97.h,
        width: 343.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color:
                widget.isSelected ? AppColor.ucpBlue25 : AppColor.ucpWhite500,
            border: Border.all(
                color: !widget.isSelected
                    ? AppColor.ucpWhite100
                    : AppColor.ucpBlue400)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 75.h,
              width: 285.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.iconImage != null
                      ? Image.asset(widget.iconImage!,
                          height: 24.h,
                          width: 24.w,
                          color: widget.isSelected
                              ? AppColor.ucpBlue800
                              : AppColor.ucpBlue100)
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 75.h,
                    width: 247.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.headerText,
                          style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                              color: AppColor.ucpBlack800,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp),
                        ),
                        Spacer(),
                        Text(
                          widget.bodyText,
                          style: CreatoDisplayCustomTextStyle.kTxtRegular
                              .copyWith(
                                  color: AppColor.ucpBlack700,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.sp),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 17.h,
              width: 17.w,
              padding: EdgeInsets.all(4.53.h),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? AppColor.ucpBlue800
                      : AppColor.ucpBlue100),
              child: Container(
                height: 7.93.h,
                width: 7.93.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSelected
                        ? AppColor.ucpBlue100
                        : AppColor.ucpWhite500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UCPRadioButton extends StatefulWidget {
  bool isSelected;
  Function()? onTap;
  final String radioText;
  bool isDmSans;

  UCPRadioButton(
      {super.key,
      required this.isSelected,
      this.onTap,
      required this.isDmSans,
      required this.radioText});

  @override
  State<UCPRadioButton> createState() => _UCPRadioButtonState();
}

class _UCPRadioButtonState extends State<UCPRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 17.h,
            width: 17.w,
            padding: EdgeInsets.all(4.53.h),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isSelected
                    ? AppColor.ucpBlue800
                    : AppColor.ucpBlue100),
            child: Container(
              height: 7.93.h,
              width: 7.93.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? AppColor.ucpBlue100
                      : AppColor.ucpWhite500),
            ),
          ),
        ),
        Gap(5.w),
        Text(widget.radioText,
            style: widget.isDmSans
                ? CustomTextStyle.kTxtRegular.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColor.ucpBlack500,
                  )
                : CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColor.ucpBlack500,
                  ))
      ],
    );
  }
}

class BottomsheetRadioButtonRightSide extends StatefulWidget {
  bool isSelected;
  Function()? onTap;
  final String radioText;
  bool isDmSans;
  double textHeight;
  bool isMoreThanOne;

  BottomsheetRadioButtonRightSide({
    super.key,
    required this.textHeight,
    required this.isMoreThanOne,
    required this.radioText,
    required this.isDmSans,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<BottomsheetRadioButtonRightSide> createState() =>
      _BottomsheetRadioButtonRightSideState();
}

class _BottomsheetRadioButtonRightSideState
    extends State<BottomsheetRadioButtonRightSide> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
         width: 300.w,
          child: Text(widget.radioText,
              maxLines: widget.isMoreThanOne ? 3 : 1,
              style: widget.isDmSans
                  ? CustomTextStyle.kTxtMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColor.ucpBlack500,
                    )
                  : CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color:widget.isSelected
                          ?AppColor.ucpBlack500:AppColor.ucpBlack700,
                    )),
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 17.h,
            width: 17.w,
            padding: EdgeInsets.all(2.53.h),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isSelected
                    ? Colors.transparent
                    : AppColor.ucpWhite500,
                border: Border.all(
                  color: widget.isSelected
                      ? AppColor.ucpBlue600
                      : AppColor.ucpBlack300,
                )),
            child: Container(
              height: 7.93.h,
              width: 7.93.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? AppColor.ucpBlue600
                      : AppColor.ucpWhite500),
            ),
          ),
        ),
      ],
    );
  }
}
