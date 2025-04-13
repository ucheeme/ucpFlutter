import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/bloc/finance/loanController.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/loan/repayLoanBreakDown.dart';

import '../../../../../bloc/finance/finance_bloc.dart';
import '../../../../../data/model/response/loanApplicationResponse.dart';
import '../../../../../data/model/response/usersLoans.dart';
import '../../../../../data/repository/FinanceRepo.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../../utils/sharedPreference.dart';
import '../../../../../utils/ucpLoader.dart';
import '../../../../errorPages/noNotification.dart';
import 'loanHistoryWidget.dart';
import 'loanRequestDetails.dart';
import 'loanScheduleDetails.dart';
import 'loanWidgetScreen.dart';

// class UserCurrentLoans extends StatefulWidget {
//   LoanController controller;
//    UserCurrentLoans({super.key,required this.controller});
//
//   @override
//   State<UserCurrentLoans> createState() => _UserCurrentLoansState();
// }
//
// class _UserCurrentLoansState extends State<UserCurrentLoans> {
//   late FinanceBloc bloc;
//   int? selectedIndex;
//   int currentPage = 1;
//   int pageSize = 10;
//   int totalPageSize = 0;
//   bool hasMore = true;
//   ScrollController scrollController = ScrollController();
//   List<UserLoans> allUserLoan =[];
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_){
//       print("I am here");
//       bloc.add(GetAllUserLoansEvent(PaginationRequest(currentPage: currentPage,pageSize: pageSize)));
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     bloc = BlocProvider.of<FinanceBloc>(context);
//     return BlocBuilder<FinanceBloc, FinanceState>(
//       builder: (context, state) {
//         if (state is FinanceError) {
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             AppUtils.showSnack(
//                 "${state.errorResponse.message} ${state.errorResponse.data}",
//                 context);
//           });
//           bloc.initial();
//         }
//         if (state is AllUserLoansState) {
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             totalPageSize=state.response.totalCount;
//             for(var elements in state.response.modelResult){
//               allUserLoan.add(elements);
//             }
//           });
//           bloc.initial();
//         }
//
//         if(state is LoanRefundScheduleBreakdownState){
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             Get.to(Repayloanbreakdown(
//               isRequestBreakdown: false,
//               bloc: bloc,
//               controller: widget.controller,
//               loanRequests: state.response,)
//             );
//           });
//           bloc.initial();
//         }
//
//         return UCPLoadingScreen(
//           visible: state is FinanceIsLoading,
//           loaderWidget: LoadingAnimationWidget.discreteCircle(
//             color: AppColor.ucpBlue500,
//             size: 40.h,
//             secondRingColor: AppColor.ucpBlue100,
//           ),
//           overlayColor: AppColor.ucpBlack400,
//           transparency: 0.2,
//           child:Scaffold(
//               backgroundColor: AppColor.ucpWhite10,
//               body: allUserLoan.isNotEmpty?
//               ListView(
//                 children: [
//                   Gap(110.h),
//                   NotificationListener<ScrollNotification>(
//                     onNotification: (scrollInfo) {
//                       if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//                         // Load more items when reaching the bottom
//                         if (totalPageSize > currentPage) {
//                           hasMore = true;
//                           currentPage++;
//                           bloc.add(GetAllLoanApplicationEvent(
//                               PaginationRequest(
//                                   currentPage: currentPage,pageSize: pageSize)
//                           ));
//                         }
//
//                       }
//                       return true;
//                     },
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height-100.h,
//                       child: ListView.builder(
//                         controller: scrollController,
//                         itemCount: allUserLoan.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: (){
//                               //allLoanRequests
//                               bloc.add(GetLoanScheduleBreakdownEvent(allUserLoan[index].accountNumber));
//                               // Get.to(LoanScheduleDetail(
//                               //   isRequestBreakdown: false,
//                               //   bloc: bloc,
//                               //   controller: widget.controller,
//                               //   loanRequests:allLoanRequests[index],)
//                               // );
//                             },
//                             child: Container(
//                               //  height: 185.h,
//                                 margin: EdgeInsets.symmetric(vertical: 8.h),
//                                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                                 child: LoanHistoryWidget(userLoans: allUserLoan[index])),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ):
//               SizedBox(
//                 height: 700.h,
//                 child: EmptyNotificationsScreen(
//                   press: (){
//                   bloc.add(GetAllLoanApplicationEvent(PaginationRequest(currentPage: currentPage,pageSize: pageSize)));
//                 },
//
//                   emptyMessage: "NO LOAN APPLICATIONS YET",
//                 ),
//               )
//
//           ),
//         );
//       },
//     );
//   }
// }
class UserCurrentLoans extends StatefulWidget {
  final LoanController controller;

  UserCurrentLoans({super.key, required this.controller});

  @override
  State<UserCurrentLoans> createState() => _UserCurrentLoansState();
}

class _UserCurrentLoansState extends State<UserCurrentLoans> {
  late FinanceBloc bloc;
  int currentPage = 1;
  final int pageSize = 10;
  int totalPageSize = 0;
  bool isLoadingMore = false;
  bool hasMore = true;
  ScrollController scrollController = ScrollController();
  List<UserLoans> allUserLoans = [];
  List<UserLoans> filteredLoans = [];
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<FinanceBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLoans();
    });
    scrollController.addListener(_onScroll);
  }

  void fetchLoans() {
    if (!isLoadingMore && hasMore) {
      setState(() => isLoadingMore = true);
      bloc.add(GetAllUserLoansEvent(PaginationRequest(currentPage: currentPage, pageSize: pageSize)));
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 && !isLoadingMore && hasMore) {
      currentPage++;
      fetchLoans();
    }
  }

  void _filterLoans() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredLoans = allUserLoans.where((loan) {
        return loan.accountProduct.toLowerCase().contains(query) && (selectedDate == null || loan.createdDate == selectedDate);
      }).toList();
    });
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _filterLoans();
      });
    }
  }
  bool isTouched = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is AllUserLoansState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            totalPageSize = state.response.totalCount;
            allUserLoans.addAll(state.response.modelResult);
            filteredLoans = List.from(allUserLoans);
            hasMore = allUserLoans.length < totalPageSize;
            isLoadingMore = false;
            setState(() {});
          });
        }
        if(state is LoanRefundScheduleBreakdownState){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Get.to(Repayloanbreakdown(
              isRequestBreakdown: false,
              bloc: bloc,
              controller: widget.controller,
              loanRequests: state.response,)
            );
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
          child: Scaffold(
            backgroundColor: AppColor.ucpWhite10,
            body: Column(
              children: [
                Gap(130.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomizedTextField(
                          textEditingController:searchController,
                          hintTxt: "Search by name",
                          keyboardType: TextInputType.text,
                          validator: (value) {},
                          surffixWidget: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              _filterLoans();
                            },
                          ),
                          isConfirmPasswordMatch: false,
                          isTouched: isTouched,
                          onTap: (){
                            setState(() {
                              isTouched = true;
                            });
                          },
                          onChanged: (value) => _filterLoans(),
                        )
                      ),
                      SizedBox(width: 10.w),
                      Padding(
                        padding:  EdgeInsets.only(bottom: 16.w),
                        child: CustomButton(
                          borderRadius: 10.r,
                          buttonColor: AppColor.ucpBlue500,
                          height: 50.h,
                          width: 50.w,
                          onTap: _selectDate,
                          buttonText: '',
                          child: const Icon(Icons.calendar_today,color: AppColor.ucpWhite500,),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredLoans.isNotEmpty
                      ? ListView.builder(
                    controller: scrollController,
                    itemCount: filteredLoans.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredLoans.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return GestureDetector(
                        onTap: () {
                          bloc.add(GetLoanScheduleBreakdownEvent(filteredLoans[index].accountNumber));
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: LoanHistoryWidget(userLoans: filteredLoans[index])),
                      );
                    },
                  )
                      : Center(child: SizedBox(
                    height: 300.h,
                        width: 300.w,
                        child: Column(
                          children: [
                            Text("No loans found"),
                            CustomButton(onTap: (){
                              bloc.add(GetAllLoanApplicationEvent(PaginationRequest(currentPage: 1,pageSize: 10)));
                            }, buttonText: "Refresh", buttonColor: AppColor.ucpBlue500,)
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
