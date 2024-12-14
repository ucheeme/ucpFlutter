import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Center(child: Text("Vote Screen"),),
    );
  }
}
