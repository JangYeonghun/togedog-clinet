import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/text_input_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WalkerRegisterTemplate extends StatefulWidget {
  const WalkerRegisterTemplate({super.key});

  @override
  State<WalkerRegisterTemplate> createState() => _WalkerRegisterTemplateState();
}

class _WalkerRegisterTemplateState extends State<WalkerRegisterTemplate> {
  final double deviceWidth = GlobalVariables.width;
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController hashTagController = TextEditingController();
  static const List<String> locations = ["서울", "인천", "경기", "충청", "경상", "전라", "강원", "제주"];
  String? selectedLocation;
  List<String> hashTags = [];
  XFile? profileImage;
  int selectedToggle = 1;
  int pageIndex = 0;
  List<Map<String, dynamic>> dogSizePreference = [
    {
      'name' : '소형견',
      'prefer' : false
    },
    {
      'name' : '중형견',
      'prefer' : false
    },
    {
      'name' : '대형견',
      'prefer' : false
    },
    {
      'name' : '초대형견',
      'prefer' : false
    }
  ];

  List<Map<String, dynamic>> dayPreference = [
    {
      'name' : '월',
      'prefer' : false
    },
    {
      'name' : '화',
      'prefer' : false
    },
    {
      'name' : '수',
      'prefer' : false
    },
    {
      'name' : '목',
      'prefer' : false
    },
    {
      'name' : '금',
      'prefer' : false
    },
    {
      'name' : '토',
      'prefer' : false
    },
    {
      'name' : '일',
      'prefer' : false
    }
  ];

  List<Map<String, dynamic>> timePreference = [
    {
      'name' : '아침',
      'prefer' : false
    },
    {
      'name' : '오전',
      'prefer' : false
    },
    {
      'name' : '오후',
      'prefer' : false
    },
    {
      'name' : '저녁',
      'prefer' : false
    },
    {
      'name' : '새벽',
      'prefer' : false
    }
  ];

  Future<void> getImage({required ImageSource imageSource}) async {
    ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 360,
        maxWidth: 360,
        imageQuality: 70
    ).then((image) async {
      if (image != null) {
        debugPrint("#\n\n\n");
        debugPrint("${(await image.length() / 1024 / 1024).toStringAsFixed(3)}Mb");
        debugPrint("\n\n\n#");
        setState(() {
          profileImage = image;
        });
      }
    });
  }

  Widget profileUpload() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 18, bottom: 23),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          getImage(imageSource: ImageSource.gallery).whenComplete(() {
            setState(() {

            });
          });
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 11, bottom: 4),
              child: profileImage == null ?
              Image.asset('assets/images/empty_profile.png', width: 83) :
              Container(
                width: 83,
                height: 83,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Palette.outlinedButton1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(profileImage!.path), fit: BoxFit.cover)
                ),
              ),
            ),
            Image.asset('assets/images/camera_icon.png', width: 22),
          ],
        ),
      ),
    );
  }

  Widget preferenceSelection({
    required List<Map<String, dynamic>> preference,
    required double height,
    required int gap,
    int? maxSelection,
    BorderRadius? borderRadius
  }) {
    borderRadius ??= BorderRadius.circular(200);

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: preference.map((e) {
          final double width = (deviceWidth - 28 - (preference.length - 1) * gap) / preference.length;
          return InkWell(
            onTap: () {
              if (maxSelection != null) {
                if (e['prefer'] == false) {
                  final int selectedAmount = preference.where((item) => item['prefer'] == true).length;
                  debugPrint('선택수: $selectedAmount');
                  if (selectedAmount < maxSelection) {
                    setState(() => e['prefer'] = !e['prefer']);
                  } else {
                    // 갯수 초과 콜백
                  }
                } else {
                  setState(() => e['prefer'] = !e['prefer']);
                }
              } else {
                setState(() => e['prefer'] = !e['prefer']);
              }
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(width: 1, color: e['prefer'] ? Palette.green6 : Palette.outlinedButton1)
              ),
              alignment: Alignment.center,
              child: Text(
                e['name'],
                style: TextStyle(
                  color: e['prefer'] ? Colors.black : Palette.darkFont2,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          );
        }).toList(),
      )
    );
  }

  Widget nextButton() {
    return Center(
      child: ButtonUtil(
          width: deviceWidth - 40,
          height: (deviceWidth - 40) / 335 * 55,
          title: '다음',
          onTap: () {
            setState(() {
              pageIndex += 1;
            });
          }
      ).filledButton1m(),
    );
  }

  Widget titleBox({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        title,
        style: const TextStyle(
            color: Color(0xFF222222),
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  Widget toggle() {
    return Container(
      margin: const EdgeInsets.only(left: 14, top: 10),
      width: deviceWidth - 28,
      child: AnimatedToggleSwitch<int>.size(
        textDirection: TextDirection.rtl,
        current: selectedToggle,
        values: const [0, 1],
        customIconBuilder: (context, local, global) {
          final String icon = ['여자', '남자'][local.index];
          return Center(
              child: Text(
                icon,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600
                ),
              )
          );
        },
        indicatorSize: Size.fromWidth(deviceWidth - 28),
        borderWidth: 0,
        iconAnimationType: AnimationType.onHover,
        selectedIconScale: 1,
        style: ToggleStyle(
            indicatorBorder: Border.all(width: 1, color: Palette.green6),
            indicatorColor: Colors.white,
            borderColor: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Palette.outlinedButton1
        ),
        onChanged: (i) {
          setState(() {
            selectedToggle = i;
          });
        },
      ),
    );
  }

  Widget ageBox() {
    return Container(
      margin: const EdgeInsets.only(left: 14, top: 10),
      width: deviceWidth - 28,
      height: (deviceWidth - 28) / 345 * 45,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Palette.green6),
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: Alignment.center,
      child: const Text(
        '2001 . 01 . 31 (만 23세)',
        style: TextStyle(
          color: Color(0xFF222222),
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget hashTagInputBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 23, bottom: 9, right: 16),
      child: TextField(
          controller: hashTagController,
          style: TextInputUtil().textStyle,
          textInputAction: TextInputAction.go,
          onChanged: (value) {
            if (value.startsWith('#')) {
              if (value.replaceAll('#', '').length > 5) {
                hashTagController.text = value.substring(0, 6);
              }
            } else {
              if (value.replaceAll('#', '').length > 4) {
                hashTagController.text = value.substring(0, 5);
              }
            }
          },
          onSubmitted: (value) {
            if (hashTags.length < 4) {
              setState(() {
                hashTags.add('#${value.replaceAll(' ', '').replaceAll('#', '')}');
                hashTagController.text = '';
              });
            } else {
              // 해쉬태그는 4개까지!
            }
          },
          keyboardType: TextInputType.text,
          decoration: TextInputUtil().inputDecoration(hintText: '산책메이트가 선호하는 산책 스타일을 입력하세요 (최대4개)')
      ),
    );
  }

  Widget hashTagList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: hashTags.map((e) {
          return hashTagItem(hashTag: e);
        }).toList(),
      ),
    );
  }

  Widget hashTagItem({required String hashTag}) {
    return Container(
      margin: const EdgeInsets.only(right: 9),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 1, color: Palette.green6)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 6),
            child: Text(
              hashTag,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              hashTagRemoveHandler(hashTag: hashTag);
            },
            child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle
                ),
                margin: const EdgeInsets.all(6),
                child: const Icon(Icons.cancel, color: Palette.green6, size: 12)
            ),
          )
        ],
      ),
    );
  }

  void hashTagRemoveHandler({
    required String hashTag
  }) {
    setState(() {
      hashTags.remove(hashTag);
    });
  }

  Widget nicknameInputBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 9, right: 16),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: nicknameController,
            style: TextInputUtil().textStyle,
            maxLength: 10,
            keyboardType: TextInputType.text,
            decoration: TextInputUtil().inputDecoration(hintText: '닉네임을 입력하세요')
          ),
          InkWell(
            onTap: () {
              // 여기에 중복 확인 API 필요
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                border: Border.all(width: 1, color: Palette.green6),
              ),
              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: const Text(
                '중복확인',
                style: TextStyle(
                  color: Color(0xFF00DB97),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget experienceInputBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30, left: 14, right: 14),
      child: TextInputUtil().text(
        controller: experienceController,
        hintText: '경력 및 경험을 입력하세요 (최대500자)',
        maxLines: 6,
        maxLength: 500,
      ),
    );
  }

  Widget locationDropdown() {
    return Center(
      child: Container(
        width: deviceWidth - 28,
        height: (deviceWidth - 28) / 343 * 46,
        margin: const EdgeInsets.only(bottom: 30, top: 10),
        padding: const EdgeInsets.only(left: 16, right: 24),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Palette.outlinedButton1),
            borderRadius: BorderRadius.circular(10)
        ),
        child: DropdownButton(
            isExpanded: true,
            hint: const Text(
              '거주 지역을 선택하세요',
              style: TextStyle(
                  color: Palette.darkFont2,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.keyboard_arrow_down, size: 17, color: Palette.darkFont2),
            underline: const SizedBox(),
            value: selectedLocation,
            items: locations.map((e) {
              return DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    ),
                  )
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLocation = value!;
              });
            }
        ),
      ),
    );
  }
  
  Widget walkerRegister1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 27),
        titleBox(title: '프로필 사진 등록'),
        profileUpload(),
        titleBox(title: '닉네임 입력'),
        nicknameInputBox(),
        // 닉네임 체크 결과 텍스트 추가
        const SizedBox(height: 30),
        titleBox(title: '성별 입력'),
        toggle(),
        const SizedBox(height: 30),
        titleBox(title: '나이'),
        ageBox(),
        const SizedBox(height: 41),
        nextButton()
      ],
    );
  }

  Widget walkerRegister2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 27),
        titleBox(title: '연락처 입력'),
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 30),
          child: TextInputUtil().number(controller: phoneController, hintText: '\'-\' 제외하고 숫자만 입력'),
        ),
        titleBox(title: '경력 및 경험 추가'),
        experienceInputBox(),
        titleBox(title: '선호 견종 크기 선택'),
        preferenceSelection(
          preference: dogSizePreference,
          gap: 9,
          height: 40,
          borderRadius: BorderRadius.circular(10)
        ),
        titleBox(title: '산책 스타일 및 선호사항 태그'),
        hashTagInputBox(),
        hashTagList(),
        const SizedBox(height: 40),
        nextButton()
      ],
    );
  }
  
  Widget walkerRegister3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 27),
        titleBox(title: '거주 지역 선택'),
        locationDropdown(),
        titleBox(title: '선호 요일 선택'),
        preferenceSelection(preference: dayPreference, height: 30, gap: 5),
        titleBox(title: '선호 시간 선택(2개)'),
        preferenceSelection(preference: timePreference, height: 35, gap: 5, maxSelection: 2),
        const SizedBox(height: 158),
        Center(
          child: ButtonUtil(
              width: deviceWidth - 40,
              height: (deviceWidth - 40) / 335 * 55,
              title: '완료',
              onTap: () {

              }
          ).filledButton1m(),
        )
      ],
    );
  }
  
  Widget walkerRegister() {
    switch (pageIndex) {
      case 0:
        return walkerRegister1();
      case 1:
        return walkerRegister2();
      case 2:
        return walkerRegister3();  
      default:
        throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: walkerRegister());
  }
}