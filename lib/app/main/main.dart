import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:provider/provider.dart';
import 'package:ucp/app/main/pages.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/view/onboarding/onBoarding.dart';

import '../../utils/constant.dart';
import '../../utils/sharedPreference.dart';
import '../../view/onboarding/splashScreen.dart';
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
  runApp(MultiProvider(providers:ProviderWidget.blocProviders(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

        ],
        initialRoute: Pages.initial,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
