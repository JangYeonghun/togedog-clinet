import 'package:dog/src/config/palette.dart';
import 'package:dog/src/view/component/home/profile_list_item.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {

  static const List<Map<String, dynamic>> testData = [
    {
      'name':'뽀삐',
      'age':2,
      'gender':'수컷',
      'size':'소형견',
      'species':'웰시코기',
      'location':'서울시'
    },
    {
      'name':'자두',
      'age':3,
      'gender':'암컷',
      'size':'중형견',
      'species':'푸들',
      'location':'대전시'
    },
    {
      'name':'댕댕이',
      'age':1,
      'gender':'수컷',
      'size':'소형견',
      'species':'치와와',
      'location':'여수시'
    },
    {
      'name':'뒝뒝이',
      'age':4,
      'gender':'수컷',
      'size':'대형견',
      'species':'도베르만',
      'location':'서울시'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Palette.green6
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 23, left: 24),
            child: Text(
              '반려견 프로필 카드',
              style: TextStyle(
                  color: Colors.white,
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
              '나와 딱 맞는 반려견을 추천해드려요!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 0
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
              itemCount: testData.length,
              itemBuilder: (context, index) {
                return ProfileListItem(
                    imgUrl: 'https://cdn.gijn.kr/news/photo/202202/411141_315429_83.jpg',
                    name: testData[index]['name'],
                    gender: testData[index]['gender'],
                    age: testData[index]['age'],
                    size: testData[index]['size'],
                    species: testData[index]['species'],
                    location: testData[index]['location']
                );
              }
          )
        ],
      ),
    );
  }
}
