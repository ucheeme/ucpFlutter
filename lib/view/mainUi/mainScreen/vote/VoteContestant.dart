import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/ucpLoader.dart';

import '../../../../bloc/vote/voting_bloc.dart';
import '../../../../data/model/request/castVoteRequest.dart';
import '../../../../data/model/response/electionDetailResponse.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableFunctions.dart';
import '../../../bottomSheet/SuccessNotification.dart';
import 'ElectionApplicationFormScreen.dart';

class VoteContestant extends StatefulWidget {
  ElectionDetails electionPosition;
  String electionId;
  String positionId;

  VoteContestant(
      {super.key,
      required this.electionPosition,
      required this.electionId,
      required this.positionId});

  @override
  State<VoteContestant> createState() => _VoteContestantState();
}

class _VoteContestantState extends State<VoteContestant> {
  String hoursString = "";
  String daysString = "";
  String minutesString = "";
  String secondsString = "";
  String remainingTime = "";
  bool isPassed = false;
  bool isOn = true;
  late VotingBloc voteBloc;
  bool isLoading=false;
  String checkText = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // setState(() {
      //   isLoading = true;
      // });
      remainingTime = formatTime(
          endDateS: widget.electionPosition.endDateAndTime.toIso8601String(),
          startDateS:
              widget.electionPosition.startDateAndTime.toIso8601String());
      if(remainingTime.isNotEmpty){
        // checkText= checks();
        //
        // setState(() {
        //   checkText= checkText;
        //   isLoading=false;
        // });
      }
    });
    super.initState();
  }

  formatTime({String endDateS = "", String startDateS = ""}) {
    final DateTime startDate = DateTime.parse(startDateS);
    final DateTime endDate = DateTime.parse(endDateS);

    // Timer to update every second.
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final DateTime now = DateTime.now();

      if (now.isBefore(startDate)) {
        // Current time is before the start date.
        setState(() {

          isPassed = false;
          isOn = false;
          remainingTime = dateFormat(startDate);

        });
        print("Event has not started yet. Starts on: ${dateFormat(startDate)}");
      }
      if (now.isAfter(endDate)) {
        // Current time is after the end date.
        setState(() {
          isPassed = true;
          isOn = false;
          remainingTime = dateFormat(endDate);
        });
        // print("Event ended on: ${dateFormat(endDate)}");
        timer.cancel();
      } else {
        // Current time is between start and end dates.
        final Duration remaining = endDate.difference(now);
        final int days = remaining.inDays;
        final int hours = remaining.inHours % 24;
        final int minutes = remaining.inMinutes % 60;
        final int seconds = remaining.inSeconds % 60;
        final String countdown = "${days}d ${hours}h ${minutes}m ${seconds}s";
        setState(() {
          isPassed = false;
          isOn = true;
          remainingTime = countdown;
        });
      }
    });

    //  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    voteBloc = BlocProvider.of<VotingBloc>(context);
    return BlocBuilder<VotingBloc, VotingState>(
      builder: (context, state) {
        if (state is VotingError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (state.errorResponse.message.toLowerCase() !=
                "no active election") {
              AppUtils.showSnack(state.errorResponse.message, context);
            }
          });
          voteBloc.initial();
        }
        if (state is VotedForCandidate) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showCupertinoModalBottomSheet(
              topRadius: Radius.circular(15.r),
              backgroundColor: AppColor.ucpWhite500,
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 4), () {
                  if (Navigator.of(context).canPop()) {
                    // Navigator.of(context).pop();
                    Get.back();
                  }
                });
                return Container(
                  height: 450.h,
                  color: AppColor.ucpWhite500,
                  child: LoadLottie(
                    lottiePath: UcpStrings.ucpLottieVoteMade,
                    bottomText: state.response.message,
                  ),
                );
              },
            ).then((value) {
              Future.delayed(Duration(seconds: 2), () {});
            });
          });
          voteBloc.initial();
        }
        return UCPLoadingScreen(
          visible:isLoading==true|| state is VotingIsLoading,
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
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 215.h,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          // UcpStrings.votingIcon,fit: BoxFit.cover,
                          UcpStrings.dashBoardB, fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 180.h,
                        left: 15.w,
                        child: Container(
                          height: 20.h,
                          width: 155.w,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: AppColor.ucpOrange50,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 12.h,
                                width: 12.w,
                                child: Image.asset(UcpStrings.ucpTimer),
                              ),
                              Gap(3.34.w),
                              Text(
                                checks(),
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                        color: AppColor.ucpBlack600,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp),
                              ),
                              Gap(3.34.w),
                              Text(
                                remainingTime,
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                        color: checksColor(),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50.h,
                        left: 15.w,
                        child: SizedBox(
                          height: 123.h,
                          width: 343.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: SizedBox(
                                  height: 24.h,
                                  width: 24.w,
                                  child: ColoredBox(
                                    color: Colors.transparent,
                                    child: Image.asset(
                                      UcpStrings.ucpBackArrow,
                                      color: AppColor.ucpWhite500,
                                      height: 24.h,
                                      width: 24.w,
                                    ),
                                  ),
                                ),
                              ),
                              Gap(20.h),
                              Text(
                                "${widget.electionPosition.title} election",
                                style: CreatoDisplayCustomTextStyle.kTxtBold
                                    .copyWith(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.ucpWhite500),
                              ),
                              SizedBox(
                                height: 45.h,
                                width: 343.w,
                                child: Text(
                                  UcpStrings.voteTxt,
                                  style: CreatoDisplayCustomTextStyle.kTxtMedium
                                      .copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.ucpBlue50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  height16,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: widget.electionPosition.contestants
                          .mapIndexed((electionPosition, index) {
                        return Container(
                          height: 56.h,
                          width: 343.w,
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          child: CandidateWidget(
                            positionId: widget.positionId,
                            electionId: widget.electionId,
                            position: index,
                            voteBloc: voteBloc,
                            canVote: !["closed on", "starts on"].contains(checks().toLowerCase()),
                            contestant: electionPosition,
                            electionDetails: widget.electionPosition,
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  String checks() {

    if (!isPassed && !isOn) {
      return "Starts on";
    }
    if (!isPassed && isOn) {
      return "Closes in";
    }
    if (isPassed && !isOn) {
      return "Closed on";
    }

    return "";
  }

  Color checksColor() {
    if (!isPassed && !isOn) {
      return AppColor.ucpSuccess50;
    }
    if (!isPassed && isOn) {
      return AppColor.ucpOrange400;
    }
    if (isPassed && !isOn) {
      return AppColor.ucpDanger150;
    }
    return Colors.transparent;
  }
}

class CandidateWidget extends StatefulWidget {
  Contestant contestant;
  int position;
  bool canVote;
  VotingBloc voteBloc;
  ElectionDetails electionDetails;
  String electionId;
  String positionId;

  CandidateWidget({
    super.key,
    required this.electionId,
    required this.positionId,
    required this.voteBloc,
    required this.contestant,
    required this.electionDetails,
    required this.position,
    required this.canVote,
  });

  @override
  State<CandidateWidget> createState() => _CandidateWidgetState();
}

class _CandidateWidgetState extends State<CandidateWidget> {
  late Uint8List imageBytes1;

  @override
  void initState() {
    print(widget.canVote);
    setImage();
    super.initState();
  }

  setImage() {
    final Uint8List imageBytes =
        base64Decode(widget.contestant.profileImageBase64);
    setState(() {
      imageBytes1 = imageBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Row(
        children: [
          // Profile Image
          ClipOval(
            child: Image.memory(
              imageBytes1, // Replace with actual image URL or AssetImage
              height: 46.h,
              width: 46.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25.w,
                  child: Text(
                    widget.contestant.fullName,
                    overflow: TextOverflow.ellipsis, // Replace with actual name
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontSize: 14.sp,
                      color: AppColor.ucpBlack500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  "Member", // Replace with actual name
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    fontSize: 12.sp,
                    color: AppColor.ucpBlack800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // "About" Button
          GestureDetector(
            onTap: () {
              // Handle "About" button tap
              showCupertinoModalBottomSheet(
                topRadius: Radius.circular(15.r),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(22.r)),
                ),
                builder: (context) {
                  return SizedBox(
                    height: 650.h,
                    child: VoteContestantAbout(
                      electionId: widget.electionId,
                      positionId: widget.positionId,
                      voteBloc: widget.voteBloc,
                      canVote: widget.canVote,
                      contestant: widget.electionDetails,
                      position: widget.position,
                    ),
                  );
                },
                context: context,
              );
            },
            child: Container(
              width: 53.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: AppColor.ucpWhite50,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Center(
                child: Text(
                  "About",
                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    color: AppColor.ucpBlack500,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // "Vote" Button
          GestureDetector(
            onTap: () {
              widget.canVote
                  ? widget.voteBloc.add(VoteCandidateEvent(CastVote(
                      electionId: widget.electionId,
                      positionId: widget.positionId,
                      contestantIds: [widget.contestant!.id])))
                  : null;
              // Handle "About" button tap
              // For example, navigate to a detailed view of the contestant
            },
            child: Container(
              width: 53.w,
              height: 24.h,
              decoration: BoxDecoration(
                color:
                    widget.canVote ? AppColor.ucpBlue500 : AppColor.ucpBlue100,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Center(
                child: Stack(children: [
                  Text(
                    "Vote",
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      color: widget.canVote
                          ? AppColor.ucpWhite00
                          : AppColor.ucpWhite10,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Visibility(
                    visible: !widget.canVote,
                    child: Positioned(
                      left: 4.w,
                      child: Icon(
                        Icons.block,
                        color: AppColor.ucpDanger150,
                        size: 20.h,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoteContestantAbout extends StatefulWidget {
  ElectionDetails contestant;
  VotingBloc voteBloc;
  int position;
  String? electionId;
  String? positionId;
  bool canVote;
  VoteContestantAbout({
    super.key,
    required this.canVote,
    required this.contestant,
    required this.position,
    required this.voteBloc,
    this.positionId,
    this.electionId,
  });

  @override
  State<VoteContestantAbout> createState() => _VoteContestantAboutState();
}

class _VoteContestantAboutState extends State<VoteContestantAbout> {
  bool isLoading = false;
  Uint8List? transparentImageBytes;

  @override
  void initState() {
    selectedIndex = widget.position;
    selectedContestant = widget.contestant.contestants[selectedIndex];
    super.initState();
    BackgroundRemover.instance.initializeOrt();
  }

  late Uint8List imageBytes1;

  setImage(String image) {
    final Uint8List imageBytes = base64Decode(image);
    print("yeaaaaaa");
    setState(() {
      imageBytes1 = imageBytes;
    });
    return imageBytes1;
  }

  Contestant? selectedContestant;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.ucpWhite10,
      body: Stack(children: [
        SizedBox(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            //padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              Container(
                  height: 50.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: AppColor.ucpBlue100,
                    // color: AppColor.ucpBlue500,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                    ),
                  ),
                  child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      scrollDirection: Axis.horizontal,
                      children: widget.contestant.contestants
                          .mapIndexed((contestant, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedContestant = contestant;
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: index == selectedIndex
                                  ? AppColor.ucpBlue500
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
                              child: Text(
                                contestant.fullName,
                                style: CreatoDisplayCustomTextStyle.kTxtBold
                                    .copyWith(
                                  color: index == selectedIndex
                                      ? AppColor.ucpWhite00
                                      : AppColor.ucpBlack500,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList())),
              Gap(16.h),
              Container(
                height: 202.h,
                width: 343.w,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  image: DecorationImage(
                      image: MemoryImage(
                          setImage(selectedContestant!.profileImageBase64)),
                      fit: BoxFit.cover),
                ),
              ),
              height20,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(selectedContestant?.fullName ?? "",
                    style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.sp,
                      color: AppColor.ucpBlack500,
                    )),
              ),
              Container(
                height: 400.h,
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child:
                    SfPdfViewer.network(selectedContestant!.manifestoDocument!),
              )
            ],
          ),
        ),
        Positioned(
          top: 570.h,
          left: 20.w,
          right: 20.w,
          child: GestureDetector(
            onTap: () {
              // setState(() {});
              widget.canVote?
              widget.voteBloc.add(VoteCandidateEvent(CastVote(
                  electionId: widget.electionId ?? "",
                  positionId: widget.positionId ?? "",
                  contestantIds: [selectedContestant!.id]))):null;
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              height: 59.h,
              width: 343.w,
              decoration: BoxDecoration(
                color:widget.canVote? AppColor.ucpBlue500: AppColor.ucpBlue100,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Center(
                child: Text(
                  "Vote ${selectedContestant?.fullName}",
                  style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                    color: AppColor.ucpWhite00,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
