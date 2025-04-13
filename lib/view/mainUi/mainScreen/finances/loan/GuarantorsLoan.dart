import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/bloc/finance/finance_bloc.dart';
import 'package:ucp/bloc/finance/loanController.dart';
import 'package:ucp/data/model/request/guarantorRequestDecision.dart';
import 'package:ucp/data/repository/FinanceRepo.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/view/errorPages/noNotification.dart';

import '../../../../../data/model/response/guarantorRequestList.dart';
import '../../../../../data/model/response/loanApplicationResponse.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../../utils/ucpLoader.dart';
import '../../../../bottomSheet/SuccessNotification.dart';
import '../../../../bottomSheet/guarantorResponseSheet.dart';
import 'guarantorWidget.dart';
import 'loanRequestDetails.dart';
import 'loanWidgetScreen.dart';

class LoanGuarantors extends StatefulWidget {
  const LoanGuarantors({super.key});

  @override
  State<LoanGuarantors> createState() => _LoanGuarantorsState();
}

class _LoanGuarantorsState extends State<LoanGuarantors> {
  late FinanceBloc bloc;
  int? selectedIndex;
  int currentPage = 1;
  int pageSize = 10;
  int totalPageSize = 0;
  bool hasMore = true;
  ScrollController scrollController = ScrollController();
  List<GuarantorRequestsLoanApplicant> allLoanRequests = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){

      bloc.add(GetAllLoanGuarantorsRequestEvent(PaginationRequest(
          currentPage: currentPage,
          pageSize: pageSize)));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<FinanceBloc>(context);
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(
                "${state.errorResponse.message} ${state.errorResponse.data}",
                context);
          });
          bloc.initial();
        }
        if(state is FinanceGuarantorAccepted){
          WidgetsBinding.instance.addPostFrameCallback((_){
            if(state.response.message.toLowerCase()=="guarantor accepted"){
              showCupertinoModalBottomSheet(
                topRadius: Radius.circular(15.r),
                backgroundColor: AppColor.ucpWhite500,
                context: context,
                builder: (context) {
                  return Container(
                    height: 400.h,
                    color: AppColor.ucpWhite500,
                    child: LoadLottie(lottiePath: UcpStrings.ucpLottieStampSeal,
                      bottomText: state.response.message,
                    ),
                  );
                },
              ).then((value){
                Get.back(result: true);
              });

            }else{
              AppUtils.showInfoSnack(state.response.message, context);
            }
          });
        }
        if(state is FinanceGuarantorRejected){
          WidgetsBinding.instance.addPostFrameCallback((_){
            if(state.response.message.toLowerCase()=="guarantor rejected"){
              AppUtils.showInfoSnack(state.response.message, context);
              // showCupertinoModalBottomSheet(
              //   topRadius: Radius.circular(15.r),
              //   backgroundColor: AppColor.ucpWhite500,
              //   context: context,
              //   builder: (context) {
              //     return Container(
              //       height: 400.h,
              //       color: AppColor.ucpWhite500,
              //       child: LoadLottie(lottiePath: UcpStrings.ucpLottieStampSeal,
              //         bottomText: state.response.message,
              //       ),
              //     );
              //   },
              // ).then((value){
              //   Get.back(result: true);
              // });
            }

            else{
              AppUtils.showInfoSnack(state.response.message, context);
            }
          });
        }
        if(state is LoanGuarantorRequestState){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            allLoanRequests = state.response.modelResult;
            setState(() {
              print("this is the length ${allLoanRequests.length}");
            });
          });
          bloc.initial();
        }
        return UCPLoadingScreen(
          visible: state is FinanceIsLoading,
          loaderWidget: LoadingAnimationWidget.discreteCircle(
            color: AppColor.ucpBlue500,
            size: 40.h,
            secondRingColor: AppColor.ucpBlue100,
          ),
          overlayColor: AppColor.ucpBlack400,
          transparency: 0.2,
          child:Scaffold(
              backgroundColor: AppColor.ucpWhite10,
              body: allLoanRequests.isNotEmpty?
              ListView(
                children: [
                  Gap(110.h),
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        // Load more items when reaching the bottom
                        if (totalPageSize > currentPage) {
                          hasMore = true;
                          currentPage++;
                          bloc.add(GetAllLoanApplicationEvent(
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
                        itemCount: allLoanRequests.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              //allLoanRequests
                              showCupertinoModalBottomSheet(
                                topRadius: Radius.circular(15.r),
                                backgroundColor: AppColor.ucpWhite500,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height:MediaQuery.of(context).size.height/1.8,
                                    color: AppColor.ucpWhite500,
                                    child: LoanApprovalScreen(
                                      state: state,
                                      requestsLoanApplicant: allLoanRequests[index],
                                      onTapAccept: (){
                                        //Get.back();
                                        bloc.add(GuarantorAcceptRequestEvent(GuarantorRequestDecision(id: allLoanRequests[index].id)));
                                      },
                                      onTapDecline: (){
                                       // Get.back();
                                        bloc.add(GuarantorRejectRequestEvent(GuarantorRequestDecision(id: allLoanRequests[index].id)));
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              //  height: 185.h,
                                margin: EdgeInsets.symmetric(vertical: 8.h),
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: GuarantorWidget(
                                  guarantorRequestsLoanApplicant: allLoanRequests[index],
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ):
              SizedBox(
                height: 700.h,
                child: EmptyNotificationsScreen(press: (){
                  bloc.add(GetAllLoanGuarantorsRequestEvent(
                      PaginationRequest(
                          currentPage: currentPage,pageSize: pageSize)));
                },
                  emptyHeader: "NO GUARANTOR REQUESTS",
                  emptyMessage: "",
                ),
              )

          ),
        );
      },
    );
  }
}
