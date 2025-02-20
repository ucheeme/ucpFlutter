import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/bloc/vote/voting_bloc.dart';
import 'package:ucp/data/model/response/allElections.dart';
import 'package:ucp/utils/apputils.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/vote/electionScreen.dart';

import '../../../../utils/appStrings.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import 'electionResult.dart';
import 'eligiblePosition.dart';
List<PositionEligible> tempPositionEligibleList = [];
class ElectionMainScreen extends StatefulWidget {
  const ElectionMainScreen({super.key});

  @override
  State<ElectionMainScreen> createState() => _ElectionMainScreenState();
}

class _ElectionMainScreenState extends State<ElectionMainScreen> {
  bool isApplyPosition = true;
  bool isAllElection = false;
  bool isElectionResult = false;
  late VotingBloc votingBloc;
  int currentPage = 1;
  int pageSize = 50;
  List<PositionEligible> positionEligibleList = [];
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
        tempPositionEligibleList = state.allElections.modelResult;
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
        body: Stack(
          children: [
            selectedScreen(),
            UCPCustomAppBar(
                height: MediaQuery.of(context).size.height*0.18,
                appBarColor: AppColor.ucpWhite500,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(30.h),
                      Text(
                       isApplyPosition? UcpStrings.applyForAPositionTxt:
                       isAllElection?UcpStrings.castAVoteTxt:
                       UcpStrings.electionResultTxt,
                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                            .copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ucpBlack500),
                      ),
                      height14,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40.h,
                            width: 248.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: AppColor.ucpBlue25,
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isApplyPosition = true;
                                      isAllElection = false;
                                      isElectionResult = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    height: 32.h,
                                    width: 57.w,
                                    decoration: BoxDecoration(
                                      color: isApplyPosition
                                          ? AppColor.ucpBlue600
                                          : Colors.transparent,
                                      borderRadius:
                                      BorderRadius.circular(40.r),
                                    ),
                                    duration:
                                    const Duration(milliseconds: 500),
                                    child: Center(
                                      child: Text(
                                        UcpStrings.applyETxt,
                                        style: CreatoDisplayCustomTextStyle
                                            .kTxtMedium
                                            .copyWith(
                                          fontSize: 14.sp,
                                          color: isApplyPosition
                                              ? AppColor.ucpWhite500
                                              : AppColor.ucpBlack800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isApplyPosition = false;
                                      isAllElection = true;
                                      isElectionResult = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 400),
                                    height: 32.h,
                                    width: 84.w,
                                    decoration: BoxDecoration(
                                      color: isAllElection
                                          ? AppColor.ucpBlue600
                                          : Colors.transparent,
                                      borderRadius:
                                      BorderRadius.circular(40.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        UcpStrings.elcetionTxt,
                                        style: CreatoDisplayCustomTextStyle
                                            .kTxtMedium
                                            .copyWith(
                                          fontSize: 14.sp,
                                          color: isAllElection
                                              ? AppColor.ucpWhite500
                                              : AppColor.ucpBlack800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isApplyPosition = false;
                                      isAllElection = false;
                                      isElectionResult = true;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 500),
                                    height: 32.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                      color: isElectionResult
                                          ? AppColor.ucpBlue600
                                          : Colors.transparent,
                                      borderRadius:
                                      BorderRadius.circular(40.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        UcpStrings.resultEText,
                                        style: CreatoDisplayCustomTextStyle
                                            .kTxtMedium
                                            .copyWith(
                                          fontSize: 14.sp,
                                          color: isElectionResult
                                              ? AppColor.ucpWhite500
                                              : AppColor.ucpBlack800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  },
);
  }
  Widget selectedScreen() {
    if (isApplyPosition) {
      return const MemberEligiblePositionScreen();
    } else if (isAllElection) {
      return ElectionScreens();
    } else if (isElectionResult) {
      return ElectionResultScren();
    } else {
      return Text(UcpStrings.requestTxt);
    }
  }
}
