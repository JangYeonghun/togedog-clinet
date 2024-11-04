import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/chat_room_dto.dart';
import 'package:dog/src/view/template/chat_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transition/transition.dart';

class ChatRoomListItem extends StatelessWidget {
  final ChatRoomDto chatRoomDto;
  const ChatRoomListItem({super.key, required this.chatRoomDto});

  String _passedTime() {
    final Duration diff = DateTime.now().difference(DateTime.parse(chatRoomDto.lastTime).toLocal());
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

    return timePassed;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          Transition(
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
              child: ChatTemplate(roomId: chatRoomDto.roomId, profileImage: "https://mentoapp.s3.ap-northeast-2.amazonaws.com/4add7998-8%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202024-10-01%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%203.28.42.png")
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
                    chatRoomDto.nickname,
                    style: TextStyle(
                        color: Palette.darkFont2,
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    _passedTime(),
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
                      chatRoomDto.content,
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
                      3.toString(),
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
}
