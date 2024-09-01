import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastPopupUtil {
  static final double deviceWidth = GlobalVariables.width;

  static void _base({
    required BuildContext context,
    required String content,
    required Color circleColor
  }) {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) {
        return FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 2000)).then((value) => true),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Navigator.pop(context);
            }
            final double width = 250.w;
            final double height = 40.h;
            final double circleSize = 24.h;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(left: 62.w, right: 62.w, bottom: 110.h),
              alignment: Alignment.bottomCenter,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: const Color(0xFF828282)
                ),
                padding: EdgeInsets.fromLTRB(
                  8.w,
                  7.h,
                  8.w,
                  7.h
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: circleSize,
                      width: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: circleColor
                      ),
                      child: Icon(
                        Icons.check,
                        size: circleSize - 4.h,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  static void notice({
    required BuildContext context,
    required String content
  }) {
    _base(
      context: context,
      content: content,
      circleColor: Palette.green6
    );
  }

  static void error({
    required BuildContext context,
    required String content
  }) {
    _base(
        context: context,
        content: content,
        circleColor: const Color(0xFFFF354D)
    );
  }

}