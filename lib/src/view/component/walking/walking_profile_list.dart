import 'package:dog/src/view/component/walking/walking_list_text.dart';
import 'package:dog/src/view/component/walking/walking_profile_list_item.dart';
import 'package:flutter/material.dart';

class WalkingProfileList extends StatefulWidget {
  const WalkingProfileList({super.key});

  @override
  State<WalkingProfileList> createState() => _WalkingProfileListState();
}

class _WalkingProfileListState extends State<WalkingProfileList> {
  static const List<Map<String, dynamic>> testData = [
    {
      'name':'뽀삐',
      'age':2,
      'gender':'수컷',
      'size':'소형견',
      'species':'웰시코기',
      'location':'서울시',
      'title': '관악구 산책 가능하신 분 구해요',
      'date': '2024년 5월 23일 목요일',
      'address': '관악초등학교앞'
    },
    {
      'name':'자두',
      'age':3,
      'gender':'암컷',
      'size':'중형견',
      'species':'푸들',
      'location':'대전시',
      'title': '순하고 귀여운 까미와 산책하실 분 구해요',
      'date': '2024년 5월 23일 목요일',
      'address': '한양대학교 정문 앞'
    },
    {
      'name':'댕댕이',
      'age':1,
      'gender':'수컷',
      'size':'소형견',
      'species':'치와와',
      'location':'여수시',
      'title': '관악구 산책 가능하신 분 구해요',
      'date': '2024년 5월 23일 목요일',
      'address': '관악초등학교앞'
    },
    {
      'name':'뒝뒝이',
      'age':4,
      'gender':'수컷',
      'size':'대형견',
      'species':'도베르만',
      'location':'서울시',
      'title': '순하고 귀여운 까미와 산책하실 분 구해요',
      'date': '2024년 5월 23일 목요일',
      'address': '한양대학교 정문 앞'
    },
    {
      'name':'뽀삐',
      'age':2,
      'gender':'수컷',
      'size':'소형견',
      'species':'웰시코기',
      'location':'서울시',
      'title': '관악구 산책 가능하신 분 구해요',
      'date': '2024년 5월 23일 목요일',
      'address': '관악초등학교앞'
    },
    {
      'name':'자두',
      'age':3,
      'gender':'암컷',
      'size':'중형견',
      'species':'푸들',
      'location':'대전시',
      'title': '순하고 귀여운 까미와 산책하실 분 구해요',
      'date': '2024년 5월 23일 목요일',
      'address': '한양대학교 정문 앞'
    },
    {
      'name':'댕댕이',
      'age':1,
      'gender':'수컷',
      'size':'소형견',
      'species':'치와와',
      'location':'여수시',
      'title': '관악구 산책 가능하신 분 구해요',
      'date': '2024년 5월 23일 목요일',
      'address': '관악초등학교앞'
    },
    {
      'name':'뒝뒝이',
      'age':4,
      'gender':'수컷',
      'size':'대형견',
      'species':'도베르만',
      'location':'서울시',
      'title': '순하고 귀여운 까미와 산책하실 분 구해요',
      'date': '2024년 5월 23일 목요일',
      'address': '한양대학교 정문 앞'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const WalkingListText(),
        Container(
          color: const Color(0xFFF2F2F2),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
              itemCount: testData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: WalkingProfileListItem(
                      imgUrl: 'https://cdn.gijn.kr/news/photo/202202/411141_315429_83.jpg',
                      name: testData[index]['name'],
                      gender: testData[index]['gender'],
                      age: testData[index]['age'],
                      size: testData[index]['size'],
                      species: testData[index]['species'],
                      location: testData[index]['location'],
                      title: testData[index]['title'],
                      date: testData[index]['date'],
                      address: testData[index]['address']
                  ),
                );
              }
          ),
        ),
      ],
    );
  }
}
