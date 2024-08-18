import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';

class ToastPopupUtil {
  static final double deviceWidth = GlobalVariables.width;

  static void _base({
    required BuildContext context,
    required String content,
    required Color backgroundColor
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 3000)).then((value) => true),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Container(
              width: deviceWidth - 20,
              height: (deviceWidth - 20) / 455 * 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: backgroundColor
              ),
              alignment: Alignment.center,
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
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
      backgroundColor: Palette.green6
    );
  }
}