import 'dart:convert';
import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/user_profile_dto.dart';
import 'package:dog/src/dto/user_profile_register_dto.dart';
import 'package:dog/src/model/preference.dart';
import 'package:dog/src/repository/user_profile_repository.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/image_util.dart';
import 'package:dog/src/util/input_form_util.dart';
import 'package:dog/src/util/step_progress_bar.dart';
import 'package:dog/src/util/text_input_util.dart';
import 'package:dog/src/util/toast_popup_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UserRegisterTemplate extends StatefulWidget {
  final UserProfileDTO? userProfileDTO;
  const UserRegisterTemplate({super.key, this.userProfileDTO});

  @override
  State<UserRegisterTemplate> createState() => _UserRegisterTemplateState();
}

class _UserRegisterTemplateState extends State<UserRegisterTemplate> {
  final double deviceWidth = GlobalVariables.width;
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController hashTagController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final UserProfileRepository userProfileRepository = UserProfileRepository();
  static const List<String> locations = ["서울", "인천", "경기", "충청", "경상", "전라", "강원", "제주"];
  List<dynamic> weeks = [];
  List<dynamic> times = [];
  List<dynamic> dogTypes = [];
  late DateTime birth;
  bool isAgeEditing = true;
  bool isValidNickname = false;
  String? selectedLocation;
  String? errorMsg;
  List<dynamic> hashTags = [];
  XFile? profileImage;
  int isMale = 1;
  int pageIndex = 0;
  late final UserProfileDTO? userProfileDTO;

  List<Preference> dogSizePreference = [
    Preference(name: '소형견', value: false),
    Preference(name: '중형견', value: false),
    Preference(name: '대형견', value: false),
    Preference(name: '초형견', value: false)
  ];

  List<Preference> dayPreference = [
    Preference(name: '월', value: false),
    Preference(name: '화', value: false),
    Preference(name: '수', value: false),
    Preference(name: '목', value: false),
    Preference(name: '금', value: false),
    Preference(name: '토', value: false),
    Preference(name: '일', value: false)
  ];

  List<Preference> timePreference = [
    Preference(name: '아침', value: false),
    Preference(name: '오전', value: false),
    Preference(name: '오후', value: false),
    Preference(name: '저녁', value: false),
    Preference(name: '새벽', value: false)
  ];
  
  @override
  void initState() {
    editProfileInit();
    super.initState();
  }

  void editProfileInit() {
    userProfileDTO = widget.userProfileDTO;
    if (userProfileDTO != null) {
      nicknameController.text = userProfileDTO!.nickname;
      phoneController.text = userProfileDTO!.phonenumber;
      experienceController.text = userProfileDTO!.career;
      hashTags = userProfileDTO!.preferred['hashTag'];
      isMale = userProfileDTO!.gender == '남성' ? 1 : 0;
      ageController.text = userProfileDTO!.birth.toString().replaceAll('.', '');
      birth = DateTime.parse(userProfileDTO!.birth.replaceAll('.', '-'));
      final List<dynamic> weekList = userProfileDTO!.preferred['week'];
      for (var e in dayPreference) {
        e.value = weekList.contains('${e.name}요일');
      }
      final List<dynamic> timeList = userProfileDTO!.preferred['time'];
      for (var e in timePreference) {
        e.value = timeList.contains(e.name);
      }
      final List<dynamic> breedList = userProfileDTO!.preferred['breed'];
      for (var e in dogSizePreference) {
        e.value = breedList.contains(e.name);
      }
      //selectedLocation = userProfileDTO.region;
    }
  }

  @override
  void dispose() {
    nicknameController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    hashTagController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Widget profileUpload() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 18, bottom: 23),
      child: GestureDetector(
        onTap: () {
          ImageUtil().getImage(
            context: context,
            imageSource: ImageSource.gallery
          ).then((image) {
            setState(() {
              profileImage = image;
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
    required List<Preference> preference,
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
          return GestureDetector(
            onTap: () {
              if (maxSelection != null) {
                if (e.value == false) {
                  final int selectedAmount = preference.where((item) => item.value== true).length;
                  debugPrint('선택수: $selectedAmount');
                  if (selectedAmount < maxSelection) {
                    setState(() => e.value = !e.value);
                  } else {
                    // 갯수 초과 콜백
                  }
                } else {
                  setState(() => e.value = !e.value);
                }
              } else {
                setState(() => e.value = !e.value);
              }
            },
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(width: 1, color: e.value ? Palette.green6 : Palette.outlinedButton1)
              ),
              alignment: Alignment.center,
              child: Text(
                e.name,
                style: TextStyle(
                  color: e.value ? Colors.black : Palette.darkFont2,
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

  Widget nextButton({required Function validFunc, Function? func}) {

    return Container(
      margin: EdgeInsets.only(bottom: 36.h),
      alignment: Alignment.center,
      child: ButtonUtil(
          width: deviceWidth - 40,
          height: (deviceWidth - 40) / 335 * 55,
          title: '다음',
          onTap: () {
            func?.call();
            validFunc();
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
        current: isMale,
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
            isMale = i;
          });
        },
      ),
    );
  }

  Widget ageBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isAgeEditing && userProfileDTO == null ? Padding(
          padding: const EdgeInsets.only(left: 16, top: 10, bottom: 9, right: 16),
          child: TextInputUtil().number(
            controller: ageController,
            hintText: '생년월일을 입력하세요 (ex.20240101)',
            onChanged: (value) {
              final String ymd = ageController.text.replaceAll('-', '').replaceAll('.', '').replaceAll(',', '');

              setState(() {
                if (ymd.length > 8) {
                  ageController.text = ageController.text.substring(0, ageController.text.length - 1);
                  isAgeEditing = false;
                  FocusScope.of(context).unfocus();
                  birth = DateTime.parse(ageController.text);
                } else if (ymd.length == 8) {
                  isAgeEditing = false;
                  FocusScope.of(context).unfocus();
                  birth = DateTime.parse(ymd);
                }
              });
            }
          ),
        ) : GestureDetector(
          onTap: () => userProfileDTO == null ? setState(() => isAgeEditing = true) : null,
          child: Container(
            margin: const EdgeInsets.only(left: 16, top: 10, bottom: 6),
            width: deviceWidth - 32,
            height: (deviceWidth - 32) / 345 * 45,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Palette.green6),
                borderRadius: BorderRadius.circular(10)
            ),
            alignment: Alignment.center,
            child: Text(
              '${birth.year} . ${birth.month} . ${birth.day} (만 ${DateTime.now().difference(birth).inDays ~/ 365}세)',
              style: const TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            '정확한 정보를 입력하지 않을 경우, 서비스 이용에 제한이 있을 수 있습니다',
            style: TextStyle(
              color: Color(0xFFF30000),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400
            ),
          ),
        )
      ],
    );
  }

  Widget hashTagInputBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 23, bottom: 9, right: 16),
      child: TextField(
          controller: hashTagController,
          style: TextInputUtil().textStyle,
          textInputAction: TextInputAction.go,
          cursorColor: Palette.green6,
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
          GestureDetector(
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

  void checkNickname() {
    if (nicknameController.text.isEmpty) {
      ToastPopupUtil.error(context: context, content: '닉네임을 입력해주세요.');
    } else {

      userProfileRepository.checkNicknameDuplication(context: context, nickname: nicknameController.text).then((response) {
        if (response.statusCode ~/ 100 == 2) {

          isValidNickname = jsonDecode(response.body)['flag'] == "true";

          if (isValidNickname) {
            setState(() {
              errorMsg = null;
            });
            ToastPopupUtil.notice(context: context, content: '사용가능한 닉네임입니다.');
          } else {
            errorMsg = '중복된 닉네입니다';
            ToastPopupUtil.error(context: context, content: '이미 사용중인 닉네임입니다.');
          }

        }
      });

    }
  }

  Widget nicknameInputBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 9, right: 16),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          TextField(
            controller: nicknameController,
            cursorColor: Palette.green6,
            style: TextInputUtil().textStyle,
            maxLength: 10,
            keyboardType: TextInputType.text,
            decoration: TextInputUtil().inputDecoration(
              hintText: '닉네임을 입력하세요',
              errorText: errorMsg
            )
          ),
          Positioned(
            top: 8.5,
            child: GestureDetector(
              onTap: () => checkNickname(),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
          ],
        ),
        nextButton(
          validFunc: () {
            if (nicknameController.text.isNotEmpty && ageController.text.isNotEmpty && profileImage != null && isValidNickname) {
              setState(() {
                pageIndex += 1;
              });
            } else if (!isValidNickname) {
              ToastPopupUtil.error(context: context, content: '사용할 수 없는 닉네임입니다.');
            } else {
              ToastPopupUtil.error(context: context, content: '정보를 모두 입력하세요.');
            }
          }
        )
      ],
    );
  }

  Widget walkerRegister2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
          ],
        ),
        nextButton(
          func: () {
            dogTypes = dogSizePreference.map((e) => e.value ? e.name : '').toList();
            dogTypes.removeWhere((e) => e == '');
          },
          validFunc: () {
            if (phoneController.text.isNotEmpty && experienceController.text.isNotEmpty && dogTypes.isNotEmpty &&  hashTags.isNotEmpty) {
              setState(() {
                pageIndex += 1;
              });
            } else {
              ToastPopupUtil.error(context: context, content: '정보를 모두 입력하세요.');
            }
          }
        )
      ],
    );
  }
  
  Widget walkerRegister3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 27),
            titleBox(title: '거주 지역 선택'),
            locationDropdown(),
            titleBox(title: '선호 요일 선택'),
            preferenceSelection(preference: dayPreference, height: 30, gap: 5),
            titleBox(title: '선호 시간 선택(2개)'),
            preferenceSelection(preference: timePreference, height: 35, gap: 5, maxSelection: 2),
          ],
        ),
        Container(
          margin: EdgeInsets.only(bottom: 36.h),
          alignment: Alignment.center,
          child: ButtonUtil(
              width: deviceWidth - 40,
              height: (deviceWidth - 40) / 335 * 55,
              title: '완료',
              onTap: () {
                weeks = dayPreference.map((e) => e.value ? '${e.name}요일' : '').toList();
                weeks.removeWhere((e) => e == '');
                times = timePreference.map((e) => e.value ? e.name : '').toList();
                times.removeWhere((e) => e == '');

                if (weeks.isNotEmpty && times.isNotEmpty && selectedLocation != null) {
                  sendRequest();
                } else {
                  ToastPopupUtil.error(context: context, content: '정보를 모두 입력하세요.');
                }
              }
          ).filledButton1m(),
        )
      ],
    );
  }

  void sendRequest() async {

    if (userProfileDTO == null) {
      userProfileRepository.register(
          context: context,
          dto: UserProfileRegisterDto(
              nickname: nicknameController.text,
              userGender: isMale == 1 ? '남성' : '여성',
              phoneNumber: phoneController.text,
              accommodatableDogsCount: 1,
              career: experienceController.text,
              preferredDetails: {
                'weeks' : weeks,
                'times' : times,
                'hashTag' : hashTags,
                'dogTypes' : dogTypes,
                'region' : selectedLocation ?? '',
              },
              profileImage: profileImage
          )
      ).then((response) {
        Navigator.pop(context, response.statusCode);
      });
    } else {
      userProfileRepository.update(
          context: context,
          dto: UserProfileRegisterDto(
              nickname: nicknameController.text,
              userGender: isMale == 1 ? '남성' : '여성',
              phoneNumber: phoneController.text,
              accommodatableDogsCount: 1,
              career: experienceController.text,
              preferredDetails: {
                'weeks' : weeks,
                'times' : times,
                'hashTag' : hashTags,
                'dogTypes' : dogTypes,
                'region' : selectedLocation ?? '',
              },
              profileImage: profileImage
          )
      ).then((response) {
        Navigator.pop(context, response.statusCode);
      });
    }
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
    return CommonScaffoldUtil(
      appBar: const PopHeader(title: '프로필 등록', useBackButton: true),
      body: InputFormUtil(
        child: Column(
          children: [
            StepProgressBar(currentStep: pageIndex + 1, totalStep: 3),
            Flexible(
              child: walkerRegister()
            ),
          ],
        )
      )
    );
  }
}
