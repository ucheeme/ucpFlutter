import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucp/app/main/pages.dart';
import 'package:ucp/utils/apputils.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/loginFlow/loginD.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/signUpFlow/signupFirstpage.dart';


import '../../firebase_options.dart';
import '../../utils/authManager.dart';
import '../../utils/constant.dart';
import '../../utils/firebaseService.dart';
import '../../utils/sharedPreference.dart';


import '../../view/onboardingSplash/onBoarding.dart';
import '../../view/onboardingSplash/splashScreen.dart';
import '../apiService/overrideHttp.dart';
import '../customAnimations/animationManager.dart';
import '../flavour/flavour.dart';
import '../flavour/locatot.dart';
import '../providerService.dart';
final AuthManager authManager = AuthManager();
String firebaseToken="";
void mainCommon(AppFlavorConfig config) async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print(details.toString());
    }
  };

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseService().initNotifications();
  } catch (e) {
    AppUtils.debug("Failed to initialize Firebase: $e");
  }

  statusBarTheme();
  await MySharedPreference.init();
  setUpLocator(config);

  
  final hasLaunchedBefore = MySharedPreference.getHasLaunched();
 
  if (!hasLaunchedBefore) {
    await MySharedPreference.setHasLaunched(true);
  }
 runApp(MultiProvider(providers:ProviderWidget.blocProviders(),
      child: MyApp(initialRoute: hasLaunchedBefore ? Pages.login : Pages.initial)));
 
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  
  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;
  @override
  void initState() {
    getToken();
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
  getToken()async{
    String? deviceToken= await FirebaseService().getFirebaseToken();
    firebaseToken = deviceToken!;
    AppUtils.debug("This is Firbase token: $deviceToken");
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



