import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';

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
            final double width = deviceWidth - 50;
            final double height = width / 250 * 40;
            final double circleSize = width / 250 * 24;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.only(left: 25, right: 25),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xFF828282)
                ),
                padding: EdgeInsets.fromLTRB(
                    (height - circleSize) / 2 + 1,
                    (height - circleSize) / 2,
                    (height - circleSize) / 2 + 1,
                    (height - circleSize) / 2
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
                        size: circleSize - 4,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: circleSize - 15,
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