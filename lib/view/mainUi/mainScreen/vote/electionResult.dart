import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ucp/bloc/vote/voting_bloc.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/ucpLoader.dart';

import '../../../../data/model/response/allElections.dart';
import '../../../../data/model/response/electionDetailResponse.dart';
import '../../../../data/repository/FinanceRepo.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../errorPages/noNotification.dart';
import 'ElectionApplicationFormScreen.dart';
import 'electionListWidget.dart';
import 'electionWidget.dart';
import 'eligiblePosition.dart';
import 'leaderBoard.dart';

class ElectionResultScren extends StatefulWidget {
  VotingBloc bloc;

  ElectionResultScren({super.key, required this.bloc});

  @override
  State<ElectionResultScren> createState() => _ElectionResultScrenState();
}

class _ElectionResultScrenState extends State<ElectionResultScren> {
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

  @override
  void initState() {
    votingBloc = widget.bloc;
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
                      Text("Available results",
                          textAlign: TextAlign.center,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpOrange300,
                          )),
                      Text("${positionEligibleList.length} Results available",
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
                      emptyHeader: "No Avaliable Result",
                      emptyMessage: " No results ",
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
                            print(positionEligibleList[index].electionGuidline);
                            Get.to(LeaderboardScreen());

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
