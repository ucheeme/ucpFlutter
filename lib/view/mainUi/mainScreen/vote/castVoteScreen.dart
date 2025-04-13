import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucp/utils/colorrs.dart';

class CastVotScreen extends StatefulWidget {
  const CastVotScreen({super.key});

  @override
  State<CastVotScreen> createState() => _CastVotScreenState();
}

class _CastVotScreenState extends State<CastVotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColor.ucpWhite10,
    );
  }
}
