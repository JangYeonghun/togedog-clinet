import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/chat_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transition/transition.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final List<Map<String, dynamic>> test = [
    {
      'nickname' : 'ㄴㄴ',
      'lastMsg' : '안녕하세요~!',
      'lastMsgTime' : '2024-09-22 10:12:24',
      'unreadMsg' : 4
    },
    {
      'nickname' : 'SS',
      'lastMsg' : '안녕~!',
      'lastMsgTime' : '2024-09-22 23:56:58',
      'unreadMsg' : 4
    },
    {
      'nickname' : 'dd',
      'lastMsg' : '안녕하세요우오우와우~!',
      'lastMsgTime' : '2024-09-21 07:14:22',
      'unreadMsg' : 12
    },
    {
      'nickname' : 'ㄴㄴㄴㄴㄴㄴ',
      'lastMsg' : '@&@&@#^^*&@^#&*@^#&*@^#*@#^@*&#^*@&~!',
      'lastMsgTime' : '2024-09-11 07:14:22',
      'unreadMsg' : 12
    }
  ];

  Widget chatItem({
    required String nickname,
    required String lastMsg,
    required String lastMsgTime,
    required int unreadMsg
  }) {
    final Duration diff = DateTime.now().difference(DateTime.parse(lastMsgTime));
    late final String timePassed;

    if (diff.inMinutes <= 60) {
      timePassed = '${diff.inMinutes}분 전';
    } else if (diff.inHours <= 24) {
      timePassed = '${diff.inHours}시간 전';
    } else if (diff.inDays <= 7) {
      timePassed = '${diff.inDays}일 전';
    } else {
      timePassed = '${diff.inDays ~/ 7}주 전';
    }

    return InkWell(
      onTap: () => Navigator.push(
        context,
        Transition(
          transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
          child: ChatTemplate()
        )
      ),
      child: Container(
        padding: EdgeInsets.only(top: 29.h, bottom: 19.h),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nickname,
                    style: TextStyle(
                      color: Palette.darkFont2,
                      fontSize: 16.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    timePassed,
                    style: TextStyle(
                      color: Palette.darkFont1,
                      fontSize: 12.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 14.w, top: 12.h, bottom: 12.h, right: 15.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 191.w,
                    child: Text(
                      lastMsg,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Container(
                    width: 18.w,
                    height: 18.h,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.green6
                    ),
                    child: Text(
                      unreadMsg.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chatList() {
    return ListView.builder(
      itemCount: test.length,
      itemBuilder: (context, index) {
        final item = test[index];
        return chatItem(
          nickname: item['nickname'],
          lastMsg: item['lastMsg'],
          lastMsgTime: item['lastMsgTime'],
          unreadMsg: item['unreadMsg']
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      appBar: const PopHeader(title: '채팅', useBackButton: true),
      body: chatList()
    );
  }
}
