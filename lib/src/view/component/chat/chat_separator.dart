import 'package:dog/src/dto/chat_message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatSeparator extends StatelessWidget {
  final ChatMessageDTO currentMessage;
  final ChatMessageDTO? nextMessage;
  const ChatSeparator({super.key, required this.currentMessage, this.nextMessage});

  bool _isDiffDate({
    required DateTime currentTime, required DateTime nextTime
  }) {
    return currentTime.year != nextTime.year || currentTime.month != nextTime.month || currentTime.day != nextTime.day;
  }

  Widget _separator() {

    if (nextMessage == null) {
      return const SizedBox();
    }

    final DateTime currentTime = DateTime.parse(currentMessage.timestamp);
    final DateTime nextTime = DateTime.parse(nextMessage!.timestamp);

    if (_isDiffDate(currentTime: currentTime, nextTime: nextTime)) {
      return Padding(
        padding: EdgeInsets.only(top: 26.h, bottom: 24.h),
        child: Center(
          child: Text(
            '${currentTime.year}년 ${currentTime.month}월 ${currentTime.day}일',
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      );
    }

    if (currentMessage.userId != nextMessage!.userId) {
      return SizedBox(height: 12.h);
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return _separator();
  }
}
