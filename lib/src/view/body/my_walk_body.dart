import 'package:flutter/material.dart';

class MyWalkBody extends StatefulWidget {
  const MyWalkBody({super.key});

  @override
  State<MyWalkBody> createState() => _MyWalkBodyState();
}

class _MyWalkBodyState extends State<MyWalkBody> {
  @override
  Widget build(BuildContext context) {
    debugPrint('MYLOG build MyWalkBody');
    return Scaffold(
      appBar: AppBar(
        title: Text('내산책'),
      ),
    );
  }
}