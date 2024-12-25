import 'package:custom_grid_view/custom_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ucp/utils/appStrings.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/constant.dart';
import 'package:ucp/utils/designUtils/reusableWidgets.dart';
import 'package:ucp/view/bottomSheet/welcomeToUcp.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<OnBoarding> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "textHeader": UcpStrings.onboardSplashHeader,
      "textBody":UcpStrings.onboardSplashBody,
      "image": "assets/images/onboarding.png"
    },
    {
      "textHeader": UcpStrings.onboard1SplashHeader,
      "textBody":  UcpStrings.onboard1SplashBody,
      "image":"assets/images/onboarding2.png"
    },
    {
      "textHeader":   UcpStrings.onboard2SplashHeader,
      "textBody":   UcpStrings.onboard2SplashBody,
      "image":"assets/images/onboarding3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColor.ucpWhite500 ,
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
            height50,
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin:  EdgeInsets.only(right: 5.w),
                            height: 6.h,
                            width: currentPage == index ? 35.w : 12.5.w,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? AppColor.ucpBlue400
                                  : AppColor.ucpBlue50,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                height30,
                SizedBox(
                  height:136.h,
                  width: 339.w,
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Text(splashData[currentPage]["textHeader"]!,
                        style: CreatoDisplayCustomTextStyle.kTxtBold.copyWith(
                          color: AppColor.ucpFullBlack,
                          fontWeight: FontWeight.w700,
                         // height: 14.16.h,
                            letterSpacing: -1,
                          fontSize: 22.sp
                        ),
                        ),
                        height10,
                        Text(splashData[currentPage]["textBody"]!,
                        style: CreatoDisplayCustomTextStyle.kTxtRegular.copyWith(
                          color: AppColor.ucpBlack700,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.03,
                          fontSize: 14.sp
                        ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  ),
                ),


                    ],
                  ),
                ),
              ),
              Gap(40.h),
              CustomButton(
                  height: 51.h,
                  borderRadius: 60.r,
                  buttonColor:AppColor.ucpBlue600,
                  textColor: AppColor.ucpWhite500,
                  textStyle: CreatoDisplayCustomTextStyle.kTxtMedium.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color:AppColor.ucpWhite500,
                  ),
                  onTap: () async {
                    await showCupertinoModalBottomSheet(
                   topRadius:Radius.circular(0.r),
                    backgroundColor: AppColor.ucpWhite500,
                    context: context,
                    builder: (context) {
                      return
                        Container(
                            height: 390.h,
                            color: AppColor.ucpWhite500,
                            child:  WelcomeToUcp()
                        );
                    });
                  }, buttonText: UcpStrings.getStartedTxt),
              Gap(21.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashContent extends StatefulWidget {
  const SplashContent({
    Key? key,
    this.image,
  }) : super(key: key);
  final String? image;
  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(40.h),
            decoration: BoxDecoration(
              image: DecorationImage(image:  Image.asset(
                "assets/images/onboarding_stars.png",
                width: 300.h,
                height: 275.9.w,
              ).image)
            ),
            child: Image.asset(
              widget.image??"",
              // fit: BoxFit.cover,
              width: 270.h,
              height: 269.9.w,
            ),
          ),
          // SizedBox(
          //   height: 265.h,
          //    width: 235.w,
          //   child: Image.asset(
          //     "assets/images/onboarding_stars.png",
          //     // fit: BoxFit.cover,
          //     // height: 265,
          //     // width: 235,
          //   ),
          // ),
          // Positioned(
          //   top: 50.h,
          //   //left: 5.w,
          //   child: Image.asset(
          //    widget.image??"",
          //     // fit: BoxFit.cover,
          //     width: 270.h,
          //     height: 269.9.w,
          //   ),
          // ),

        ],
      ),
    );
  }
}
