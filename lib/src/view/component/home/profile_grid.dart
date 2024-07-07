import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/view/component/home/profile_grid_item.dart';
import 'package:flutter/material.dart';

class ProfileGrid extends StatefulWidget {
  const ProfileGrid({super.key});

  @override
  State<ProfileGrid> createState() => _ProfileGridState();
}

class _ProfileGridState extends State<ProfileGrid> {
  static const List<Map<String, dynamic>> testData = [
    {
      'nickname':'니니님',
      'age':23,
      'gender':'여',
      'location':'서울시'
    },
    {
      'nickname':'지워닝',
      'age':22,
      'gender':'여',
      'location':'대구시'
    },
    {
      'nickname':'테스트1',
      'age':24,
      'gender':'남',
      'location':'대전시'
    },
    {
      'nickname':'테스트2',
      'age':22,
      'gender':'남',
      'location':'포항시'
    },
    {
      'nickname':'니니님',
      'age':23,
      'gender':'여',
      'location':'서울시'
    },
    {
      'nickname':'지워닝',
      'age':22,
      'gender':'여',
      'location':'대구시'
    },
    {
      'nickname':'테스트1',
      'age':24,
      'gender':'남',
      'location':'대전시'
    },
    {
      'nickname':'테스트2',
      'age':22,
      'gender':'남',
      'location':'포항시'
    },
  ];
  final deviceWidth = GlobalVariables.width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 23, left: 24),
            child: Text(
              '산책메이트 프로필 카드',
              style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 20,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 0
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 24),
            child: Text(
              '나와 딱 맞는 산책 메이트를 추천해드려요!',
              style: TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 0
              ),
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 11,
                  childAspectRatio: 168/200
                ),
                padding: const EdgeInsets.only(left: 12, right: 16, top: 15, bottom: 170),
                itemCount: testData.length,
                itemBuilder: (context, index) {
                  return ProfileGridItem(
                      width: deviceWidth - 43,
                      height: (deviceWidth - 43) / 168 * 200,
                      nickname: testData[index]['nickname'],
                      gender: testData[index]['gender'],
                      age: testData[index]['age'],
                      location: testData[index]['location'],
                      imgUrl: 'https://cdn.gijn.kr/news/photo/202202/411141_315429_83.jpg'
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
