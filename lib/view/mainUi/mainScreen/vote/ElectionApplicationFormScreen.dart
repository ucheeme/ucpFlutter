import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/data/repository/profileRepo.dart';
import 'package:ucp/utils/apputils.dart';
import 'package:ucp/utils/ucpLoader.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/repaymentWidgetRefund.dart';

import '../../../../bloc/vote/voting_bloc.dart';
import '../../../../data/model/request/applyAsContestant.dart';
import '../../../../data/model/response/allElections.dart';
import '../../../../utils/appStrings.dart';
import '../../../../utils/cameraOption.dart';
import '../../../../utils/colorrs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/designUtils/reusableWidgets.dart';
import '../../../bottomSheet/SuccessNotification.dart';
import 'electionWidget.dart';
import 'finalElectionApplicationScreen.dart';
File? contestantProfileImage;
File? contestantsManifesto;
class ElectionApplicationFormScreen extends StatefulWidget {
  PositionEligible positionEligibleList;
   ElectionApplicationFormScreen({super.key, required this.positionEligibleList});

  @override
  State<ElectionApplicationFormScreen> createState() => _ElectionApplicationFormScreenState();
}

class _ElectionApplicationFormScreenState extends State<ElectionApplicationFormScreen> {
  var fileNameController = TextEditingController();
  var electionNameController = TextEditingController();
  var reasonForRuningController = TextEditingController();
  var plansForCooperative = TextEditingController();
  late VotingBloc votingBloc;

  Future<void> _pickPdfs({TextEditingController? controller}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
        //  _selectedPdfs = result.files;
          contestantsManifesto = File(result.files.first.path??"");
          controller?.text = result.files.single.path??"";
          ucpFilePath = result.files.single.path??"";
        });
        print('Selected PDFs: ${result.files.runtimeType}');
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    votingBloc = BlocProvider.of<VotingBloc>(context);
    return BlocBuilder<VotingBloc, VotingState>(
  builder: (context, state) {
    if(state is VotingError){
      WidgetsBinding.instance.addPostFrameCallback((_){
        AppUtils.showSnack(state.errorResponse.message, context);
      });
      votingBloc.initial();
    }
    if(state is PositionApplied){
      WidgetsBinding.instance.addPostFrameCallback((_){
        showCupertinoModalBottomSheet(
          topRadius: Radius.circular(15.r),
          backgroundColor: AppColor.ucpWhite500,
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              if (Navigator.of(context).canPop()) {
                // Navigator.of(context).pop();
                Get.back();
                Get.to(FinalElectionInFomation(contestantName:electionNameController.text,));
              }});
            return Container(
              height: 400.h,
              color: AppColor.ucpWhite500,
              child: LoadLottie(lottiePath: UcpStrings.ucpLottieStampSeal,
                bottomText: state.response.message,
              ),
            );
          },
        ).then((value){
          Future.delayed(Duration(seconds: 2),(){

          });
        });
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
        child:GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: AppColor.ucpWhite10,
            bottomSheet: Container(
                height: 83.h,
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: const BoxDecoration(
                  color: AppColor.ucpBlue50,
                ),
                child: CustomButton(
                  onTap:(){
                    if(checkIfEmpty()){
                      votingBloc.add(ApplyAsACandidateForElectionEvent(
                          ApplyAsContestantForElectionRequest(
                              electionId: widget.positionEligibleList.electionId,
                              positionId: widget.positionEligibleList.positionId)
                      ));
                    }
                  },
                  borderRadius: 30.r,
                  buttonColor:checkIfEmpty()?AppColor.ucpBlue500:AppColor.ucpBlue300,
                  buttonText: UcpStrings.saveChangesTxt,
                  height: 51.h,
                  textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: AppColor.ucpWhite500,
                  ),
                  textColor: AppColor.ucpWhite500,
                )
            ),
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: 185.33.h,
                  color: AppColor.ucpBlue200.withOpacity(0.5),
                  child: Column(
                    children: [
                      Gap(44.h),
                      SizedBox(
                        height: 38.h,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal:20.w),
                          child: Row(
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
                                      height: 24.h,
                                      width: 24.w,
                                    ),
                                  ),
                                ),
                              ),
                              Gap(12.w),
                              Text("${UcpStrings.electionFormTxt} ",
                                style: CreatoDisplayCustomTextStyle.kTxtMedium
                                    .copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.ucpBlack500),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 79.33.h,
                        width: 343.w,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(UcpStrings.dashBoardB),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 35.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                border: Border.all(color:AppColor.ucpOrange200, width: 2.w),
                                shape: BoxShape.circle,
                                color:AppColor.ucpOrange500,
                              ),
                              child: Center(
                                child: Text(
                                  generateThreeLetterCode(widget.positionEligibleList.positionName),
                                  style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.ucpWhite500),
                                ),
                              ),
                            ),
                            Gap(10.w),
                            SizedBox(
                              height: 60.h,
                              width: 265.45.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                   // height: 12.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.positionEligibleList.positionName,
                                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                                              .copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.ucpWhite500),
                                        ),

                                        Text(NumberFormat.currency(name: 'NGN', )
                                            .format(0),
                                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                                              .copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.ucpOrange500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(6.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formatDate(widget.positionEligibleList.electionStartDate.toIso8601String()),
                                        style: CreatoDisplayCustomTextStyle.kTxtMedium
                                            .copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.ucpWhite500),
                                      ),
                                      Container(
                                        height: 20.33.h,
                                        width: 60.33.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color:AppColor.ucpOrange100,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 7.h,
                                              width: 7.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColor.ucpOrange500,
                                              ),
                                            ),
                                            Gap(4.w),
                                            Text("Pending",
                                              style: CreatoDisplayCustomTextStyle.kTxtMedium
                                                  .copyWith(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.ucpOrange500),
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Gap(20.63.h),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(UcpStrings.positionAppTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack500
                          ),
                        ),
                        Gap(14.h),
                        Text(UcpStrings.fillFormpTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack600
                          ),
                        ),
                        Gap(40.h),
                        Text(
                          UcpStrings.preferredNameForElection,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack700),
                        ),
                        height12,
                        CustomizedTextField(
                          readOnly: false,
                          isTouched: electionNameController.text.isNotEmpty,
                          textEditingController: electionNameController,
                          hintTxt: UcpStrings.enterNameForElection,
                          keyboardType: TextInputType.text,
                        ),
                        Text(
                          UcpStrings.uploadYourPhotoTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack700),
                        ),
                        height12,
                        CustomizedTextField(
                          readOnly: true,
                          textEditingController: fileNameController,
                          hintTxt: UcpStrings.uploadYourPhotoTxt,
                          keyboardType: TextInputType.name,
                          isTouched: fileNameController.text.isNotEmpty,
                          surffixWidget: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Icon(Icons.upload_file,size: 24.h,color: AppColor.ucpBlue500,),
                          ),
                          onTap: () async {

                            List<dynamic>response= await showCupertinoModalBottomSheet(
                                topRadius:
                                Radius.circular(20.r),
                                context: context,
                                backgroundColor:AppColor.ucpWhite500,
                                shape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(24.r),
                                      topLeft: Radius.circular(24.r)),
                                ),
                                builder: (context) => SizedBox(
                                    height: 313.h,
                                    child: CameraOption())
                            );
                            if(response[1]!=null){
                              //Save Contestant Profile Image
                              contestantProfileImage= response[0];
                              setState(() {
                                fileNameController.text = response[0].toString();
                              });
                              ucpFilePath2 = response[0].path;
                            }
                          },
                        ),
                        Gap(12.h),
                        Text(
                          UcpStrings.reasonForRunningTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack700),
                        ),
                        height12,
                        MultilineTextInput(
                          maxLines: null,
                          hintText: 'Type your text here...',
                          hintStyle: TextStyle(fontSize: 12.sp),
                          textStyle: TextStyle(fontSize: 12.sp),
                          controller: reasonForRuningController,
                          // onChanged: (text) {
                          //   saveToAccountRequest.description = text;
                          // },
                        ),
                        Gap(12.h),
                        Text(
                          UcpStrings.plansForCoperativeTxt,
                          style: CreatoDisplayCustomTextStyle.kTxtMedium
                              .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.ucpBlack700),
                        ),
                        height12,
                        CustomizedTextField(
                          readOnly: true,
                          textEditingController: plansForCooperative,
                          hintTxt: UcpStrings.uploadYourPlansFourCoporativeTxt,
                          keyboardType: TextInputType.name,
                          isTouched: plansForCooperative.text.isNotEmpty,
                          surffixWidget: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Icon(Icons.upload_file,size: 24.h,color: AppColor.ucpBlue500,),
                          ),
                          onTap: () async {
                            _pickPdfs(controller:plansForCooperative);
                           //  List<dynamic>response= await showCupertinoModalBottomSheet(
                           //      topRadius:
                           //      Radius.circular(20.r),
                           //      context: context,
                           //      backgroundColor:AppColor.ucpWhite500,
                           //      shape:RoundedRectangleBorder(
                           //        borderRadius: BorderRadius.only(
                           //            topRight: Radius.circular(24.r),
                           //            topLeft: Radius.circular(24.r)
                           //        ),
                           //      ),
                           //      builder: (context) => SizedBox(
                           //          height: 313.h,
                           //          child: CameraOption())
                           //  );
                           //  if(response[1]!=null){
                           //    print("This is image ${response[1]}");
                           //    setState(() {
                           //      plansForCooperative.text = response[0].toString();
                           //    });
                           //  }
                          },
                        ),
                        Gap(60.h)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  },
);
  }
  bool checkIfEmpty(){
    if(electionNameController.text.isEmpty){
      return false;
  }
    if(reasonForRuningController.text.isEmpty){
      return false;
    }
    if(plansForCooperative.text.isEmpty){
      return false;
    }
    if(fileNameController.text.isEmpty){
      return false;
    }
    return true;
  }
}
