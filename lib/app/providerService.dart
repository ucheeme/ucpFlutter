
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderWidget{
  static List<SingleChildWidget>blocProviders(){
    return [
      ChangeNotifierProvider<NavItemProvider>(create: (_) => NavItemProvider()),
      // BlocProvider(
      //     create: (BuildContext context)=>
      //         OnboardNewBloc(onboardingRepository: OnboardingRepository(),)
      // ),

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