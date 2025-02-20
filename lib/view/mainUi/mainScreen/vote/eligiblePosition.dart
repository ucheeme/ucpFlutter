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
import 'electionWidget.dart';

class MemberEligiblePositionScreen extends StatefulWidget {
  const MemberEligiblePositionScreen({super.key});

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

      showPdfBottomSheet(context);
    } catch (e,trace) {
      setState(() {
        isLoading = false;
      });
      print("Error downloading PDF: $e");
      print("Error downloading PDF: $trace");
    AppUtils.showInfoSnack("Failed to load election guidelines, please check back", context);
    Get.to(ElectionApplicationFormScreen(positionEligibleList: item!,));
    }
  }

  // Function to show PDF in BottomSheet
  void showPdfBottomSheet(BuildContext context) {
    if (pdfPath == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8, // Adjust height
          // child: PDFView(
          //   filePath: pdfPath!,
          //   enableSwipe: true,
          //   swipeHorizontal: false,
          //   autoSpacing: true,
          //   pageFling: true,
          // ),
          child: SfPdfViewer.network("https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf"),
        );
      },
    );
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      votingBloc.add(GetEligiblePositionEvent(PaginationRequest(
          currentPage: currentPage,pageSize: pageSize)));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    votingBloc = BlocProvider.of<VotingBloc>(context);
    return BlocBuilder<VotingBloc, VotingState>(
  builder: (context, state) {
    if(state is VotingError){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        AppUtils.showSnack(state.errorResponse.message, context);
      });
      votingBloc.initial();
    }
    if(state is PositionEligibleLoaded){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        positionEligibleList = state.allElections.modelResult;
        totalPageSize = state.allElections.totalCount;
      });
     votingBloc.initial();
    }
    return UCPLoadingScreen(
      visible: state is VotingIsLoading,
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
            Gap(160.h),
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
                    return GestureDetector(
                      onTap: (){
                        //allLoanRequests

                        print(positionEligibleList[index].electionGuidline);
                       // downloadPdf(positionEligibleList[index].electionGuidline,item: positionEligibleList[index]);
                        downloadPdf("https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf");
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
