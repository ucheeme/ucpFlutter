import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';

import '../colorrs.dart';

class AnimatePieChart extends StatefulWidget {
  Map<String, double> dataMap;
  List<Color> colorList;
  double total;
  AnimatePieChart({super.key,required this.total, required this.dataMap, required this.colorList});

  @override
  State<AnimatePieChart> createState() => _AnimatePieChartState();
}

class _AnimatePieChartState extends State<AnimatePieChart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PieChart(
          degreeOptions: DegreeOptions(),
          totalValue: widget.total,
          chartLegendSpacing: 10,
          dataMap: widget.dataMap,
          colorList: widget.colorList,
          chartRadius:80.r,
          //ringStrokeWidth: 20.w,
          animationDuration: const Duration(seconds: 3),
          chartValuesOptions:  ChartValuesOptions(
            showChartValues: false,
          ),
          legendOptions: const LegendOptions(
              showLegends: false,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(fontSize: 15),
              legendPosition: LegendPosition.bottom,
              showLegendsInRow: false),
        ),
        Container(
          // height:40.h,
          // width: 40.w,
           // padding: EdgeInsets.all(1),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.ucpWhite600,),
          ),

        ),

      ]
    );
  }
}
