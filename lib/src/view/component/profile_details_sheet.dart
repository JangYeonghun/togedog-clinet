import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/hash_tag_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsSheet extends StatelessWidget {
  final List hashTag;
  final Map<String, String> profileData;

  const ProfileDetailsSheet({
    super.key,
    required this.hashTag,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 393.h,
      decoration: const ShapeDecoration(
        color: Color(0xFFF8F8F8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 40.w,right: 40.w, top: 63.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HashTagUtil(hashTag: hashTag),
            SizedBox(height: 32.h),
            _buildProfileInfoItem('산책 가능 시간', profileData['walkTime'] ?? ''),
            _buildProfileInfoItem('선호 지역', profileData['preferredArea'] ?? ''),
            _buildProfileInfoItem('선호 시간', profileData['preferredTime'] ?? ''),
            Container(
              height: 1,
              color: Palette.darkFont2,
              margin: EdgeInsets.only(bottom: 14.h),
            ),
            _buildProfileInfoItem('선호 견종 크기', profileData['preferredDogSize'] ?? ''),
            _buildProfileInfoItem('동반 가능한 반려견 수', profileData['companionDogCount'] ?? ''),          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 16.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
