import 'package:flutter/material.dart';

class WalkingBody extends StatefulWidget {
  const WalkingBody({super.key});

  @override
  State<WalkingBody> createState() => _WalkingBodyState();
}

class _WalkingBodyState extends State<WalkingBody> {
  @override
  Widget build(BuildContext context) {
    debugPrint('MYLOG build WalkingBody');
    return Scaffold(
      appBar: AppBar(
        title: Text('산책'),
      ),
    );
  }
}