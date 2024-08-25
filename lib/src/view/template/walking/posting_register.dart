import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/text_input_util.dart';
import 'package:dog/src/view/component/walking/posting_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostingRegister extends StatefulWidget {

  const PostingRegister({super.key});

  @override
  State<PostingRegister> createState() => _PostingRegisterState();
}

class _PostingRegisterState extends State<PostingRegister> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController hashTagController = TextEditingController();
  final TextEditingController placeRecController = TextEditingController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController wageController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();


  static const List<String> locations = ["서울", "인천", "경기", "충청", "경상", "전라", "강원", "제주"];
  static const List<String> wages = ["시급", "건당"];
  static const List<Map<String, dynamic>> testData = [
    {
      'name': '뽀삐',
      'species': '웰시코기',
      'age': 3,
      'imgUrl': 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzAzMjNfMTg1%2FMDAxNjc5NTQyNTYzNjU4.9aj6sJRExdpVzm3JqillN5CBljpKSUHjyWnpSAXeXTYg.oYA4T0TidaQWbDrrJv21Pb7nZ4dMsB3ut-aIzl2HT04g.JPEG.imkimbom_%2Foutput_861680940.jpg&type=a340'
    },
    {
      'name': '설이',
      'species': '포메라니안',
      'age': 2,
      'imgUrl': 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyNDAyMDVfNjIg%2FMDAxNzA3MTEyMDgxMDg3._SnnduCEZqfjDDCBlTH9CCFeED8NVndAB6uNhTPmYjwg.-8-DmtSIS1RhPsZeP90lNzXTpIeFMTAb2l4sbn5VBcIg.JPEG.nono83123%2F1707111397354.jpg&type=a340'
    },
  ];

  String? selectedLocation;
  String? wage = '시급';
  String _startTime = '시작';
  String _endTime = '종료';

  int pageNum = 1;
  int selectedIndex = 0;

  List<String> hashTagList = [];
  List<bool> isProfileSelected = List.filled(testData.length, false);

  DateTime _selectedDate = DateTime.now();

  TextStyle commonTextStyle({
    Color fontColor = Palette.darkFont4,
    double fontSize = 14
  }) {
    return TextStyle(
      color: fontColor,
      fontSize: fontSize.sp,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
      height: 0,
    );
  }

  // 번호당 각 화면
  Widget postingRegister() {
    switch (pageNum) {
      case 1:
        return postRegister1();
      case 2:
        return postRegister2();
      case 3:
        return postRegister3();
      case 4:
        return postRegister4();
      case 5:
        return postRegister5();
      default:
        return postRegister1();
    }
  }

  Widget postRegister1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topInfo(text: '글 작성'),
        textInfo(text: '제목'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: TextInputUtil().text(
              controller: titleController,
              hintText: '제목'
          ),
        ),
        textInfo(text: '산책 장소 추천'),
        inputHashTag(),
        showHashTagList(),
        textInfo(text: '픽업 지역'),
        locationDropdown(),
        nextButton(space: 128.h),
      ],
    );
  }

  Widget postRegister2() {
    return Column(
      children: [
        nextButton(space: 128.h),

      ],
    );
  }

  Widget postRegister3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topInfo(text: "반려견 선택"),
        selectAllButton(),
        buildDogProfileList(),
        nextButton(space: 172.h),
      ],
    );
  }

  Widget postRegister4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topInfo(text: '산책 일시 선택'),
        PostingCalendar(
          onDateSelected: _onDateSelected,
        ),
        textInfo(text: '시간'),
        selectTime(),
        nextButton(space: 109.h),
      ],
    );
  }
  Widget postRegister5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textInfo(text: '임금'),
        selectWages(),
        textInfo(text: '연락처'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: TextInputUtil().phone(
              controller: phoneNumController,
              hintText: '연락처'
          ),
        ),
        nextButton(space: 268.h),
      ],
    );
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
      _startTime = '시작';
      _endTime = '종료';
    });
    debugPrint('부모 위젯에서 받은 날짜: $_selectedDate');
  }

  List<String> startTimeSlots(DateTime selectedDate) {
    List<String> timeSlots = [];
    DateTime now = DateTime.now();

    DateTime startTime;
    DateTime endTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 0);

    if (selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day) {
      // 오늘 날짜인 경우
      startTime = now.minute < 30
          ? DateTime(now.year, now.month, now.day, now.hour, 30).add(const Duration(minutes: 30))
          : DateTime(now.year, now.month, now.day, now.hour + 1, 0).add(const Duration(minutes: 30));
    } else if (selectedDate.year < now.year || selectedDate.month < now.month || selectedDate.day < now.day) {
      // 이전 날짜인 경우
      return timeSlots;
    }  else {
      // 오늘이 아닌 날짜인 경우
      startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0);
    }

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      String formattedTime = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      timeSlots.add(formattedTime);
      startTime = startTime.add(const Duration(minutes: 30));
    }

    return timeSlots;
  }

  List<String> endTimeSlots(DateTime selectedDate) {
    List<String> timeSlots = [];
    DateTime now = DateTime.now();
    DateTime startTime;
    DateTime endTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 30);

    if (_startTime != '시작') {
      List<String> timeParts = _startTime.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      startTime = DateTime(now.year, now.month, now.day, hour, minute).add(const Duration(minutes: 30));
      endTime = DateTime(now.year, now.month, now.day, 23, 30);
    } else if (selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day) {
      // 오늘 날짜인 경우
      startTime = now.minute < 30
          ? DateTime(now.year, now.month, now.day, now.hour, 30).add(const Duration(hours: 1))
          : DateTime(now.year, now.month, now.day, now.hour + 1, 0).add(const Duration(hours: 1));
      endTime = DateTime(now.year, now.month, now.day, 23, 30);
    } else if (selectedDate.year < now.year || selectedDate.month < now.month || selectedDate.day < now.day) {
      // 이전 날짜인 경우(_onDateSelected 여기서 1차 막힘)
      return timeSlots;
    } else {
      // 오늘 아닌 날짜인 경우
      startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 30);
    }

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      String formattedTime = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
      timeSlots.add(formattedTime);
      startTime = startTime.add(const Duration(minutes: 30));
    }

    return timeSlots;
  }

  Widget topInfo({
    required String text,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 16.h),
      child: Text(
        text,
        style: commonTextStyle(),
      ),
    );
  }

  Widget textInfo({
    required String text,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 30.h, 0, 10.h),
      child: Text(
        text,
        style: commonTextStyle(fontSize: 12),
      ),
    );
  }

  Widget inputHashTag() {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
      child: TextField(
        controller: hashTagController,
        style: TextInputUtil().textStyle,
        textInputAction: TextInputAction.go,
        onChanged: (value) {
          if (value.length > 8) {
            // 토스트 팝업!
            hashTagController.text = value.substring(0, 7);
          }
        },
        onSubmitted: (value) {
          setState(() {
            hashTagList.add(value);
            hashTagController.text = '';
          });
        },
        keyboardType: TextInputType.text,
        decoration: TextInputUtil().inputDecoration(hintText: '산책 장소 추천(최대 2개)'),
      ),
    );
  }

  Widget showHashTagList() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Row(
        children: hashTagList.map((e) {
          return Container(
            margin: EdgeInsets.only(right: 9.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(width: 1.w, color: Palette.green6)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 14.w, top: 8.h, bottom: 8.h, right: 6.w),
                  child: Text(
                    e,
                    style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      hashTagList.remove(e);
                    });
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
        }).toList(),
      ),
    );
  }

  Widget locationDropdown() {
    return Center(
      child: Container(
        width: 347.w,
        height: 46.h,
        margin: const EdgeInsets.only(bottom: 30, top: 10),
        padding: const EdgeInsets.only(left: 16, right: 24),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Palette.outlinedButton1),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: DropdownButton(
              isExpanded: true,
              hint: Text(
                '픽업 지역',
                style: TextStyle(
                    color: Palette.darkFont2,
                    fontSize: 12.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500
                ),
              ),
              dropdownColor: Colors.white,
              icon: Icon(Icons.keyboard_arrow_down, size: 17.w, color: Palette.darkFont2),
              underline: const SizedBox(),
              value: selectedLocation,
              items: locations.map((e) {
                return DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(
                          color: Palette.darkFont4,
                          fontSize: 12.sp,
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
      ),
    );
  }

  Widget nextButton({
    double space = 0
  }) {
    return Padding(
      padding: EdgeInsets.only(top: space.h),
      child: Center(
        child: ButtonUtil(
            width: 347.w,
            height: 51.h,
            title: '다음',
            onTap: () {
              setState(() {
                pageNum += 1;
              });
            }
        ).filledButton1m(),
      ),
    );
  }

  Widget buildDogProfileList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: testData.length,
        itemBuilder: (context, index) {
          bool isExistProfile = testData.length < 4 && index + 1 == testData.length;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: dogProfileBox(
                  dogData: testData[index],
                    isSelected: isProfileSelected[index],
                    onTap: () {
                    setState(() {
                      isProfileSelected[index] = !isProfileSelected[index];
                    });
                  }
                ),
              ),
              if (isExistProfile)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: dogProfileAdd(),
                ),
            ],
          );
        }
    );
  }

  Widget selectAllButton() {
    return Padding(
      padding: EdgeInsets.only(left: 275.w, top: 5.h, right: 25.w, bottom: 32.h),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isProfileSelected.every((element) => element == true)) {
              isProfileSelected = List.filled(testData.length, false);
            } else {
              isProfileSelected = List.filled(testData.length, true);
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '전체선택',
              style: TextStyle(
                color: const Color(0xFF818181),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 5.w),
            Container(
              width: 15.w,
              height: 15.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isProfileSelected.every((element) => element == true)
                    ? Palette.green6
                    : Colors.transparent,
                border: Border.all(
                  color: isProfileSelected.every((element) => element == true)
                      ? Colors.transparent
                      : Palette.outlinedButton3,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 10.w,
                color: isProfileSelected.every((element) => element == true)
                    ? Colors.white
                    : Palette.outlinedButton3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dogProfileBox({
    required Map<String, dynamic> dogData,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 347.w,
          height: 80.h,
          decoration: ShapeDecoration(
            color: isSelected ? Palette.green2 : Palette.outlinedButton1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: EdgeInsets.only(left: 15.w, right: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipOval(
                      child: SizedBox(
                          width: 53,
                          height: 53,
                          child: CachedNetworkImage(
                            imageUrl: dogData['imgUrl'],
                            fit: BoxFit.cover,
                          ),
                      ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dogData['name'],
                        style: TextStyle(
                          color: Palette.darkFont4,
                          fontSize: 16.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 11.h),
                      Text(
                        '${dogData['species']} / ${dogData['age']}살',
                        style: TextStyle(
                            color: Palette.darkFont2,
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              checkBox(
                isSelected: isSelected
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dogProfileAdd() {
    return Container(
      width: 347.w,
      height: 80.h,
      decoration: ShapeDecoration(
        color: Palette.outlinedButton1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      padding: EdgeInsets.only(left: 15.w, right: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 20.r, color: const Color(0xFF818181)),
          SizedBox(width: 4.w),
          Text(
            '추가하기',
            style: TextStyle(
              color: const Color(0xFF818181),
              fontSize: 16.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget checkBox({
    required bool isSelected,
  }) {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Palette.green6 : Palette.outlinedButton3
      ),
      child: Icon(
        Icons.check,
        size: 10.w,
        color: Colors.white,
      ),
    );
  }

  Widget selectTimeBox({
    required String text,
    required String type
  }) {
    return Container(
      width: 156.w,
      height: 46.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4C433F), width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Palette.darkFont4,
                      fontSize: 12.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            selectTimeMenu(type: type),
          ],
        )
    );
  }

  Widget selectTimeMenu({
    required String type,
  }) {
    List<String> getTimeSlots() {
      return type == 'start' ? startTimeSlots(_selectedDate) : endTimeSlots(_selectedDate);
    }

    return PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down_sharp, size: 25),
      offset: type == 'start' ? const Offset(-120, 0) : const Offset(0, 0),
      onSelected: (String value) {
        setState(() {
          type == 'start'
              ? _startTime = value
              : _endTime = value;
        });
      },
      itemBuilder: (BuildContext context) {
        List<String> timeSlots = getTimeSlots();
        if (timeSlots.length >= 4) {
          return [
            PopupMenuItem<String>(
              child: SizedBox(
                width: 50.w,
                height: 180.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: timeSlots.map((String choice) {
                      return ListTile(
                        title: Text(
                          choice,
                          style: TextStyle(
                            color: Palette.darkFont4,
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            type == 'start'
                                ? _startTime = choice
                                : _endTime = choice;
                            Navigator.pop(context);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ];
        } else {
          return timeSlots.map((String choice) {
            return PopupMenuItem<String>(
              child: ListTile(
                title: Text(
                  choice,
                  style: TextStyle(
                    color: Palette.darkFont4,
                    fontSize: 12.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    type == 'start'
                        ? _startTime = choice
                        : _endTime = choice;
                    Navigator.pop(context);
                  });
                },
              ),
            );
          }).toList();
        }
      },
    );
  }

  Widget selectTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        selectTimeBox(text: _startTime, type: 'start'),
        SizedBox(
          width: 25.w,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '~',
              style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        selectTimeBox(text: _endTime, type: 'end'),
      ],
    );
  }

  Widget selectWages() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 166.w,
            height: 44.h,
            margin: const EdgeInsets.only(bottom: 30, top: 10),
            padding: const EdgeInsets.only(left: 16, right: 24),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Palette.outlinedButton1),
                borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: DropdownButton(
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down, size: 17.w, color: Palette.darkFont2),
                  underline: const SizedBox(),
                  value: wage,
                  items: wages.map((e) {
                    return DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(
                              color: Palette.darkFont4,
                              fontSize: 12.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500
                          ),
                        )
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      wage = value!;
                    });
                  }
              ),
            ),
          ),
          SizedBox(
            width: 166.w,
            height: 55.h,
            child: TextInputUtil().money(
                controller: wageController,
                hintText: '15,000',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return postingRegister();
  }
}