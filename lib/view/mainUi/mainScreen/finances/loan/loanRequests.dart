import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/bloc/finance/finance_bloc.dart';
import 'package:ucp/bloc/finance/loanController.dart';
import 'package:ucp/data/repository/FinanceRepo.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/view/errorPages/noNotification.dart';

import '../../../../../data/model/response/loanApplicationResponse.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/designUtils/reusableWidgets.dart';
import '../../../../../utils/ucpLoader.dart';
import 'loanRequestDetails.dart';
import 'loanWidgetScreen.dart';

// class LoanRequestsScreen extends StatefulWidget {
//   LoanController controller;
//    LoanRequestsScreen({super.key, required this.controller});
//
//   @override
//   State<LoanRequestsScreen> createState() => _LoanRequestsScreenState();
// }
//
// class _LoanRequestsScreenState extends State<LoanRequestsScreen> {
//   late FinanceBloc bloc;
//   int? selectedIndex;
//   int currentPage = 1;
//   int pageSize = 10;
//   int totalPageSize = 0;
//   bool hasMore = true;
//   ScrollController scrollController = ScrollController();
//   List<LoanRequests> allLoanRequests =[];
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_){
//       bloc.add(GetAllLoanFrequenciesEvent());
//       bloc.add(GetAllLoanProductsEvent());
//       bloc.add(GetAllLoanApplicationEvent(PaginationRequest(currentPage: currentPage,pageSize: pageSize)));
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     bloc = BlocProvider.of<FinanceBloc>(context);
//     return BlocBuilder<FinanceBloc, FinanceState>(
//   builder: (context, state) {
//     if (state is FinanceError) {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//         AppUtils.showSnack(
//             "${state.errorResponse.message} ${state.errorResponse.data}",
//             context);
//       });
//       bloc.initial();
//     }
//     if (state is AllMemberLoanApplicationsState) {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//        totalPageSize=state.response.totalCount;
//        for(var elements in state.response.modelResult){
//          allLoanRequests.add(elements);
//        }
//       });
//       bloc.initial();
//     }
//     if (state is AllLoanFrequenciesState) {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//        tempLoanFrequencies = state.response;
//       });
//       bloc.initial();
//     }
//     if (state is AllLoanProductsState) {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//        tempLoanProducts = state.response;
//       });
//       bloc.initial();
//     }
//     return UCPLoadingScreen(
//       visible: state is FinanceIsLoading,
//       loaderWidget: LoadingAnimationWidget.discreteCircle(
//         color: AppColor.ucpBlue500,
//         size: 40.h,
//         secondRingColor: AppColor.ucpBlue100,
//       ),
//       overlayColor: AppColor.ucpBlack400,
//       transparency: 0.2,
//       child:Scaffold(
//         backgroundColor: AppColor.ucpWhite10,
//         body: allLoanRequests.isNotEmpty?
//         ListView(
//           children: [
//             Gap(90.h),
//             NotificationListener<ScrollNotification>(
//               onNotification: (scrollInfo) {
//                 if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//                   // Load more items when reaching the bottom
//                   if (totalPageSize > currentPage) {
//                     hasMore = true;
//                     currentPage++;
//                     bloc.add(GetAllLoanApplicationEvent(
//                         PaginationRequest(
//                             currentPage: currentPage,pageSize: pageSize)
//                     ));
//                   }
//
//                 }
//                 return true;
//               },
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height-100.h,
//                 child: ListView.builder(
//                   controller: scrollController,
//                   itemCount: allLoanRequests.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: (){
//                         //allLoanRequests
//                         Get.to(LoanRequestDetailScreen(
//                           isRequestBreakdown: false,
//                           bloc: bloc,
//                           controller: widget.controller,
//                           loanRequests:allLoanRequests[index],)
//                         );
//                       },
//                       child: Container(
//                         //  height: 185.h,
//                           margin: EdgeInsets.symmetric(vertical: 8.h),
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: LoanRequestWidget(loanRequests: allLoanRequests[index])),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ):
//             SizedBox(
//               height: MediaQuery.of(context).size.height-100.h,
//               child: EmptyNotificationsScreen(press: (){
//                 bloc.add(GetAllLoanApplicationEvent(PaginationRequest(currentPage: currentPage,pageSize: pageSize)));
//               },
//                 emptyHeader: "NO LOAN APPLICATION",
//               emptyMessage: "",
//               ),
//             )
//
//       ),
//     );
//   },
// );
//   }
// }
class LoanRequestsScreen extends StatefulWidget {
  final LoanController controller;

  LoanRequestsScreen({super.key, required this.controller});

  @override
  State<LoanRequestsScreen> createState() => _LoanRequestsScreenState();
}

class _LoanRequestsScreenState extends State<LoanRequestsScreen> {
  late FinanceBloc bloc;
  int currentPage = 1;
  final int pageSize = 10;
  int totalPageSize = 0;
  bool isLoadingMore = false;

  final ScrollController scrollController = ScrollController();
  final List<LoanRequests> allLoanRequests = [];

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<FinanceBloc>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(GetAllLoanFrequenciesEvent());
      bloc.add(GetAllLoanProductsEvent());
      bloc.add(GetAllLoanApplicationEvent(PaginationRequest(currentPage: currentPage, pageSize: pageSize)));
    });

    scrollController.addListener(_loadMoreData);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _loadMoreData() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      if (currentPage * pageSize < totalPageSize && !isLoadingMore) {
        setState(() {
          isLoadingMore = true;
        });
        currentPage++;
        bloc.add(GetAllLoanApplicationEvent(PaginationRequest(currentPage: currentPage, pageSize: pageSize)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppUtils.showSnack("${state.errorResponse.message} ${state.errorResponse.data}", context);
          });
          bloc.initial();
        }

        if (state is AllMemberLoanApplicationsState) {
          totalPageSize = state.response.totalCount;
          allLoanRequests.addAll(state.response.modelResult);
          isLoadingMore = false;
          bloc.initial();
        }

        if (state is AllLoanFrequenciesState) {
          tempLoanFrequencies = state.response;
          bloc.initial();
        }

        if (state is AllLoanProductsState) {
          tempLoanProducts = state.response;
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
            body: allLoanRequests.isNotEmpty
                ? Column(
              children: [
                Gap(90.h),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: allLoanRequests.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == allLoanRequests.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            LoanRequestDetailScreen(
                              isRequestBreakdown: false,
                              bloc: bloc,
                              controller: widget.controller,
                              loanRequests: allLoanRequests[index],
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: LoanRequestWidget(loanRequests: allLoanRequests[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
                : SizedBox(
              height: MediaQuery.of(context).size.height - 100.h,
              child: EmptyNotificationsScreen(
                press: () {
                  bloc.add(GetAllLoanApplicationEvent(PaginationRequest(currentPage: currentPage, pageSize: pageSize)));
                },
                emptyHeader: "NO LOAN APPLICATION",
                emptyMessage: "",
              ),
            ),
          ),
        );
      },
    );
  }
}
