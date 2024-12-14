import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/sharedPreference.dart';
import 'package:ucp/view/mainUi/mainScreen/finances/finances.dart';
import 'package:ucp/view/mainUi/mainScreen/profile/profile.dart';
import 'package:ucp/view/mainUi/mainScreen/vote/vote.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/loginFlow/loginD.dart';
import 'dart:ui';

import '../../utils/colorrs.dart';
import 'mainScreen/home/home.dart';
import 'mainScreen/shop/shop.dart';

class ScrollableBlurBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ListView.builder(
            // padding: EdgeInsets.only(bottom: 80.0),
            itemCount: 50,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: AppColor.ucpBlue400,
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white70,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.notifications),
                        label: 'Notifications',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyBottomNav extends StatefulWidget {
  int? position;
  MyBottomNav({super.key, this.position});

  @override
  _MyBottomNavState createState() => _MyBottomNavState();
}

class _MyBottomNavState extends State<MyBottomNav> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    // Container(color: const Color(0xFFF5F8FE),),
    ShopScreen(),
    FinancesScreen(),
    // Screen displayed when the Floating Action Button is tapped
    VoteScreen(),
    ProfileScreen()
  ];
  late List<CameraDescription> cameras;

  @override
  void initState() {
    // Get the list of available cameras
    if (widget.position != null) {
      _currentIndex = widget.position!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _screens[_currentIndex],
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        height: 100.h,
        color: Colors.transparent,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: AppColor.ucpBlue25.withOpacity(0.7),
              child: Row(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  itemWidget(
                      onTap: () {
                        setState(() {
                          _currentIndex = 0; // Navigate to Screen 1
                        });
                      },
                      image: "home_selected",
                      unimage: "home_unselected",
                      title: "Home",
                      active: _currentIndex == 0),
                  itemWidget(
                      onTap: () {
                        setState(() {
                          _currentIndex = 1; // Navigate to Screen 1
                        });
                      },
                      image: "storefront_selected",
                      unimage: "store_unselected",
                      title: "Shop",
                      badgeCount: dashboardResponse?.shopInventory,
                      index: 1,
                      active: _currentIndex == 1),
                  itemWidget(
                      onTap: () {
                        setState(() {
                          _currentIndex = 2; // Navigate to Screen 2
                        });
                      },
                      image: "finance_selected",
                      unimage: "finance_unselected",
                      title: "Finances",
                      active: _currentIndex == 2),
                  itemWidget(
                      onTap: () {
                        setState(() {
                          _currentIndex = 3; // Navigate to Screen 4
                        });
                      },
                      image: "vote_selected",
                      unimage: "vote_unselected",
                      title: "Vote",
                      active: _currentIndex == 3),
                  itemWidget(
                      onTap: () {
                        setState(() {
                          _currentIndex = 4; // Navigate to Screen 5
                        });
                      },
                      userProfileImage: null,
                      title: "Profile",
                      active: _currentIndex == 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  GestureDetector itemWidget(
      {required Function() onTap,
      required String title,
      String? image,
      String? unimage,
        int? badgeCount,
        int? index,
      String? userProfileImage,
      required bool active,
      bool isUserImage = false}) {
    return GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            SizedBox(
              height: 65.h,
              width: 60.w,
            ),
            SizedBox(
              height: 58.h,
               width: 58.w,
              child: ColoredBox(
                color:Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Gap(3.h),
                    isUserImage
                        ? CircleAvatar(
                      child: Image.network(
                        userProfileImage ??
                            "https://unsplash.com/photos/a-person-using-a-laptop-computer-on-a-table-AoDMssi2UOU",
                        fit: BoxFit.cover,
                        height: 24.h,
                        width: 24.h,
                      ),
                    )
                        : Stack(children: [
                      active
                          ? Image.asset(
                        "assets/images/bottomNavIcons/selected/$image.png",
                        height: 22.h,
                        width: 22.w,
                      )
                          : Image.asset(
                        "assets/images/bottomNavIcons/unseleted/$unimage.png",
                        height: 22.h,
                        width: 22.w,
                      ),

                    ]
                    ),
                   Gap(5.h),
                    Text(
                      title,
                      style: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color:
                          active ? AppColor.ucpBlue600 : AppColor.ucpBlack600),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: index==1,
              child: Positioned(
                left: 28.w,
                bottom: 45.h,
                child: Container(
                  height: 20.h,
                 width: 20.w,
                // padding: EdgeInsets.all(2.h),
                  decoration: const BoxDecoration(
                    color: AppColor.ucpOrange500,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(badgeCount.toString().length>2?"99+":badgeCount.toString(),
                        style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 9.sp,
                            color: AppColor.ucpBlue25
                        )),
                  ),
                ),
              ),
            )
          ]
        ));
  }
}
