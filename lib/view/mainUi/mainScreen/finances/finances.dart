import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/colorrs.dart';

class FinancesScreen extends StatefulWidget {
  const FinancesScreen({super.key});

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.ucpWhite00,
      body:  Center(child: Text("Finance Screen"),),
    );
  }
}
