import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/bloc/finance/loanController.dart';

import '../../../../../bloc/finance/finance_bloc.dart';
import '../../../../../data/model/response/loanApplicationResponse.dart';
import '../../../../../data/model/response/usersLoans.dart';
import '../../../../../data/repository/FinanceRepo.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/sharedPreference.dart';
import '../../../../../utils/ucpLoader.dart';
import '../../../../errorPages/noNotification.dart';
import 'loanHistoryWidget.dart';
import 'loanRequestDetails.dart';
import 'loanScheduleDetails.dart';
import 'loanWidgetScreen.dart';

class UserCurrentLoans extends StatefulWidget {
  LoanController controller;
   UserCurrentLoans({super.key,required this.controller});

  @override
  State<UserCurrentLoans> createState() => _UserCurrentLoansState();
}

class _UserCurrentLoansState extends State<UserCurrentLoans> {
  late FinanceBloc bloc;
  int? selectedIndex;
  int currentPage = 1;
  int pageSize = 10;
  int totalPageSize = 0;
  bool hasMore = true;
  ScrollController scrollController = ScrollController();
  List<UserLoans> allUserLoan =[];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      print("I am here");
      bloc.add(GetAllUserLoansEvent(PaginationRequest(currentPage: currentPage,pageSize: pageSize)));
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
        if (state is AllUserLoansState) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            print("Wow");
            totalPageSize=state.response.totalCount;
            for(var elements in state.response.modelResult){
              allUserLoan.add(elements);
            }
          });
          bloc.initial();
        }

        if(state is LoanRefundScheduleBreakdownState){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Get.to(LoanScheduleDetail(
              isRequestBreakdown: false,
              bloc: bloc,
              controller: widget.controller,
              loanRequests: state.response,)
            );
          });
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
              body: allUserLoan.isNotEmpty?
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
                        itemCount: allUserLoan.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              //allLoanRequests
                              bloc.add(GetLoanScheduleBreakdownEvent(allUserLoan[index].accountNumber));
                              // Get.to(LoanScheduleDetail(
                              //   isRequestBreakdown: false,
                              //   bloc: bloc,
                              //   controller: widget.controller,
                              //   loanRequests:allLoanRequests[index],)
                              // );
                            },
                            child: Container(
                              //  height: 185.h,
                                margin: EdgeInsets.symmetric(vertical: 8.h),
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: LoanHistoryWidget(userLoans: allUserLoan[index])),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ):
              EmptyNotificationsScreen(press: (){
                bloc.add(GetAllLoanApplicationEvent(PaginationRequest(currentPage: currentPage,pageSize: pageSize)));
              },
                emptyMessage: "NO LOAN APPLICATIONS YET",
              )

          ),
        );
      },
    );
  }
}
