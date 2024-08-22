import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileInfoCard extends StatelessWidget {
  final String nickname;
  final String gender;
  final int age;
  final String location;

  const ProfileInfoCard({
    super.key,
    required this.nickname,
    required this.gender,
    required this.age,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 347.w,
      height: 143.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 27.h, 25.w, 21.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  nickname,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF222222),
                    fontSize: 20.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 127.w),
                ButtonUtil(
                    width: 80.w,
                    height: 26.h,
                    title: '연락하기',
                    onTap: () {

                    }).filledButton1s(),
              ],
            ),
            SizedBox(height: 23.h),
            Text(
              '${gender == '여' ? '여자' : '남자'} | 만 $age세',
              style: TextStyle(
                color: Palette.darkFont2,
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            horizontalDivider(margin: 7.h),
            Text(
              location,
              style: TextStyle(
                color: Palette.darkFont2,
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
