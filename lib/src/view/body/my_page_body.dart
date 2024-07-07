import 'package:flutter/material.dart';

class MyPageBody extends StatelessWidget {
  const MyPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('MYLOG build MyPageBody');
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 페이지'),
      ),
    );
  }
}
