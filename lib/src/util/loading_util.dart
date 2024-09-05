import 'dart:async';

import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingUtil extends StatefulWidget {
  final String animationColor;
  const LoadingUtil({super.key, this.animationColor = 'black'});

  @override
  State<LoadingUtil> createState() => _LoadingUtilState();
}

class _LoadingUtilState extends State<LoadingUtil> {
  late final Color fontColor;
  late final Color backgroundColor;
  late final Timer timer;
  int dots = 1;

  @override
  void initState() {
    selectColors();
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

  void selectColors() {
    switch (widget.animationColor) {
      case 'black':
        fontColor = Palette.darkFont4;
        backgroundColor = Colors.white;
        break;
      case 'white':
        fontColor = Colors.white;
        backgroundColor = Palette.darkFont2;
        break;
      case 'green':
        fontColor = Palette.green6;
        backgroundColor = Colors.white;
        break;
      case 'grey':
        fontColor = Palette.darkFont2;
        backgroundColor = const Color(0xFFF2F2F2);
        break;
      default:
        fontColor = Colors.black;
        backgroundColor = Colors.white;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/loading_${widget.animationColor}.gif', width: 62.w),
          SizedBox(height: 23.5.h),
          Text(
            '잠시만 기다리라개${List.filled(dots, ".").join()}',
            style: TextStyle(
              color: fontColor,
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
