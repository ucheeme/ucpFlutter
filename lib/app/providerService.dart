
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ucp/bloc/dashboard/dashboard_bloc.dart';
import 'package:ucp/bloc/onboarding/on_boarding_bloc.dart';
import 'package:ucp/bloc/transactionHistory/transaction_history_bloc.dart';
import 'package:ucp/data/repository/dashboardRepo.dart';
import 'package:ucp/data/repository/onboardingRepo.dart';

class ProviderWidget{
  static List<SingleChildWidget>blocProviders(){
    return [
      ChangeNotifierProvider<NavItemProvider>(create: (_) => NavItemProvider()),
      BlocProvider(create: (BuildContext context)=> OnBoardingBloc(onboardingRepository: OnboardingRepo(),)),
      BlocProvider(create: (BuildContext context)=> DashboardBloc(DashboardRepository(),)),
      BlocProvider(create: (BuildContext context)=> TransactionHistoryBloc(DashboardRepository(),),)
    ];
  }
}
class NavItemProvider extends ChangeNotifier{
  int selectedIndex = 0;
  void onItemTap(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}