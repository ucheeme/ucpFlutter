import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ucp/bloc/finance/finance_bloc.dart';
import 'package:ucp/utils/appExtentions.dart';

import '../../../../../data/model/response/memberSavingAccount.dart';
import '../../../../../data/model/response/withdrawTransactionHistory.dart';
import '../../../../../data/repository/FinanceRepo.dart';
import '../../../../../utils/appStrings.dart';
import '../../../../../utils/apputils.dart';
import '../../../../../utils/colorrs.dart';
import '../../../../../utils/sharedPreference.dart';
import '../../../../errorPages/noNotification.dart';
import '../financeWidgets.dart';
class WithdrawRequestScreen extends StatefulWidget {
  FinanceBloc bloc;
   WithdrawRequestScreen({super.key,required this.bloc});

  @override
  State<WithdrawRequestScreen> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<WithdrawRequestScreen> {
  int pageNumber =1;
  int pageSize =10;
  List<WithdrawTransactionHistory> withdrawTransactionList = [];
@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_){
    if(tempWithdrawTransactionHistory.isEmpty){
      widget.bloc.add(GetWithdrawalHistoryEvent(PaginationRequest(
          pageSize: pageSize, currentPage: pageNumber))
      );
    }else{
      setState(() {
        withdrawTransactionList = tempWithdrawTransactionHistory;
      });

    }
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  BlocBuilder<FinanceBloc, FinanceState>(
  builder: (context, state) {
    if (state is FinanceError) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        AppUtils.showSnack(
            "${state.errorResponse.message} ${state.errorResponse.data}",
            context);
      });
      widget.bloc.initial();
    }
    if(state is FinanceMemberWithdrawalHistory){
      WidgetsBinding.instance.addPostFrameCallback((_){
        tempWithdrawTransactionHistory = state.response.modelResult;
        withdrawTransactionList = state.response.modelResult;
      });
      widget.bloc.initial();
    }
    return SizedBox(
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
                    widget.bloc.add(GetWithdrawalHistoryEvent(PaginationRequest(
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
    );
  },
);
  }
}

class WithdrawalRequestData{
  String requestTitle;
  String withdrawalAmount;
  DateTime withdrawalDate;
  String withdrawalStatus;
  WithdrawalRequestData({
      required this.requestTitle,
      required this.withdrawalAmount,
     required this.withdrawalDate,
      required this.withdrawalStatus});
}

class WithdrawalBackground{
  UserSavingAccounts userSavingAccounts;
  String backgroundImage;
  WithdrawalBackground({
    required this.userSavingAccounts,
    required this.backgroundImage});
}