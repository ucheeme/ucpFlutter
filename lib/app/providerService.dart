
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ucp/bloc/onboarding/on_boarding_bloc.dart';
import 'package:ucp/data/repository/onboarding.dart';

class ProviderWidget{
  static List<SingleChildWidget>blocProviders(){
    return [
      ChangeNotifierProvider<NavItemProvider>(create: (_) => NavItemProvider()),
      BlocProvider(
          create: (BuildContext context)=>
              OnBoardingBloc(onboardingRepository: OnboardingRepo(),)
      ),

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