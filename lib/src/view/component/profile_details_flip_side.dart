import 'package:dog/src/dto/user_profile_dto.dart';
import 'package:dog/src/util/pop_close_button.dart';
import 'package:dog/src/view/component/profile_details_bottom_sheet.dart';
import 'package:dog/src/view/component/profile_details_circle_image.dart';
import 'package:dog/src/view/component/profile_header_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsFlipSide extends StatelessWidget {
  final UserProfileDTO userProfileDTO;

  const ProfileDetailsFlipSide({
    super.key,
    required this.userProfileDTO,
  });

  Widget profileHeader() {
    return ProfileHeaderImage(userProfileDTO: userProfileDTO);
  }

  Widget profileCircleImage() {
    return ProfileDetailsCircleImage(imgUrl: userProfileDTO.profileImage);
  }

  Widget profileDetails() {

    return ProfileDetailsBottomSheet(type: 'flip', userProfileDTO: userProfileDTO);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;  // 이미 pop이 됐었다면 아무것도 하지 않음

        trigger = !trigger;  // trigger 값을 토글
        Navigator.of(context).pop();  // 수동으로 pop
      },
      child: Scaffold(
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
                top: (285 / 812).sh,
                child: Center(
                  child: profileCircleImage(),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 57.h,
                child: Center(
                  child: PopCloseButton(
                    color: Colors.white,
                    onTap: () {
                      trigger = !trigger;
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
