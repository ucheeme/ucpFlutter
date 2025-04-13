import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/bloc/vote/voting_bloc.dart';
import 'package:ucp/data/model/response/electionDetailResponse.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/vote/VoteContestant.dart';
import 'package:ucp/view/mainUi/mainScreen/vote/eligiblePosition.dart';

import '../../../../data/repository/FinanceRepo.dart';
import '../../../../utils/apputils.dart';
import '../../../errorPages/noNotification.dart';
import 'electionListWidget.dart';

class ElectionScreens extends StatefulWidget {
  final VotingBloc votingBloc;

  const ElectionScreens({super.key, required this.votingBloc});

  @override
  State<ElectionScreens> createState() => _ElectionScreensState();
}

class _ElectionScreensState extends State<ElectionScreens> {
  late VotingBloc votingBloc;
  late ElectionDetails response;
  bool isInitial = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  int currentPage = 1;
  final int pageSize = 100;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    isInitial = true;
    votingBloc = widget.votingBloc;

    _scrollController = ScrollController()..addListener(_scrollListener);

    if (tempPositionEligibleList.isEmpty) {
      votingBloc.add(GetEligiblePositionEvent(PaginationRequest(
        currentPage: currentPage,
        pageSize: pageSize,
      )));
    } else {
      votingBloc.add(GetElectionDetailsEvent(tempPositionEligibleList.first.electionId));
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        hasMoreData) {
      setState(() {
        isLoadingMore = true;
        currentPage += 1;
      });

      votingBloc.add(GetEligiblePositionEvent(PaginationRequest(
        currentPage: currentPage,
        pageSize: pageSize,
      )));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VotingBloc, VotingState>(
      builder: (context, state) {
        if (state is VotingError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.errorResponse.message.toLowerCase() != "no active election") {
              AppUtils.showSnack(state.errorResponse.message, context);
            }
          });
          votingBloc.initial();
        }

        if (state is ElectionDetailLoaded) {
          response = state.response;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              response = state.response;
              isInitial = false;
            });
          });
          votingBloc.initial();
        }

        if (state is PositionEligibleLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final newList = state.allElections.modelResult;

            if (newList.isEmpty) {
              hasMoreData = false;
            } else {
              tempPositionEligibleList.addAll(newList);
              allElectionPosition.addAll(
                  newList.map((e) => e.positionName));
            }

            if (isInitial && tempPositionEligibleList.isNotEmpty) {
              votingBloc.add(GetElectionDetailsEvent(tempPositionEligibleList.first.electionId));
            }

            setState(() {
              isInitial = false;
              isLoadingMore = false;
            });

            votingBloc.initial();
          });
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
            body: (state is VotingIsLoading || isInitial)
                ? SizedBox()
                : allElectionPosition.isEmpty
                ? SizedBox(
              height: 700.h,
              child: EmptyNotificationsScreen(
                emptyHeader: "No Ongoing Election",
                emptyMessage:
                "It looks like you don't have any election ongoing right now. We'll let you know when there's something new.",
                press: () {
                  votingBloc.add(GetEligiblePositionEvent(PaginationRequest(
                    currentPage: currentPage,
                    pageSize: pageSize,
                  )));
                },
              ),
            )
                : ListView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                Gap(150.h),
                ...allElectionPosition.mapIndexed((element, index) {
                  List<Contestant> contestants = response.contestants
                      .where((item) =>
                  item.positionName.toLowerCase() ==
                      element.toLowerCase())
                      .toList();

                  String electionId = "";
                  String positionId = "";

                  for (var value in tempPositionEligibleList) {
                    if (value.positionName.toLowerCase() ==
                        element.toLowerCase()) {
                      electionId = value.electionId;
                      positionId = value.positionId;
                    }
                  }

                  ElectionDetails details = ElectionDetails(
                    id: response.id,
                    title: element,
                    description: response.description,
                    startDateAndTime: response.startDateAndTime,
                    endDateAndTime: response.endDateAndTime,
                    electionGuideLine: response.electionGuideLine,
                    electionStatus: response.electionStatus,
                    allowMemberToViewElectionDetails:
                    response.allowMemberToViewElectionDetails,
                    allowMemberToViewResult:
                    response.allowMemberToViewResult,
                    contestants: contestants,
                  );

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(VoteContestant(
                          electionPosition: details,
                          electionId: electionId,
                          positionId: positionId,
                        ));
                      },
                      child:
                      ElectionItemWithCandidate(details: details),
                    ),
                  );
                }),
                if (isLoadingMore)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
