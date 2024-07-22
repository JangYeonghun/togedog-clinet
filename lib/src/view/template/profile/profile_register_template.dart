import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/text_input_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRegisterTemplate extends StatefulWidget {
  final TabController tabController;
  const ProfileRegisterTemplate({super.key, required this.tabController});

  @override
  State<ProfileRegisterTemplate> createState() => _ProfileRegisterTemplateState();
}

class _ProfileRegisterTemplateState extends State<ProfileRegisterTemplate> {
  final double deviceWidth = GlobalVariables.width;
  final TextEditingController dogHashTagController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController significantController = TextEditingController();
  final TextEditingController dogWeightController = TextEditingController();
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

  static const List<String> locations = ["서울", "인천", "경기", "충청", "경상", "전라", "강원", "제주"];
  String? selectedLocation;

  @override
  void initState() {
    dogHashTagListener();
    dogHashTagController.text = "#";
    super.initState();
  }

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 70),
          nextButton()
        ],
      ),
    );
  }

  Widget dogRegister2() {

    return SingleChildScrollView(
      child: Column(
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
          numberInputBox(controller: dogWeightController, hintText: '반려견의 무게를 입력하세요'),
          const SizedBox(height: 71),
          nextButton()
        ],
      ),
    );
  }

  Widget dogRegister3() {

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 27),
          titleBox(title: '거주 지역 선택'),
          locationDropdown(),
          titleBox(title: '반려견 성격 태그'),
          textInputBox(
              controller: dogHashTagController,
              hintText: "성격 해시태그를 등록하세요 (최대4개)",
              onChanged: hashTagHandler,
              padding: const EdgeInsets.only(left: 16, top: 10, bottom: 9, right: 16)
          ),
          hashTagList(),
          const SizedBox(height: 35),
          titleBox(title: '반려견 특이사항'),
          textInputBox(
              controller: significantController,
              hintText: '반려견의 특이사항을 입력하세요 (최대500자)',
              maxLines: 7,
              maxLength: 500
          ),
          const SizedBox(height: 78),
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
      ),
    );
  }

  // 해쉬태그 및 텍스트 관리
  void hashTagHandler(String value) {
    if (dogHashTagController.text == "") {
      dogHashTagController.text = "#";
    }
    List<String> split = value.replaceAll(" ", "").replaceAll(",", "").split('#');
    split.removeAt(0);

    // 해쉬태그 수 4개로 제한
    if (split.length > 4) {
      split.removeLast();
      dogHashTagController.text = dogHashTagController.text.substring(0, dogHashTagController.text.length - 1);
    }

    // #앞에 자동으로 띄어쓰기 추가, #앞의 띄어쓰기 한칸으로 변경
    if (dogHashTagController.text.endsWith('#') && !dogHashTagController.text.endsWith('# ') && previousHashTagTextLen < dogHashTagController.text.length) {
      dogHashTagController.text = "${dogHashTagController.text.substring(0, dogHashTagController.text.length - 1)} #";
    }

    // 각 태그 글자수 5글자로 제한
    if (split.isNotEmpty) {
      if (split.last.length > 5) {
        dogHashTagController.text = dogHashTagController.text.substring(0, dogHashTagController.text.length - 1);
        split.last = split.last.substring(0, 5);
      }
    }

    // #만 있는 빈 해쉬태그는 위젯 생성할 목록에서 제거
    split.remove("");

    setState(() {
      hashTags = split;
      previousHashTagTextLen = dogHashTagController.text.length;
    });
  }

  // 입력 커서 항상 맨 뒤로 유지
  void dogHashTagListener() {
    dogHashTagController.addListener(() {
      final text = dogHashTagController.text;
      final selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
      dogHashTagController.value = dogHashTagController.value.copyWith(
        selection: selection,
      );
    });
  }

  // 해쉬태그 제거
  void hashTagRemoveHandler({required String hashTag}) {
    String hashTagString = dogHashTagController.text;

    final RegExp regExp = RegExp(r"#([A-Za-z가-힣]+)");
    final Iterable<RegExpMatch> matches = regExp.allMatches(hashTagString);
    final List<String> matchList = matches.map((e) => e.group(0) ?? '').toList();

    hashTagString = "";
    matchList.remove("#$hashTag");

    for (String tag in matchList) {
      hashTagString += "$tag ";
    }

    setState(() {
      dogHashTagController.text = matchList.isNotEmpty ? hashTagString.substring(0, hashTagString.length - 1) : "";
      hashTags.remove(hashTag);
      if (hashTags.isEmpty) {
        dogHashTagController.text = "#";
      }
      previousHashTagTextLen = dogHashTagController.text.length;
    });
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
      body: Column(
        children: [
          TabBar(
              controller: widget.tabController,
              labelColor: Palette.darkFont4,
              unselectedLabelColor: Palette.darkFont2,
              indicatorColor: Palette.green6,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              overlayColor: const WidgetStatePropertyAll(
                  Colors.transparent
              ),
              tabs: [
                Container(
                  alignment: Alignment.center,
                  width: deviceWidth / 2,
                  height: 50,
                  child: const Text(
                    '반려견 프로필',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: deviceWidth / 2,
                  height: 50,
                  child: const Text(
                    '산책메이트 프로필',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                )
              ]
          ),
          Flexible(
            child: TabBarView(
              controller: widget.tabController,
              children: [
                dogRegister(),
                SizedBox()
              ],
            ),
          ),
        ],
      )
    );
  }
}
