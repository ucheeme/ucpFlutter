import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ucp/app/apiService/appUrl.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/vote/ElectionApplicationFormScreen.dart';
import 'package:ucp/view/mainUi/mainScreen/vote/vote.dart';

import '../../../../bloc/vote/voting_bloc.dart';
import '../../../../data/model/response/allElections.dart';
import '../../../../data/repository/FinanceRepo.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../errorPages/noNotification.dart';
import 'electionWidget.dart';
List<PositionEligible> tempPositionEligibleList = [];
List<String>  allElectionPosition= [];
class MemberEligiblePositionScreen extends StatefulWidget {
  VotingBloc votingBloc;
   MemberEligiblePositionScreen({super.key,required this.votingBloc});

  @override
  State<MemberEligiblePositionScreen> createState() => _MemberEligiblePositionScreenState();
}

class _MemberEligiblePositionScreenState extends State<MemberEligiblePositionScreen> {
  int numberOfPosition = 0;
  late VotingBloc votingBloc;
  int currentPage = 1;
  int pageSize = 50;
  int totalPageSize = 0;
  bool hasMore = true;
  ScrollController scrollController = ScrollController();
  List<PositionEligible> positionEligibleList = [];
  String? pdfPath;
  bool isLoading = false;

  // Function to download PDF from URL
  Future<void> downloadPdf(String url,{ PositionEligible? item}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/downloaded.pdf';
      await Dio().download(url, filePath);

      setState(() {
        pdfPath = filePath;
        isLoading = false;
      });

      showPdfBottomSheet(context,url,item!);
    } catch (e,trace) {
      setState(() {
        isLoading = false;
      });
      print("Error downloading PDF: $e");
      print("Error downloading PDF: $trace");
    AppUtils.showInfoSnack("Failed to load election guidelines, please check back", context);

    }
  }

  // Function to show PDF in BottomSheet
  void showPdfBottomSheet(BuildContext context,String? url, PositionEligible positionEligibleList) {
    if (pdfPath == null) return;
    showCupertinoModalBottomSheet(
      topRadius: Radius.circular(15.r),

      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (context) {
        return SizedBox(
          height: 650.h,
          child: GuideLines(
            url: url,
            positionEligibleList: positionEligibleList,
          ),
        );
      },
      context: context,
    );
  }

  @override
  void initState() {
    votingBloc = widget.votingBloc;
    WidgetsBinding.instance.addPostFrameCallback((_){
      votingBloc.add(GetEligiblePositionEvent(PaginationRequest(
          currentPage: currentPage,pageSize: pageSize)));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   // votingBloc = BlocProvider.of<VotingBloc>(context);
    return BlocBuilder<VotingBloc, VotingState>(
  builder: (context, state) {
    if(state is VotingError){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if(state.errorResponse.message.toLowerCase()!="no active election"){
          AppUtils.showSnack(state.errorResponse.message, context);
        }
      });
      votingBloc.initial();
    }
    if(state is PositionEligibleLoaded){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        positionEligibleList = state.allElections.modelResult;
        tempPositionEligibleList = state.allElections.modelResult;
        allElectionPosition.clear();
        allElectionPosition.addAll(tempPositionEligibleList.map((e) => e.positionName));
        totalPageSize = state.allElections.totalCount;
      });
     votingBloc.initial();
    }
    return UCPLoadingScreen(
      visible:isLoading || state is VotingIsLoading,
      loaderWidget: LoadingAnimationWidget.discreteCircle(
        color: AppColor.ucpBlue500,
        size: 40.h,
        secondRingColor: AppColor.ucpBlue100,
      ),
      overlayColor: AppColor.ucpBlack400,
      transparency: 0.2,
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite10,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
            Gap(150.h),
            Container(
              height:92.h,
              width: 343.w,
              decoration: BoxDecoration(
                image:  const DecorationImage(image: AssetImage(UcpStrings.dashBoardB),fit: BoxFit.cover),
                borderRadius:BorderRadius.circular(20.r),),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Positions eligibility",
                      textAlign: TextAlign.center,
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.ucpOrange300,
                      )),
                  Text("${positionEligibleList.length} Positions eligible",
                      style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.ucpWhite500,
                      )),
                ],
              ),
            ),
            Gap(16.h),
            positionEligibleList.isEmpty?
            SizedBox(
              height:500.h,
              child: EmptyNotificationsScreen(
                  emptyHeader: "No Election ongoing",
                  emptyMessage: "It looks like you don't have any election ongoing right now. We'll let you know when there's something new.",
                  press: () {
                    votingBloc.add(GetEligiblePositionEvent(
                        PaginationRequest(
                        currentPage: currentPage,pageSize: pageSize)));
                  }
              ),
            ):
            NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  // Load more items when reaching the bottom
                  if (totalPageSize > currentPage) {
                    hasMore = true;
                    currentPage++;
                    votingBloc.add(GetEligiblePositionEvent(
                        PaginationRequest(
                            currentPage: currentPage,pageSize: pageSize)
                    ));
                  }

                }
                return true;
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height-100.h,
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: positionEligibleList.length,
                  itemBuilder: (context, index) {
                   // allElectionPosition.add(positionEligibleList[index].positionName);
                    return GestureDetector(
                      onTap: (){

                       downloadPdf(positionEligibleList[index].electionGuidline,item: positionEligibleList[index]);
                      },
                      child: Container(
                        //  height: 185.h,
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                         // padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ElectionPositionWidget(positionEligibleList: positionEligibleList[index],)
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
  }
}

class GuideLines extends StatelessWidget {
  String? url;
   PositionEligible positionEligibleList;
   GuideLines({
    super.key,this.url,
    required this.positionEligibleList
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 650.h,
        child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.ucpWhite00,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22.r),
                        topRight: Radius.circular(22.r),
                      ),
                    ),
                    child: Center(
                      child: Text("Election Guidelines",
                          textAlign: TextAlign.left,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8, // Adjust height
                    child: SfPdfViewer.network(url??"https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf"),
                  ),
                ],
              ),
              Positioned(
                top:490.h,
                child: UCPCustomAppBar(
                  height: 165.h,
                  child: Column(
                    children: [
                      Gap(16.h),
                      SizedBox(
                        height: 51.h,
                        child: Row(
                          children: [
                            CircleRingIcon(),
                            Gap(12.w),
                            Container(
                              height: 51.h,
                              width: 303.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text("I agree to the Terms, Conditions and Privacy Policy.",
                                    textAlign: TextAlign.left,
                                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpBlack900,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(20.h),
                      SizedBox(
                        height: 51.h,
                        width: 343.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 51.h,
                                width: 163.5.w,
                                decoration: BoxDecoration(
                                  color: AppColor.ucpBlue50,
                                  borderRadius: BorderRadius.circular(25.r),

                                ),
                                child: Center(
                                  child: Text("Decline",
                                      textAlign: TextAlign.center,
                                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpBlack900,
                                      )),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Get.to(ElectionApplicationFormScreen(
                                  positionEligibleList: positionEligibleList!,)
                                );
                              },
                              child: Container(
                                height: 51.h,
                                width: 163.5.w,
                                decoration: BoxDecoration(
                                  color: AppColor.ucpBlue600,
                                  borderRadius: BorderRadius.circular(25.r),

                                ),

                                child: Center(
                                  child: Text("Accept",
                                      textAlign: TextAlign.center,
                                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.ucpWhite00,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),),
              )
            ]
        ),
      ),
    );
  }
}

class CircleRingIcon extends StatelessWidget {
  const CircleRingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.w, // adjust size as needed
      height: 24.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.ucpBlue500,
                width: 3,
              ),
            ),
          ),
          // Inner filled circle
          Container(
            width: 15.w,
            height: 15.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.ucpBlue500,
            ),
          ),
        ],
      ),
    );
  }
}
