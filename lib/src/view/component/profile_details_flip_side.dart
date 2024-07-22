import 'package:dog/src/view/component/profile_details_bottom_sheet.dart';
import 'package:dog/src/view/component/profile_details_circle_image.dart';
import 'package:dog/src/view/component/profile_header_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsFlipSide extends StatelessWidget {
  final String imgUrl;

  const ProfileDetailsFlipSide({
    super.key,
    required this.imgUrl,
  });

  Widget profileHeader() {
    return ProfileHeaderImage(imgUrl: imgUrl);
  }

  Widget profileCircleImage() {
    return ProfileDetailsCircleImage(imgUrl: imgUrl);
  }

  Widget profileDetails() {
    List hashTag = ['여유로운', '교감하는', '조깅'];

    final Map<String, String> testProfileData = {
      'experience': '13살부터 19살까지 강아지를 키운 경험이 있고, 애견 미용 전공자이기 때문에 강아지들을 잘 컨트롤 하고, 처음 보는 강아지들도 저를 잘 따르는 편이에요. 강아지를 너무 좋아해서 유기견 봉사도 꾸준히 다니고 있으니 믿고 맏기셔도 됩니다. :)',
    };

    return ProfileDetailsBottomSheet(type: 'flip', hashTag: hashTag, profileData: testProfileData);
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
            ],
          ),
        ),
      ),
    );
  }
}
