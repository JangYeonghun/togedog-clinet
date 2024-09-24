import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/dog_profile_register_dto.dart';
import 'package:dog/src/repository/dog_profile_repository.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/image_util.dart';
import 'package:dog/src/util/input_form_util.dart';
import 'package:dog/src/util/step_progress_bar.dart';
import 'package:dog/src/util/text_input_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class DogRegisterTemplate extends StatefulWidget {
  const DogRegisterTemplate({super.key});

  @override
  State<DogRegisterTemplate> createState() => _DogRegisterTemplateState();
}

class _DogRegisterTemplateState extends State<DogRegisterTemplate> {
  final double deviceWidth = GlobalVariables.width;
  final TextEditingController hashTagController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController significantController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  static const List<String> locations = ["서울", "인천", "경기", "충청", "경상", "전라", "강원", "제주"];
  String? selectedLocation;
  int pageIndex = 0;
  XFile? profileImage;
  List<String> hashTags = [];
  int previousHashTagTextLen = 0;
  Map<String, Map<String, dynamic>> dogInfo = {
    "gender" : {
      "toggle1" : const Text("암컷",
        style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600
        ),
      ),
      "toggle2" : const Text("수컷",
        style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600
        ),
      ),
      "value" : 1
    },
    "neuter" : {
      "toggle1" : const Icon(Icons.close, size: 22),
      "toggle2" : const Icon(Icons.circle_outlined, size: 22),
      "value" : 1
    },
    "vaccine" : {
      "toggle1" : const Icon(Icons.close, size: 22),
      "toggle2" : const Icon(Icons.circle_outlined, size: 22),
      "value" : 1
    }
  };

  Widget profileUpload() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 18, bottom: 23),
      child: GestureDetector(
        onTap: () async {
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
            Image.asset('assets/images/camera_icon.png', width: 22)
          ],
        ),
      ),
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

  Widget toggle({required String type}) {
    return Container(
      margin: const EdgeInsets.only(left: 14, top: 10, bottom: 36),
      width: deviceWidth - 28,
      child: AnimatedToggleSwitch<int>.size(
        textDirection: TextDirection.rtl,
        current: dogInfo[type]!['value'],
        values: const [0, 1],
        customIconBuilder: (context, local, global) {
          final Widget icon = [dogInfo[type]!['toggle1'], dogInfo[type]!['toggle2']][local.index];
          return Center(
              child: icon
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
            dogInfo[type]!['value'] = i;
          });
        },
      ),
    );
  }

  Widget hashTagInputBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 9, right: 16),
      child: TextField(
        controller: hashTagController,
        style: TextInputUtil().textStyle,
        cursorColor: Palette.green6,
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
        decoration: TextInputUtil().inputDecoration(hintText: '성격 해시태그를 등록하세요 (최대4개)')
      ),
    );
  }

  Widget textInputBox({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    int? maxLength,
    EdgeInsetsGeometry padding = const EdgeInsets.only(top: 10, bottom: 20, left: 14, right: 14),
    Function? onChanged
  }) {
    return Padding(
      padding: padding,
      child: TextInputUtil().text(
        controller: controller,
        hintText: hintText,
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: (value) {
          if (onChanged != null) onChanged(value);
        },
      ),
    );
  }

  Widget numberInputBox({
    required TextEditingController controller,
    required String hintText
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20, left: 14, right: 14),
      child: TextInputUtil().number(
          controller: controller,
          hintText: hintText
      ),
    );
  }

  Widget nextButton() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 36.h),
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

  Widget dogRegister() {
    switch(pageIndex) {
      case 0:
        return dogRegister1();
      case 1:
        return dogRegister2();
      case 2:
        return dogRegister3();
      default:
        throw Exception();
    }
  }

  Widget dogRegister1() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 27),
            titleBox(title: '프로필 사진 등록'),
            profileUpload(),
            titleBox(title: '반려견 이름 입력'),
            textInputBox(
                controller: nameController,
                hintText: '반려견의 이름을 입력하세요'
            ),
            titleBox(title: '견종 입력'),
            textInputBox(
                controller: speciesController,
                hintText: '반려견의 종을 입력하세요'
            ),
            titleBox(title: '나이 입력'),
            numberInputBox(
                controller: ageController,
                hintText: '반려견의 나이를 입력하세요'
            ),
          ],
        ),
        nextButton(),
      ],
    );
  }

  Widget dogRegister2() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            titleBox(title: '성별'),
            toggle(type: 'gender'),
            titleBox(title: '중성화 여부'),
            toggle(type: 'neuter'),
            titleBox(title: '예방접종 여부'),
            toggle(type: 'vaccine'),
            titleBox(title: '무게 입력'),
            numberInputBox(controller: weightController, hintText: '반려견의 무게를 입력하세요'),
          ],
        ),
        nextButton()
      ],
    );
  }

  Widget dogRegister3() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 27),
            titleBox(title: '거주 지역 선택'),
            locationDropdown(),
            titleBox(title: '반려견 성격 태그'),
            hashTagInputBox(),
            hashTagList(),
            const SizedBox(height: 35),
            titleBox(title: '반려견 특이사항'),
            textInputBox(
                controller: significantController,
                hintText: '반려견의 특이사항을 입력하세요 (최대500자)',
                maxLines: 7,
                maxLength: 500
            ),
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
                final DogProfileRegisterDTO dto = DogProfileRegisterDTO(
                    name: nameController.text,
                    breed: speciesController.text,
                    vaccine: dogInfo['vaccine']!['value'] == 1,
                    dogGender: dogInfo['gender'] == 1,
                    neutered: dogInfo['neuter'] == 1,
                    weight: double.parse(weightController.text),
                    region: selectedLocation!,
                    notes: significantController.text,
                    tags: hashTags,
                    age: int.parse(ageController.text),
                    file: profileImage
                );
    
                debugPrint('테스뚜');
                debugPrint('''
                ${dto.name}
                ${dto.breed}
                ${dto.vaccine}
                ${dto.dogGender}
                ${dto.neutered}
                ${dto.weight}
                ${dto.region}
                ${dto.notes}
                ${dto.tags}
                ${dto.age}
                ${dto.file}
                ''');
    
                DogProfileRepository().register(
                  context: context,
                  dto: dto
                ).then((response) {
                  Navigator.pop(context, response.statusCode);
                });

              }
          ).filledButton1m(),
        )
      ],
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

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      appBar: const PopHeader(title: '프로필 등록', useBackButton: true),
      body: InputFormUtil(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StepProgressBar(currentStep: pageIndex + 1, totalStep: 3),
            Flexible(
              child: dogRegister()
            ),
          ],
        ),
      )
    );
  }
}
