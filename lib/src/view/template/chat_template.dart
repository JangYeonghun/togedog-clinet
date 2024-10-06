import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/chat_message_dto.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/image_util.dart';
import 'package:dog/src/view/component/chat/chat_message_item.dart';
import 'package:dog/src/view/component/chat/chat_separator.dart';
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
  List<ChatMessageDTO> test = [
    ChatMessageDTO(
      userId: 32,
      content: 'ㅡㅏㅡㅏ',
      imgUrl: '',
      timestamp: '2024-09-17 00:05:07'
    ),
    ChatMessageDTO(
        userId: 32,
        content: '아오아오아오 으아으ㅏ으아 그아으아ㅡ아으ㅏ으ㅏㅇ 크ㅏ으아ㅡ아ㅡ아 으아ㅡ',
        imgUrl: '',
        timestamp: '2024-09-17 00:15:07'
    ),
    ChatMessageDTO(
        userId: 33,
        content: '테스뚜테스뚜',
        imgUrl: '',
        timestamp: '2024-09-22 14:01:05'
    ),
    ChatMessageDTO(
      userId: 33,
      content: '테테테테ㅔㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ먀내얻쟈ㅐㅓ애ㅑㄷ저래ㅑㅈ더랟ㅈ더랴ㅐㅈ더랟저래ㅑㅈ더랴ㅐㅓㄴ이ㅏ러나이러ㅏㅣㄴ러ㅏ닝러ㅏㅣㅇ너링나ㅓ리낭렁니ㅏ러ㅏㄴ이러ㅏㅇ니러ㅏㅇ니ㅓ링나ㅓㄹㅇ니ㅏㅐ더래ㅑ더ㅑㅐ',
      imgUrl: '',
      timestamp: '2024-09-22 14:01:10',
    ),
    ChatMessageDTO(
      userId: 33,
      content: '테스뚜테스뚜',
      imgUrl: '',
      timestamp: '2024-09-23 00:01:05',
    ),
    ChatMessageDTO(
      userId: 32,
      content: '테스뚜테스뚜',
      imgUrl: '',
      timestamp: '2024-09-23 00:05:07',
    ),
    ChatMessageDTO(
      userId: 33,
      content: 'ㄴㄴㄴㄴㄴㅈ댜러ㅐㅑㅈ더ㅓㅈ대러ㅐㅈ',
      imgUrl: '',
      timestamp: '2024-09-23 00:06:03',
    ),
    ChatMessageDTO(
      userId: 32,
      content: '',
      imgUrl: 'https://miro.medium.com/v2/resize:fit:4800/format:webp/1*y7yPy0OrJyeCOscaFAPwBg.jpeg',
      timestamp: '2024-09-23 00:15:00',
    ),
    ChatMessageDTO(
      userId: 32,
      content: 'ㅇㅇddd',
      imgUrl: '',
      timestamp: '2024-09-23 00:15:59',
    ),
    ChatMessageDTO(
      userId: 32,
      content: 'ㅇㅇ',
      imgUrl: '',
      timestamp: '2024-09-23 00:17:07',
    ),
    ChatMessageDTO(
      userId: 32,
      content: '이예아우와야이야아',
      imgUrl: '',
      timestamp: '2024-09-24 13:12:07',
    ),
  ];

  late List<ChatMessageDTO> rList;

  @override
  void dispose() {
    scrollController.dispose();
    chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    rList = test.reversed.toList();
    super.initState();
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
              final ChatMessageDTO currentMessage = rList[index];
              final bool isFirst = index == rList.length - 1;

              return ChatMessageItem(
                isMine: currentMessage.userId == testUserId,
                currentMessage: currentMessage,
                previousMessage: isFirst ? null : rList[index + 1],
                nextMessage: index == 0 ? null : rList[index - 1],
                isFirst: isFirst
              );
            },
            separatorBuilder: (context, index) {
              final ChatMessageDTO currentMessage = rList[index];
              final ChatMessageDTO? nextMessage = rList.length - 1 != index ? rList[index + 1] : null;
              return ChatSeparator(
                currentMessage: currentMessage,
                nextMessage: nextMessage,
              );
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
              onTap: () => sendMsg(content: chatController.text),
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
    test.add(
      ChatMessageDTO(
        userId: testUserId,
        content: content ?? '',
        imgUrl: imgUrl ?? '',
        timestamp: DateTime.now().toString()
      )
    );

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