import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HashTagUtil extends StatelessWidget {
  final List hashTag;

  const HashTagUtil({
    super.key,
    required this.hashTag,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w, // 태그 사이의 가로 간격
      runSpacing: 8.h, // 태그 사이의 세로 간격
      children: hashTag.map((tag) {
        return Container(
          padding: EdgeInsets.fromLTRB(14.w, 7.h, 14.w, 7.h),
          decoration: BoxDecoration(
            color: Palette.ghostButton1,
            borderRadius: BorderRadius.circular(60),
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 12.sp,
              color: Palette.darkFont2,
            ),
          ),
        );
      }).toList(),
    );
  }
}
