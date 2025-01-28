import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/data/model/response/allGuarantors.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/apputils.dart';

import '../../utils/appStrings.dart';
import '../../utils/colorrs.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableWidgets.dart';

class GuantorListDesign extends StatefulWidget {
  List<LoanGuantorsList> allGuantors;
  ScrollController? scrollController;
   GuantorListDesign({super.key, required this.allGuantors, this.scrollController});

  @override
  State<GuantorListDesign> createState() => _GuantorListDesignState();
}

class _GuantorListDesignState extends State<GuantorListDesign> {
  int? selectedIndex;
  TextEditingController searchController = TextEditingController();
  bool searchSelected = false;
  List<LoanGuantorsList> guarantorsList = [];
  List<LoanGuantorsList> selectedGuarantors = [];
  LoanGuantorsList? selectedGuarantor;

  searchCooperativeList(String value) {
    setState(() {
      guarantorsList = widget.allGuantors
          .where((element) =>
          element.employeeName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      guarantorsList = guarantorsList;
    });
  }
  @override
  void initState() {
    guarantorsList = widget.allGuantors;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        bottomSheet:   Container(
            height: 83.h,
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.ucpBlue50,     //Color( 0xffEDF4FF),
              // borderRadius: BorderRadius.only(
              //   bottomRight: Radius.circular(15.r),
              //   bottomLeft: Radius.circular(15.r),
              // ),
            ),
            child: CustomButton(
              onTap: () {
                if(selectedGuarantors.length>1){
                  Get.back(result: selectedGuarantors);
                }else{
                 AppUtils.showInfoSnack("Please select at least two guarantors", context);
                }

              },
              borderRadius: 30.r,
              buttonColor: AppColor.ucpBlue500,
              buttonText: UcpStrings.next,
              height: 51.h,
              textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: AppColor.ucpWhite500,
              ),
              textColor: AppColor.ucpWhite500,
            )
        ),
        backgroundColor: AppColor.ucpWhite500,
        body: ListView(
          controller: widget.scrollController,
          children: [
            Container(
              height: 59.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              decoration: BoxDecoration(
                color: AppColor.ucpBlue25, //Color( 0xffEDF4FF),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.r),
                  topLeft: Radius.circular(15.r),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [

                    Text(
                      UcpStrings.sLoanGuarantorTxt,
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: AppColor.ucpBlack500),
                    ),
                  ],
                ),
              ),
            ),
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 51.h,
                child: CupertinoSearchTextField(
                  controller: searchController,
                  placeholder: UcpStrings.searchTxt,
                  placeholderStyle: CustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.ucpBlack500),
                  onSubmitted: (value) {
                    setState(() {
                      searchSelected = false;
                    });
                  },
                  onChanged: searchCooperativeList,
                  decoration: BoxDecoration(
                    color: AppColor.ucpWhite500,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: searchSelected
                            ? AppColor.ucpBlue500
                            : AppColor.ucpWhite100),
                  ),
                  onTap: () {
                    setState(() {
                      searchSelected = true;
                    });
                  },
                ),
              ),
            ),
            height20,
            guarantorsList.isEmpty
                ? SizedBox(
              height: 250.h,
              child: Center(
                child: Text(
                  UcpStrings.noAvaliableTxt,
                  style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.ucpBlack500),
                ),
              ),
            )
                : Column(
                    children: guarantorsList
                        .mapIndexed((element, index) =>
                        GestureDetector(
                          onTap: () {
                            if(selectedGuarantors.contains(element)){
                              selectedGuarantors.remove(element);
                              setState(() {
                                selectedGuarantor = null;
                                selectedIndex = null;
                              });
                            }else{
                              setState(() {
                                selectedGuarantor = element;
                                //selectedIndex = index;
                              });
                              selectedGuarantors.add(element);
                            }

                          },
                          child: Container(
                              height: element.employeeName.length > 30
                                  ? 70.h
                                  : 48.h,
                              margin: EdgeInsets.only(
                                  bottom: 14.h, left: 16.w, right: 16.w),
                              padding:
                              EdgeInsets.symmetric(horizontal: 12.h),
                              decoration: BoxDecoration(
                                  color: (selectedGuarantors.contains(element))
                                      ? AppColor.ucpBlue25
                                      : AppColor.ucpWhite500,
                                  borderRadius:
                                  BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: (selectedGuarantors.contains(element))
                                        ? AppColor.ucpBlue500
                                        : AppColor.ucpWhite500,
                                  )),
                              child: BottomsheetRadioButtonRightSide(
                                radioText: element.employeeName,
                                isMoreThanOne:
                                element.employeeName.length > 30,
                                isDmSans: false,
                                isSelected:selectedGuarantors.contains(element),
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                textHeight: element.employeeName.length > 30
                                    ? 24.h
                                    : 16.h,
                              )),
                        )
                    )
                        .toList()),
          ],
        ),
      ),
    );
  }
}
