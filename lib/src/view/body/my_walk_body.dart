import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
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
    return CommonScaffoldUtil(
        appBar: PopHeader(title: '내 산책', useBackButton: false),
        body: SizedBox(),
    );
  }
}