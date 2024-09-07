import 'dart:async';

import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingUtil extends StatefulWidget {
  const LoadingUtil({super.key});

  @override
  State<LoadingUtil> createState() => _LoadingUtilState();
}

class _LoadingUtilState extends State<LoadingUtil> {
  late final Timer timer;
  int dots = 1;

  @override
  void initState() {
    dotTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void dotTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (dots == 3) {
        dots = 1;
      } else {
        dots ++;
      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      color: const Color(0xFFF2F2F2),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/loading.gif', width: 62.w),
          SizedBox(height: 23.5.h),
          Text(
            '잠시만 기다리개${List.filled(dots, ".").join()}',
            style: TextStyle(
              color: Palette.darkFont2,
              fontSize: 12.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
    );
  }
}
