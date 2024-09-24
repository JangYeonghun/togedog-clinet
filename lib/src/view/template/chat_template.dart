import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/image_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ChatTemplate extends StatefulWidget {
  const ChatTemplate({super.key});

  @override
  State<ChatTemplate> createState() => _ChatTemplateState();
}

class _ChatTemplateState extends State<ChatTemplate> {
  final TextEditingController chatController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  XFile? imageFile;
  final String testOppNickname = 'xxxx';
  final int testUserId = 33;
  double height = 0;
  double inputPaddingTop = 20.h;
  double inputPaddingBottom = 20.h;
  List<Map<String, dynamic>> test = [
    {
      'timestamp' : '2024-09-17 00:05:07',
      'userId' : 32,
      'content' : 'ㅡㅏㅡㅏ',
      'imgUrl' : ''
    },
    {
      'timestamp' : '2024-09-17 00:15:07',
      'userId' : 32,
      'content' : '아오아오아오 으아으ㅏ으아 그아으아ㅡ아으ㅏ으ㅏㅇ 크ㅏ으아ㅡ아ㅡ아 으아ㅡ',
      'imgUrl' : ''
    },
    {
      'timestamp' : '2024-09-22 14:01:05',
      'userId' : 33,
      'content' : '테스뚜테스뚜',
      'imgUrl' : ''
    },
    {
      'timestamp' : '2024-09-22 14:01:10',
      'userId' : 33,
      'content' : '테테테테ㅔㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ먀내얻쟈ㅐㅓ애ㅑㄷ저래ㅑㅈ더랟ㅈ더랴ㅐㅈ더랟저래ㅑㅈ더랴ㅐㅓㄴ이ㅏ러나이러ㅏㅣㄴ러ㅏ닝러ㅏㅣㅇ너링나ㅓ리낭렁니ㅏ러ㅏㄴ이러ㅏㅇ니러ㅏㅇ니ㅓ링나ㅓㄹㅇ니ㅏㅐ더래ㅑ더ㅑㅐ',
      'imgUrl' : ''
    },
    {
      'timestamp' : '2024-09-23 00:01:05',
      'userId' : 33,
      'content' : '테스뚜테스뚜',
      'imgUrl' : ''
    },
    {
      'timestamp' : '2024-09-23 00:05:07',
      'userId' : 32,
      'content' : '테스뚜테스뚜',
      'imgUrl' : ''
    },
    {
      'timestamp' : '2024-09-23 00:06:03',
      'userId' : 33,
      'content' : 'ㄴㄴㄴㄴㄴㅈ댜러ㅐㅑㅈ더ㅓㅈ대러ㅐㅈ',
      'imgUrl' : ''
    },
    {
      'timestamp' : '2024-09-23 00:15:00',
      'userId' : 32,
      'content' : '',
      'imgUrl' : 'https://miro.medium.com/v2/resize:fit:4800/format:webp/1*y7yPy0OrJyeCOscaFAPwBg.jpeg'
    },
    {
      'timestamp' : '2024-09-23 00:15:59',
      'userId' : 32,
      'content' : 'ㅇㅇddd',
      'imgUrl' : ''
    },
    {
      'timestamp' : '2024-09-23 00:17:07',
      'userId' : 32,
      'content' : 'ㅇㅇ',
      'imgUrl' : ''
    },
  ];

  late List<Map<String, dynamic>> rList;

  @override
  void initState() {
    rList = test.reversed.toList();
    super.initState();
  }
  
  String timeFormatter({required DateTime dateTime}) {
    final bool isPM = dateTime.hour >= 12;
    String result = isPM ? '오후' : '오전';
    
    if (dateTime.hour == 0) {
      result += '12';
    } else if (isPM) {
      result += '${dateTime.hour - 12}';
    } else {
      result += '${dateTime.hour}';
    }
    
    result += ':${dateTime.minute.toString().padLeft(2, '0')}';
    
    return result;
  }

  Widget msgBubble({
    required String content,
    required String imgUrl,
    required Color color
  }) {
    return ConstrainedBox(
      constraints: content != '' ? BoxConstraints(
        maxWidth: content.length <= 60 ? 172.w : 250.w
      ) : BoxConstraints(
        maxWidth: 250.w,
        maxHeight: 250.h
      ),
      child: Container(
        padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 6.h, bottom: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color
        ),
        child: content != '' ? Text(
          content,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: TextStyle(
            color: Palette.darkFont4,
            fontSize: 12.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400
          ),
        ) : GestureDetector(
          onTap: () => ImageUtil().viewImage(context: context, imgUrl: imgUrl),
          child: SizedBox(
            height: 290.h,
            width: 290.w,
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ),
    );
  }

  Widget timestamp({required int index}) {
    late final bool isTimestampActive;
    final DateTime temp1 = DateTime.parse(rList[index]['timestamp']);

    if (index == 0 || rList[index]['userId'] != rList[index - 1]['userId']) {
      isTimestampActive = true;
    } else {

      final DateTime temp2 = DateTime.parse(rList[index - 1]['timestamp']);
      if (temp1.difference(temp2).inMinutes == 0) {
        isTimestampActive = false;
      } else {
        isTimestampActive = true;
      }
    }

    return Text(
      isTimestampActive ? timeFormatter(dateTime: temp1) : '',
      style: TextStyle(
          color: Palette.darkFont4,
          fontSize: 10.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500
      ),
    );
  }

  Widget opponentMsg({
    required int index,
    required String content,
    required String imgUrl
  }) {
    late final bool isProfileActive;

    if (index != rList.length - 1 && rList[index]['userId'] != rList[index + 1]['userId']) {
      isProfileActive = true;
    } else if (index == rList.length - 1) {
      isProfileActive = true;
    } else {
      isProfileActive = false;
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isProfileActive)
          Image.asset('assets/images/profile_default.png', height: 36.h, width: 36.w),
        SizedBox(width: isProfileActive ? 10.w : 46.w),
        Padding(
          padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              msgBubble(content: content, imgUrl: imgUrl, color: Colors.white),
              SizedBox(width: 4.w),
              timestamp(index: index)
            ]
          ),
        )
      ],
    );
  }

  Widget myMsg({
    required int index,
    required String content,
    required String imgUrl
  }) {

    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          timestamp(index: index),
          SizedBox(width: 4.w),
          msgBubble(content: content, imgUrl: imgUrl, color: const Color(0xFFEBFAF3))
        ],
      ),
    );
  }

  Widget separator({required int index}) {

    if (index != rList.length - 1) {
      final Map<String, dynamic> item1 = rList[index];
      final Map<String, dynamic> item2 = rList[index + 1];

      final DateTime tempDate1 = DateTime.parse(item1['timestamp']);
      final DateTime tempDate2 = DateTime.parse(item2['timestamp']);

      if (tempDate2.year != tempDate1.year || tempDate1.month != tempDate2.month || tempDate1.day != tempDate2.day) {

        return Padding(
          padding: EdgeInsets.only(top: 26.h, bottom: 24.h),
          child: Center(
            child: Text(
              '${tempDate1.year}년 ${tempDate1.month}월 ${tempDate1.day}일',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        );

      } else {

        if (item1['userId'] != item2['userId']) {
          return SizedBox(height: 12.h);
        } else {
          return const SizedBox();
        }

      }
    } else {
      return const SizedBox();
    }
  }
  
  Widget msgList() {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            height = 0;
            inputPaddingTop = 20.h;
            inputPaddingBottom = 20.h;
          });
        },
        child: Container(
          color: const Color(0xFFF2F2F2),
          alignment: Alignment.topCenter,
          child: ListView.separated(
            reverse: true,
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            padding: EdgeInsets.only(top: 10.h, left: 14.w, right: 14.w),
            itemCount: rList.length,
            itemBuilder: (context, index) {
              final item = rList[index];

              return item['userId'] == testUserId ?
                myMsg(index: index, content: item['content'], imgUrl: item['imgUrl']) :
                opponentMsg(index: index, content: item['content'], imgUrl: item['imgUrl']);
            },
            separatorBuilder: (context, index) {
              return separator(index: index);
            },
          ),
        ),
      ),
    );
  }

  Widget inputBoxExtend() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: height,
      color: const Color(0xFFF2F2F2),
      padding: EdgeInsets.only(left: 40.w, right: 40.w, top: 28.h, bottom: 28.h),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    imageFile = await ImageUtil().getImage(
                      context: context,
                      imageSource: ImageSource.gallery
                    );
                    if (imageFile != null) {
                      sendMsg(imgUrl: 'https://cdn.inflearn.com/public/course-325829-cover/dbf21271-7ce3-4e26-880c-22cd4d8c226b');
                    }
                  },
                  child: Image.asset('assets/images/photo_icon.png', width: 50.w)
                ),
                SizedBox(height: 6.h),
                Text(
                  '사진',
                  style: TextStyle(
                    color: Palette.darkFont4,
                    fontSize: 12.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500
                  )
                )
              ],
            ),
            SizedBox(width: 24.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    imageFile = await ImageUtil().getImage(
                      context: context,
                      imageSource: ImageSource.camera
                    );
                    if (imageFile != null) {
                      sendMsg(imgUrl: 'https://cdn.inflearn.com/public/course-325829-cover/dbf21271-7ce3-4e26-880c-22cd4d8c226b');
                    }
                  },
                  child: Image.asset('assets/images/camera_icon.png', width: 50.w)
                ),
                SizedBox(height: 6.h),
                Text(
                    '카메라',
                    style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget inputBoxMain() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.fromLTRB(14.w, inputPaddingTop, 14.w, inputPaddingBottom),
      color: const Color(0xFFF2F2F2),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  height = height == 0 ? 290 : 0;
                  inputPaddingTop = inputPaddingTop == 20.h ? 12.h : 20.h;
                  inputPaddingBottom = inputPaddingBottom == 20.h ? 8.h : 20.h;
                });
              },
              child: Image.asset('assets/images/expand_button.png', width: 36.w)
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              child: RawScrollbar(
                controller: scrollController,
                radius: const Radius.circular(10),
                thickness: 2,
                thumbVisibility: true,
                padding: EdgeInsets.only(top: 6.h, right: 3.w, bottom: -16.h),
                child: TextField(
                  scrollController: scrollController,
                  controller: chatController,
                  minLines: 1,
                  maxLines: 5,
                  onTap: () {
                    setState(() {
                      height = 0;
                      inputPaddingTop = 20.h;
                      inputPaddingBottom = 20.h;
                    });
                  },
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.only(left: 10.w, right: 10.w, top: 11.h, bottom: 11.h),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide.none
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none
                    )
                  ),
                  cursorColor: Palette.green6,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            )
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () {

              sendMsg(content: chatController.text);

            },
            child: Image.asset('assets/images/send_button.png', width: 36.w)
          ),
        ],
      ),
    );
  }

  void sendMsg({
    String? content,
    String? imgUrl
  }) {
    test.add({
      'timestamp' : DateTime.now().toString(),
      'userId' : testUserId,
      'content' : content ?? '',
      'imgUrl' : imgUrl ?? ''
    });

    rList = test.reversed.toList();

    chatController.text = '';

    setState(() {
      height = 0;
      inputPaddingTop = 20.h;
      inputPaddingBottom = 20.h;
    });
  }

  Widget inputBox() {

    return Column(
      children: [
        inputBoxMain(),
        inputBoxExtend()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      appBar: PopHeader(title: testOppNickname, useBackButton: true),
      body: Column(
        children: [
          msgList(),
          inputBox()
        ],
      )
    );
  }
}
