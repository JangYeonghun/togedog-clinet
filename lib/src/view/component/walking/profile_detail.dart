import 'package:dog/src/dto/user_profile_dto.dart';
import 'package:dog/src/util/pop_close_button.dart';
import 'package:dog/src/view/component/profile_details_bottom_sheet.dart';
import 'package:dog/src/view/component/profile_header_image.dart';
import 'package:dog/src/view/component/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetail extends StatelessWidget {
  final UserProfileDTO userProfileDTO;

  const ProfileDetail({
    super.key,
    required this.userProfileDTO,
  });

  Widget profileHeader() {
    String imgUrl = 'https://cdn.gijn.kr/news/photo/202202/411141_315429_83.jpg';
    return ProfileHeaderImage(userProfileDTO: userProfileDTO);
  }

  Widget profileInfo() {
    return ProfileInfoCard(
      nickname: userProfileDTO.nickname,
      gender: userProfileDTO.gender,
      age: userProfileDTO.age,
      location: userProfileDTO.region,
    );
  }

  Widget profileDetails() {
    final Map<String, dynamic> preference = userProfileDTO.preferred;
    return ProfileDetailsBottomSheet(type: 'front', userProfileDTO: userProfileDTO);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 1.sh,
        child: Stack(
          children: [
            profileHeader(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: profileDetails(),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: (325 / 812).sh,
              child: Center(
                child: profileInfo(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 57.h,
              child: const Center(
                child: PopCloseButton(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
