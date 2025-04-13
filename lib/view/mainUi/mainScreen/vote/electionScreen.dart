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
import 'electionListWidget.dart';

class ElectionScreens extends StatefulWidget {
  VotingBloc votingBloc;

  ElectionScreens({super.key, required this.votingBloc});

  @override
  State<ElectionScreens> createState() => _ElectionScreensState();
}

class _ElectionScreensState extends State<ElectionScreens> {
  late VotingBloc votingBloc;
  late ElectionDetails response;
  bool isInitial=false;
  @override
  void initState() {
    isInitial = true;
    votingBloc = widget.votingBloc;
   // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (tempPositionEligibleList.isEmpty) {
        votingBloc.add(GetEligiblePositionEvent(PaginationRequest(
            currentPage: 1, pageSize: 100)));
        // votingBloc.add(GetElectionDetailsEvent(tempPositionEligibleList.first.electionId));
      } else {
        votingBloc.add(
            GetElectionDetailsEvent(tempPositionEligibleList.first.electionId));
      }
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        if(state is ElectionDetailLoaded){
          response = state.response;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            print("this si it");
            setState(() {
              response = state.response;
              isInitial= false;
            });
          });
          votingBloc.initial();
        }
        if(state is PositionEligibleLoaded){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
           // positionEligibleList = state.allElections.modelResult;
            tempPositionEligibleList = state.allElections.modelResult;
            allElectionPosition.clear();
            allElectionPosition.addAll(tempPositionEligibleList.map((e) => e.positionName));
            votingBloc.add(
                GetElectionDetailsEvent(tempPositionEligibleList.first.electionId));
           // totalPageSize = state.allElections.totalCount;
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
            body: (state is VotingIsLoading||isInitial)?
            SizedBox():
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                Gap(150.h),

                Column(
                  children: allElectionPosition.mapIndexed((element, index){
                    ElectionDetails? details;
                    List<Contestant> contestants=[];
                    for(var item in response.contestants){
                      if(item.positionName.toLowerCase()==element.toLowerCase()){
                        contestants.add(item);
                      }
                    }
                    String electionId="";
                    String positionId="";
                    tempPositionEligibleList.forEach((vlue) {
                      if (vlue.positionName.toLowerCase() == element.toLowerCase()) {
                     electionId= vlue.electionId;
                     positionId= vlue.positionId;
                      }
                    });
                    details = ElectionDetails(
                        id: response.id,
                        title: element,
                        description: response.description,
                        startDateAndTime: response.startDateAndTime,
                        endDateAndTime: response.endDateAndTime,
                        electionGuideLine: response.electionGuideLine,
                        electionStatus: response.electionStatus,
                        allowMemberToViewElectionDetails: response.allowMemberToViewElectionDetails,
                        allowMemberToViewResult: response.allowMemberToViewResult,
                        contestants: contestants);
                    return Padding(
                      padding:  EdgeInsets.symmetric(vertical: 14.h),
                      child: GestureDetector(
                        onTap: (){
                         Get.to(VoteContestant(electionPosition: details!,
                         electionId: electionId,positionId: positionId,));
                        },
                        child: ElectionItemWithCandidate(
                            details: details),
                      ),
                    );
                  }).toList()),

                // SizedBox(
                //     height: 200.h,
                //     child: ElectionItemWithCandidate(
                //         details: response!),
                // )

              ],
            ),
          ),
        );
      },
    );
  }
}
