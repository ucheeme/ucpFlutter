import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/bloc/onboarding/on_boarding_bloc.dart';
import 'package:ucp/data/model/response/allCountries.dart';
import 'package:ucp/data/model/response/statesInCountry.dart';
import 'package:ucp/utils/appExtentions.dart';

import '../../utils/appStrings.dart';
import '../../utils/colorrs.dart';
import '../../utils/constant.dart';
import '../../utils/designUtils/reusableWidgets.dart';

class CountriesDesign extends StatefulWidget {
  List<AllCountriesResponse> allcountries;
   CountriesDesign({super.key,required this.allcountries});

  @override
  State<CountriesDesign> createState() => _CountriesDesignState();
}

class _CountriesDesignState extends State<CountriesDesign> {
  int selectedindex = 0;

  TextEditingController searchController = TextEditingController();
  bool searchSelected = false;
  List<AllCountriesResponse> listOfBank = [];
  AllCountriesResponse? selectedBank;
  searchCooperativeList(String value) {
    setState(() {
      listOfBank = widget.allcountries
          .where((element) =>
          element.countryName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      listOfBank = listOfBank;
    });
  }
  @override
  void initState() {
    listOfBank = widget.allcountries;
    selectedBank = listOfBank[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite500,
        bottomSheet:   Container(
            height: 83.h,
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(
              color: AppColor.ucpBlue50,     //Color( 0xffEDF4FF),
            ),
            child: CustomButton(
              onTap: () {
               
                Get.back(result: selectedBank);
              },
              borderRadius: 30.r,
              buttonColor: AppColor.ucpBlue500,
              buttonText: UcpStrings.doneTxt,
              height: 51.h,
              textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: AppColor.ucpWhite500,
              ),
              textColor: AppColor.ucpWhite500,
            )
        ),
        body: SingleChildScrollView(
          child: Column(
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
                      Icon(Icons.arrow_back ,size: 28.h, color: AppColor.ucpBlack500),
                      Gap(10.w),
                      Text(
                       "Select Country",
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
                padding: EdgeInsets.symmetric(horizontal: 10.w),
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
              listOfBank.isEmpty
                  ? SizedBox(
                height: 250.h,
                child: Center(
                  child: Text(
                    UcpStrings.emptyCoopTxt,
                    style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack500),
                  ),
                ),
              )
                  : SizedBox(
                height: 270.h,
                child: ListView(
                    children: listOfBank
                        .mapIndexed((element, index) =>
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBank = element;
                              selectedindex = index;
                            });
                          },
                          child: Container(
                              height: element.countryName.length > 30
                                  ? 70.h
                                  : 48.h,
                              margin: EdgeInsets.only(
                                  bottom: 14.h, left: 15.w, right: 15.w),
                              padding:
                              EdgeInsets.symmetric(horizontal: 12.h),
                              decoration: BoxDecoration(
                                  color: (index == selectedindex)
                                      ? AppColor.ucpBlue25
                                      : AppColor.ucpWhite500,
                                  borderRadius:
                                  BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: (index == selectedindex)
                                        ? AppColor.ucpBlue500
                                        : AppColor.ucpWhite500,
                                  )),
                              child: BottomsheetRadioButtonRightSide(
                                radioText: element.countryName,
                                isMoreThanOne:
                                element.countryName.length > 30,
                                isDmSans: false,
                                isSelected: index == selectedindex,
                                onTap: () {
                                  setState(() {
                                    selectedindex = index;
                                  });
                                },
                                textHeight: element.countryName.length > 30
                                    ? 24.h
                                    : 16.h,
                              )),
                        ))
                        .toList()),
              ),


            ],
          ),
        ),
      ),
    );
  }
}


class StateDesign extends StatefulWidget {
  String countryId;
   StateDesign({super.key, required this.countryId});

  @override
  State<StateDesign> createState() => _StateDesignState();
}

class _StateDesignState extends State<StateDesign> {
  late OnBoardingBloc bloc;
  int selectedindex = 0;

  TextEditingController searchController = TextEditingController();
  bool searchSelected = false;
  List<AllStateResponse> listOfBank = [];
  List<AllStateResponse> listOfBankMain = [];
  AllStateResponse? selectedBank;
  searchCooperativeList(String value) {
    setState(() {
      listOfBank =listOfBankMain
          .where((element) =>
          element.stateName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      listOfBank = listOfBank;
    });
  }
  @override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_){
    bloc.add(GetAllStatesEvent(widget.countryId));
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc =  BlocProvider.of<OnBoardingBloc>(context);
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
  builder: (context, state) {
    if(state is AllUcpStates){
      WidgetsBinding.instance.addPostFrameCallback((_){
        listOfBankMain = state.response;
        setState(() {
          listOfBank = listOfBankMain;
        });
      });
      bloc.initial();
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite500,
        bottomSheet:   Container(
            height: 83.h,
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(
              color: AppColor.ucpBlue50,     //Color( 0xffEDF4FF),
            ),
            child: CustomButton(
              onTap: () {

                Get.back(result: selectedBank);
              },
              borderRadius: 30.r,
              buttonColor: AppColor.ucpBlue500,
              buttonText: UcpStrings.doneTxt,
              height: 51.h,
              textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: AppColor.ucpWhite500,
              ),
              textColor: AppColor.ucpWhite500,
            )
        ),
        body: SingleChildScrollView(
          child: Column(
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
                      Icon(Icons.arrow_back ,size: 28.h, color: AppColor.ucpBlack500),
                      Gap(10.w),
                      Text(
                          "Select State",
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
                padding: EdgeInsets.symmetric(horizontal: 10.w),
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
              listOfBank.isEmpty
                  ? SizedBox(
                height: 250.h,
                child: Center(
                  child: Text(
                    UcpStrings.emptyCoopTxt,
                    style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpBlack500),
                  ),
                ),
              )
                  : SizedBox(
                height: 270.h,
                child: ListView(
                    children: listOfBank
                        .mapIndexed((element, index) =>
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBank = element;
                              selectedindex = index;
                            });
                          },
                          child: Container(
                              height: element.stateName.length > 30
                                  ? 70.h
                                  : 48.h,
                              margin: EdgeInsets.only(
                                  bottom: 14.h, left: 15.w, right: 15.w),
                              padding:
                              EdgeInsets.symmetric(horizontal: 12.h),
                              decoration: BoxDecoration(
                                  color: (index == selectedindex)
                                      ? AppColor.ucpBlue25
                                      : AppColor.ucpWhite500,
                                  borderRadius:
                                  BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: (index == selectedindex)
                                        ? AppColor.ucpBlue500
                                        : AppColor.ucpWhite500,
                                  )),
                              child: BottomsheetRadioButtonRightSide(
                                radioText: element.stateName,
                                isMoreThanOne:
                                element.stateName.length > 30,
                                isDmSans: false,
                                isSelected: index == selectedindex,
                                onTap: () {
                                  setState(() {
                                    selectedindex = index;
                                  });
                                },
                                textHeight: element.stateName.length > 30
                                    ? 24.h
                                    : 16.h,
                              )),
                        ))
                        .toList()),
              ),


            ],
          ),
        ),
      ),
    );
  },
);
  }
}
