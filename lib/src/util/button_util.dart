import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonUtil {
  double width;
  double height;
  String title;
  Function onTap;

  ButtonUtil({
    required this.width,
    required this.height,
    required this.title,
    required this.onTap
  });
  
  Widget _basicButton({required Function onTap, required Color color, Border? border, required TextStyle titleStyle}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          border: border
        ),
        child: Text(
          title,
          style: titleStyle,
        ),
      ),
    );
  }
  
  TextStyle _textStyle({required Color color, double? fontSize}) {
    return TextStyle(
      color: color,
      fontSize: fontSize?? 16.sp,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500
    );
  }

  Widget filledButton1s() {
    return _basicButton(
        onTap: onTap,
        color: Palette.green6,
        titleStyle: _textStyle(color: Colors.white, fontSize: 14.sp)
    );
  }

  Widget filledButton1m() {
    return _basicButton(
        onTap: onTap,
        color: Palette.green6,
        titleStyle: _textStyle(color: Colors.white)
    );
  }

  Widget filledButton2() {
    return _basicButton(
        onTap: onTap,
        color: const Color(0xFF78DCB9),
        titleStyle: _textStyle(color: Colors.white)
    );
  }

  Widget filledButton3() {
    return _basicButton(
        onTap: onTap,
        color: Palette.green7,
        titleStyle: _textStyle(color: Colors.white)
    );
  }

  Widget filledButton4() {
    return _basicButton(
        onTap: onTap,
        color: Palette.outlinedButton2,
        titleStyle: _textStyle(color: Palette.outlinedButton3)
    );
  }

  Widget outlinedButton1() {
    return _basicButton(
        onTap: onTap,
        color: const Color(0xFFE5E5E5),
        titleStyle: _textStyle(color: Palette.green6),
        border: Border.all(width: 1, color: Palette.green6)
    );
  }

  Widget outlinedButton2() {
    return _basicButton(
        onTap: onTap,
        color: Palette.green1,
        titleStyle: _textStyle(color: Palette.green6),
        border: Border.all(width: 1, color: Palette.green6)
    );
  }

  Widget outlinedButton3() {
    return _basicButton(
        onTap: onTap,
        color: Palette.green2,
        titleStyle: _textStyle(color: Palette.green6),
        border: Border.all(width: 1, color: Palette.green6)
    );
  }

  Widget outlinedButton4() {
    return _basicButton(
        onTap: onTap,
        color: Palette.outlinedButton1,
        titleStyle: _textStyle(color: Palette.darkFont2),
        border: Border.all(width: 1, color: const Color(0xFFAEAEAE))
    );
  }

  Widget ghostButton1() {
    return _basicButton(
        onTap: onTap,
        color: const Color(0xFFE5E5E5),
        titleStyle: _textStyle(color: Palette.green6),
    );
  }

  Widget ghostButton2() {
    return _basicButton(
      onTap: onTap,
      color: Palette.ghostButton3,
      titleStyle: _textStyle(color: Palette.green6),
    );
  }

  Widget ghostButton3() {
    return _basicButton(
      onTap: onTap,
      color: Palette.ghostButton2,
      titleStyle: _textStyle(color: Palette.green6),
    );
  }

  Widget ghostButton4() {
    return _basicButton(
      onTap: onTap,
      color: Palette.ghostButton1,
      titleStyle: _textStyle(color: Palette.darkFont2),
    );
  }
}