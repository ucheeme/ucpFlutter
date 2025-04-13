import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ucp/utils/colorrs.dart';
import 'package:ucp/utils/ucpLoader.dart';

import '../../../../bloc/dashboard/dashboard_bloc.dart';
import '../../../../data/model/response/notificationResponse.dart';
import '../../../../utils/apputils.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sharedPreference.dart';
import 'notificationWidget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<UcpNotification> notificationList = [];
  late DashboardBloc bloc;
  @override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if(tempMemberNotifications.isEmpty){
      bloc.add(GetMemberNotifications());
    }else{
      setState(() {
        notificationList = tempMemberNotifications;
      });
    }
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bloc = context.read<DashboardBloc>();
    return BlocBuilder<DashboardBloc, DashboardState>(
  builder: (context, state) {
    if(state is MemberNotificationState){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        tempMemberNotifications = state.response;
        notificationList = state.response;
        setState(() {

        });
      });
      bloc.initial();
    }
    if(state is MemberNotificationClearState){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notificationList = [];
        tempMemberNotifications = [];
        setState(() {});
      });
      bloc.initial();
    }

    if(state is MarkNotificationReadState){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
        bloc.add(GetMemberNotifications());

      });
      bloc.initial();
    }

    if(state is DashboardError){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        AppUtils.showSnack(
            "${state.errorResponse.message} ${state.errorResponse.data??""}",
            context);
      });
      bloc.initial();
    }
    return UCPLoadingScreen(
      visible: state is DashboardIsLoading,
      loaderWidget: LoadingAnimationWidget.discreteCircle(
        color: AppColor.ucpBlue500,
        size: 40.h,
        secondRingColor: AppColor.ucpBlue100,
      ),
      overlayColor: AppColor.ucpBlack400,
      transparency: 0.2,
      child: Scaffold(
        backgroundColor: AppColor.ucpWhite10,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 40.w),
                      Center(
                          child: Text(
                            "Notifications",
                            style: CustomTextStyle.kTxtBold.copyWith(
                                color: AppColor.ucpBlack500, fontSize: 18.sp),
                          )),
                      IconButton(onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close,
                              color: AppColor.ucpBlack500)),
                    ],
                  ),
                  height16,
                  SizedBox(
                    height: 20.h,
                    width: 245.w,
                    child: GestureDetector(
                      onTap: () async {
                        bloc.add(ClearMemberNotifications());
                      },
                      child: Text(
                        "Clear all",
                        style: CustomTextStyle.kTxtRegular.copyWith(
                          fontSize: 14.sp,
                          color: AppColor.ucpDanger150,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 215.h,
                    child: notificationList.isEmpty
                        ? Center(
                      child: Text(
                        "YOU HAVE NO NOTIFICATION YET!",
                        style: CustomTextStyle.kTxtMedium.copyWith(
                            color: AppColor.ucpBlue500,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                      ),
                    )
                        : ListView.builder(
                        itemCount: notificationList.length,
                        itemBuilder: (context, position) {
                          return Slidable(
                            closeOnScroll: false,
                            // endActionPane: ActionPane(
                            //     motion: StretchMotion(),
                            //     children: [
                            //       Gap(20),
                            //       GestureDetector(
                            //         onTap: () {
                            //          bloc.add(ClearMemberNotifications());
                            //         },
                            //         child: Container(
                            //           height: 40.h,
                            //           width: 40.w,
                            //           padding: EdgeInsets.all(8.h),
                            //           decoration: BoxDecoration(
                            //               borderRadius:
                            //               BorderRadius.circular(4.r),
                            //               color: AppColor.ucpDanger75),
                            //           child: SvgPicture.asset(
                            //               "assets/images/trash.svg"),
                            //         ),
                            //       )
                            //     ]),
                            child: GestureDetector(
                              onTap: (){
                                bloc.add(NotificationReadEvent(notificationList[position].id));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 8.h),
                                height: 90.h,
                                child: NotificationWidgetDesign(
                                  notificationData: notificationList[position],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },
);
  }
}
