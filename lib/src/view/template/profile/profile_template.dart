import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/profile/dog_profile_detail_template.dart';
import 'package:dog/src/view/template/profile/dog_register_template.dart';
import 'package:dog/src/view/template/profile/walker_profile_detail_template.dart';
import 'package:dog/src/view/template/profile/walker_register_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transition/transition.dart';

class ProfileTemplate extends StatefulWidget {
  const ProfileTemplate({super.key});

  @override
  State<ProfileTemplate> createState() => _ProfileTemplateState();
}

class _ProfileTemplateState extends State<ProfileTemplate> {
  final double deviceWidth = GlobalVariables.width;
  final String nickname = '닉네임';

  final Map<String, dynamic> testWalkerProfile = {}/*{
    'name' : '니니님',
    'imgUrl' : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzHrUbueWGNaL9RjJrP6gBl1wGYtC0Y1Qwlg&s',
    'gender' : '여자',
    'age' : 23,
    'region' : '서울',
    'hashTags' : [
      '#여유로운',
      '#교감하는',
      '#조깅'
    ],
    'availableTimes' : [
      '월요일',
      '수요일'
    ],
    'preferences' : {
      'region' : [
        '서울'
      ],
      'time' : [
        '오전'
      ],
      'size' : [
        '중형견',
        '대형'
      ]
    },
    'maxAllowedPets' : 2,
    'notes' : '13살부터 19살까지 강아지를 키운 경험이 있고, 애견 미용 전공자이기 때문에 강아지들을 잘 컨트롤 하고, 처음 보는 강아지들도 저를 잘 따르는 편이에요. 강아지를 너무 좋아해서 유기견 봉사도 꾸준히 다니고 있으니 믿고 맏기셔도 됩니다. :)'
  }*/;

  final List<Map<String, dynamic>> testDogProfiles = [
    /*{
      'name' : '뽀삐',
      'imgUrl' : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkkGUrLOWE58fO0RbchUAP2D4McJUiJhmeDw&s',
      'gender' : '수컷',
      'age' : 2,
      'weight' : 8,
      'size' : '소형견',
      'breed' : '웰시코기',
      'region' : '서울',
      'neuter' : true,
      'vaccine' : true,
      'hashTags' : ['#잘 따르는', '#활발한', '#귀여운'],
      'note' : '꼬리 만지는 것을 싫어해요'
    },
    {
      'name' : '봅비',
      'imgUrl' : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkkGUrLOWE58fO0RbchUAP2D4McJUiJhmeDw&s',
      'gender' : '수컷',
      'age' : 4,
      'weight' : 8,
      'size' : '중형견',
      'breed' : '웰시코기',
      'region' : '서울',
      'neuter' : true,
      'vaccine' : true,
      'hashTags' : ['#잘 따르는', '#활발한', '#귀여운'],
      'note' : '꼬리 만지는 것을 싫어해요'
    },
    {
      'name' : '뽀삐',
      'imgUrl' : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkkGUrLOWE58fO0RbchUAP2D4McJUiJhmeDw&s',
      'gender' : '수컷',
      'age' : 2,
      'weight' : 8,
      'size' : '소형견',
      'breed' : '웰시코기',
      'region' : '서울',
      'neuter' : true,
      'vaccine' : true,
      'hashTags' : ['#잘 따르는', '#활발한', '#귀여운'],
      'note' : '꼬리 만지는 것을 싫어해요'
    },
    {
      'name' : '봅비',
      'imgUrl' : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkkGUrLOWE58fO0RbchUAP2D4McJUiJhmeDw&s',
      'gender' : '수컷',
      'age' : 4,
      'weight' : 8,
      'size' : '중형견',
      'breed' : '웰시코기',
      'region' : '서울',
      'neuter' : true,
      'vaccine' : true,
      'hashTags' : ['#잘 따르는', '#활발한', '#귀여운'],
      'note' : '꼬리 만지는 것을 싫어해요'
    },
    {
      'name' : '봅비',
      'imgUrl' : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkkGUrLOWE58fO0RbchUAP2D4McJUiJhmeDw&s',
      'gender' : '수컷',
      'age' : 4,
      'weight' : 8,
      'size' : '중형견',
      'breed' : '웰시코기',
      'region' : '서울',
      'neuter' : true,
      'vaccine' : true,
      'hashTags' : ['#잘 따르는', '#활발한', '#귀여운'],
      'note' : '꼬리 만지는 것을 싫어해요'
    }*/
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget emptyProfile() {
    return Consumer(
        builder: (context, ref, _) {
          final mode = ref.watch(modeProvider);
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                        ),
                        children: [
                          TextSpan(
                              text: "아직 ${mode ? '등록된 반려견' : '$nickname님의 프로필'}이 없어요",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600
                              )
                          ),
                          const TextSpan(
                              text: "\n\n",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                          TextSpan(
                              text: "${mode ? '반려견' : '프로필'}을 등록하고 산책메이트를 찾아보세요!",
                              style: const TextStyle(
                                  color: Palette.darkFont2,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                        ]
                    )
                ),
                const SizedBox(height: 70),
                ButtonUtil(
                    width: deviceWidth - 90,
                    height: (deviceWidth - 90) / 285 * 55,
                    title: '${mode ? '반려견' : '산책메이트'} 프로필 등록하기',
                    onTap: () => Navigator.push(
                      context,
                      Transition(
                          transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
                          child: mode ? const DogRegisterTemplate() : const WalkerRegisterTemplate()
                      )
                  )
                ).filledButton1m()
              ],
            ),
          );
        }
    );
  }

  Widget dogProfileItem({required Map<String, dynamic> item}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            Transition(
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
              child: DogProfileDetailTemplate(dogProfile: item)
            )
        );
      },
      child: Container(
        width: deviceWidth - 28,
        height: (deviceWidth - 28) / 347 * 143,
        margin: const EdgeInsets.only(top: 6, bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ]
        ),
        padding: const EdgeInsets.only(left: 17, top: 25, right: 16, bottom: 21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 9, right: 9.5),
                  width: (deviceWidth - 28) / 347 * 53,
                  height: (deviceWidth - 28) / 347 * 53,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: CachedNetworkImage(imageUrl: item['imgUrl'], fit: BoxFit.cover)
                  ),
                ),
                Container(
                  width: deviceWidth - (deviceWidth - 28) / 347 * 53 - 80,
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              color: Palette.darkFont4,
                              fontSize: 20,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                width: 44,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Palette.green6),
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  '프로필',
                                  style: TextStyle(
                                    color: Palette.green6,
                                    fontSize: 12,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  //삭제 콜백
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 6, right: 10),
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(
                                      color: Palette.darkFont1,
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Palette.darkFont1
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${item['gender']} | ${item['age']}살 | ${item['size']} | ${item['breed']}',
                        style: const TextStyle(
                          color: Palette.darkFont2,
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 1,
              color: Palette.darkFont2,
              margin: const EdgeInsets.only(top: 7, bottom: 7),
            ),
            Padding(
              padding: EdgeInsets.only(left: 18.5 + (deviceWidth - 28) / 347 * 53),
              child: Text(
                item['region'],
                style: const TextStyle(
                    color: Palette.darkFont2,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dogProfile() {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18),
        itemCount: testDogProfiles.length + 1,
        itemBuilder: (context, index) {
          if (index < testDogProfiles.length) {
            return dogProfileItem(item: testDogProfiles[index]);
          } else {
            return Consumer(
                builder: (context, ref, _) {
                  final mode = ref.watch(modeProvider);
                  return InkWell(
                    onTap: () => testDogProfiles.length >= 5 ? showProfileLimitAlert() : Navigator.push(
                        context,
                        Transition(
                            transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
                            child: mode ? const DogRegisterTemplate() : const WalkerRegisterTemplate()
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                      ),
                      margin: const EdgeInsets.only(top: 6, bottom: 6),
                      width: deviceWidth - 28,
                      height: (deviceWidth - 28) / 347 * 80,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Color(0xFF818181), size: 20),
                          SizedBox(width: 4),
                          Text(
                            '추가하기',
                            style: TextStyle(
                                color: Color(0xFF818181),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
            );
          }
        }
      ),
    );
  }

  void showProfileLimitAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: deviceWidth - 58,
              height: (deviceWidth - 58) / 318 * 145,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '최대 5개의 프로필만 등록할 수 있습니다',
                    style: TextStyle(
                      color: Palette.darkFont4,
                      fontSize: 13,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 25),
                  ButtonUtil(
                      width: deviceWidth - 240,
                      height: (deviceWidth - 240) / 135 * 35,
                      title: '확인',
                      onTap: () => Navigator.pop(context)
                  ).filledButton1s()
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(

        body: Consumer(
          builder: (context, ref, _) {
            final mode = ref.watch(modeProvider);
            return CommonScaffoldUtil(
                appBar: PopHeader(title: !mode && testWalkerProfile.isNotEmpty ? '프로필' : '프로필 등록'),
                body: mode ?
                testDogProfiles.isEmpty ? emptyProfile() : dogProfile() :
                testWalkerProfile.isEmpty ? emptyProfile() : WalkerProfileDetailTemplate(walkerProfile: testWalkerProfile)
            );
          },
        )
    );
  }
}
