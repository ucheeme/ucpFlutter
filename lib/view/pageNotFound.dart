import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colorrs.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        backgroundColor: AppColor.ucpWhite00,
        body: Center(child: Text("Page not found", style: TextStyle(fontSize: 20.h),))
    );
  }
}