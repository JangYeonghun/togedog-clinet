import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalStep;
  const StepProgressBar({super.key, required this.currentStep, required this.totalStep});

  Widget indicator({required double width, required bool active}) {
    return Container(
      height: 3.h,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: active ? Palette.green6 : const Color(0xFFD9D9D9)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (totalStep < currentStep) {
      throw Exception('Exception: StepProgressBar step overload.');
    }

    final List<bool> list = [...List.filled(currentStep, true), ...List.filled(totalStep - currentStep, false)];

    return Container(
      height: 50.h,
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list.map((e) => indicator(
            width: (1.sw - ((totalStep - 1) * 6.65).w - 32.w) / totalStep,
            active: e
        )).toList(),
      ),
    );
  }
}
