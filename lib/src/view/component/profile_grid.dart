import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/view/component/profile_grid_item.dart';
import 'package:flutter/material.dart';

class ProfileGrid extends StatefulWidget {
  final Widget gridText;

  const ProfileGrid({
    super.key,
    required this.gridText,
  });

  @override
  State<ProfileGrid> createState() => _ProfileGridState();
}

class _ProfileGridState extends State<ProfileGrid> {
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
          widget.gridText,
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 11,
                childAspectRatio: 168/200
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 12, right: 16, top: 15, bottom: 10),
              itemCount: testData.length,
              itemBuilder: (context, index) {
                return ProfileGridItem(
                    width: deviceWidth - 43,
                    height: (deviceWidth - 43) / 168 * 200,
                    id: testData[index]['id'],
                    nickname: testData[index]['nickname'],
                    gender: testData[index]['gender'],
                    age: testData[index]['age'],
                    location: testData[index]['location'],
                    imgUrl: 'https://cdn.gijn.kr/news/photo/202202/411141_315429_83.jpg'
                );
              }
          ),
        ],
      ),
    );
  }
}
