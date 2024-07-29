import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/pop_close_button.dart';
import 'package:dog/src/view/component/profile_details_bottom_sheet.dart';
import 'package:dog/src/view/component/profile_header_image.dart';
import 'package:dog/src/view/component/profile_info_card.dart';
import 'package:dog/src/view/component/walking/posting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transition/transition.dart';

class ProfileDetail extends StatelessWidget {
  final int id;

  const ProfileDetail({
    super.key,
    required this.id,
  });

  static const List<Map<String, dynamic>> testData = [
    {
      'id': 1,
      'nickname':'니니님',
      'age':23,
      'gender':'여',
      'location':'서울시'
    },
    {
      'id': 2,
      'nickname':'지워닝',
      'age':22,
      'gender':'여',
      'location':'대구시'
    },
    {
      'id': 3,
      'nickname':'테스트1',
      'age':24,
      'gender':'남',
      'location':'대전시'
    },
    {
      'id': 4,
      'nickname':'테스트2',
      'age':22,
      'gender':'남',
      'location':'포항시'
    },
    {
      'id': 5,
      'nickname':'니니님',
      'age':23,
      'gender':'여',
      'location':'서울시'
    },
    {
      'id': 6,
      'nickname':'지워닝',
      'age':22,
      'gender':'여',
      'location':'대구시'
    },
    {
      'id': 7,
      'nickname':'테스트1',
      'age':24,
      'gender':'남',
      'location':'대전시'
    },
    {
      'id': 8,
      'nickname':'테스트2',
      'age':22,
      'gender':'남',
      'location':'포항시'
    },
  ];

  Widget profileHeader() {
    String imgUrl = 'https://cdn.gijn.kr/news/photo/202202/411141_315429_83.jpg';
    return ProfileHeaderImage(imgUrl: imgUrl);
  }

  Widget profileInfo() {
    return ProfileInfoCard(
      nickname: testData[id]['nickname'],
      gender: testData[id]['gender'],
      age: testData[id]['age'],
      location: testData[id]['location'],
    );
  }

  Widget profileDetails() {
    List hashTag = ['여유로운', '교감하는', '조깅'];

    final Map<String, String> testProfileData = {
      'walkTime': '월요일, 수요일',
      'preferredArea': '서울',
      'preferredTime': '오전',
      'preferredDogSize': '중형견, 대형견',
      'companionDogCount': '2마리',
    };

    return ProfileDetailsBottomSheet(type: 'front', hashTag: hashTag, profileData: testProfileData);
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
