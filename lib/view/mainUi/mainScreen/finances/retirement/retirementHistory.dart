import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/utils/appExtentions.dart';
import 'package:ucp/utils/ucpLoader.dart';

import '../../../../../bloc/finance/finance_bloc.dart';
import '../../../../../data/model/response/withdrawTransactionHistory.dart';
import '../../../../../data/repository/FinanceRepo.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/sharedPreference.dart';
import '../../../../errorPages/noNotification.dart';
import '../financeWidgets.dart';

class RitirementRequestHistory extends StatefulWidget {
 
  RitirementRequestHistory({super.key,});

  @override
  State<RitirementRequestHistory> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<RitirementRequestHistory> {
  int pageNumber =1;
  int pageSize =10;
  late FinanceBloc bloc;
  List<WithdrawTransactionHistory> withdrawTransactionList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(tempRetirementHistory.isEmpty){
        bloc.add(GetRetirementHistory(PaginationRequest(
            pageSize: pageSize, currentPage: pageNumber))
        );
      }else{
        setState(() {
          withdrawTransactionList = tempRetirementHistory;
        });

      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<FinanceBloc>(context);
    return  BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        if (state is FinanceError) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppUtils.showSnack(
                "${state.errorResponse.message} ${state.errorResponse.data}",
                context);
          });
          bloc.initial();
        }
        if(state is FinanceMemberRetirementHistory){
          WidgetsBinding.instance.addPostFrameCallback((_){
            tempRetirementHistory = state.response.modelResult;
            withdrawTransactionList = state.response.modelResult;
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
          transparency: 0.5,
          child: SizedBox(
            height:MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Gap(140.h),
                  withdrawTransactionList.isEmpty?
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    height:600.h,
                    child: EmptyNotificationsScreen(
                        emptyHeader: UcpStrings.emptyRequestTxt,
                        emptyMessage: UcpStrings.emptyWithdrawalRequestTxt,
                        press: () {
                          bloc.add(GetRetirementHistory(PaginationRequest(
                              pageSize: pageSize, currentPage: pageNumber))
                          );
                        }
                    ),
                  )
                      :
                  Column(
                    children: withdrawTransactionList.mapIndexed((element, index)=>
                        Padding(
                          padding:  EdgeInsets.only(bottom: 12.h,left: 16.w,right: 16.w),
                          child: FinanceRequestListDesign(requestData: element,),
                        )
                    ) .toList(),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
