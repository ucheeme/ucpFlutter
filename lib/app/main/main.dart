import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:ucp/app/main/pages.dart';
import 'package:ucp/utils/apputils.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/loginFlow/loginD.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signupFirstpage.dart';


import '../../utils/constant.dart';
import '../../utils/sharedPreference.dart';


import '../../view/onboardingSplash/onBoarding.dart';
import '../../view/onboardingSplash/splashScreen.dart';
import '../apiService/overrideHttp.dart';
import '../customAnimations/animationManager.dart';
import '../flavour/flavour.dart';
import '../flavour/locatot.dart';
import '../providerService.dart';

void mainCommon(AppFlavorConfig config) async{
  WidgetsFlutterBinding.ensureInitialized();
  statusBarTheme();
  await MySharedPreference.init();
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.library == 'image resource service') {
      return;
    }
  };
  setUpLocator(config);
  // HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(providers:ProviderWidget.blocProviders(),
      child: const MyApp()));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;
  @override
  void initState() {
    super.initState();
   // WidgetsBinding.instance.addPostFrameCallback((_){
      _subscription = InternetConnection().onStatusChange.listen((status) {
        switch (status) {
          case InternetStatus.connected:
           // AppUtils.showSuccessSnack("Internet Connection Restored", context);
            break;
          case InternetStatus.disconnected:
           // AppUtils.showSuccessSnack("Internet Connection Disconnected", context);
            break;
        }
      });
      _listener = AppLifecycleListener(
        onResume: _subscription.resume,
        onHide: _subscription.pause,
        onPause: _subscription.pause,
      );
   // });

  }

  @override
  void dispose() {
    _subscription.cancel();
    _listener.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context,child)=>GetMaterialApp(
        title: 'UCP',
        getPages: [
          GetPage(name: Pages.initial, page:()=> SplashScreen(),curve: Curves.easeIn,),
          GetPage(name: Pages.onBoardingSplash, page:()=> OnBoarding(),curve: Curves.easeIn,),
          GetPage(name: Pages.signup, page:()=> SignUpFirstPage(),curve: Curves.easeIn,),
          GetPage(name: Pages.login, page:()=> LoginFlow(),curve: Curves.easeIn,),

        ],
        initialRoute: Pages.initial,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.ucpBlue500),
          useMaterial3: true,
        ),
        builder: (context, widget) {
          return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: widget!);
        },
        // home:  SplashScreen(),
      ),
    );
  }
}



