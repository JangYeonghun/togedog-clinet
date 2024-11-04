import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/chat_message_dto.dart';
import 'package:dog/src/util/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessageItem extends StatefulWidget {
  final bool isMine;
  final ChatMessageDTO currentMessage;
  final ChatMessageDTO? previousMessage;
  final ChatMessageDTO? nextMessage;
  final bool isFirst;
  final String profileImage;

  const ChatMessageItem({
    super.key,
    required this.isMine,
    required this.currentMessage,
    required this.previousMessage,
    required this.nextMessage,
    required this.isFirst,
    required this.profileImage
  });

  @override
  State<ChatMessageItem> createState() => _ChatMessageItemState();
}

class _ChatMessageItemState extends State<ChatMessageItem> {

  bool profileChecker() {

    if (widget.isFirst) {
      return true;
    }

    if (widget.currentMessage.userId != widget.previousMessage?.userId) {
      return true;
    }

    final DateTime currentTimestamp = DateTime.parse(widget.currentMessage.timestamp).toLocal();
    final DateTime previousTimestamp = DateTime.parse(widget.previousMessage!.timestamp).toLocal();
    
    if (currentTimestamp.difference(previousTimestamp).inDays != 0) {
      return true;
    }

    return false;
  }

  Widget profile() {
    return profileChecker() ? Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: SizedBox(
        height: 36.h,
        width: 36.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: widget.profileImage.isNotEmpty
              ? CachedNetworkImage(
              imageUrl: widget.profileImage,
              fit: BoxFit.cover,
          )
              : Image.asset(
              'assets/images/profile_default.png',
              fit: BoxFit.cover
          ),
        ),
      )
    ) : SizedBox(
      width: 46.w,
    );
  }

  String formatTime({DateTime? dateTime}) {

    if (dateTime == null) {
      return '';
    }

    final bool isPM = dateTime.hour >= 12;
    final int formattedHour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final String period = isPM ? '오후' : '오전';
    final String formattedMinute = dateTime.minute.toString().padLeft(2, '0');

    return '$period $formattedHour:$formattedMinute';
  }

  DateTime? timestamp() {
    final currentTimestamp = DateTime.parse(widget.currentMessage.timestamp).toLocal();

    if (widget.nextMessage == null) {
      return currentTimestamp;
    }

    final previousTimestamp = DateTime.parse(widget.nextMessage!.timestamp).toLocal();

    if (widget.currentMessage.userId != widget.nextMessage?.userId) {
      return currentTimestamp;
    }

    if (currentTimestamp.difference(previousTimestamp).inMinutes != 0) {
      return currentTimestamp;
    }

    return null;
  }

  Widget renderTimestamp() {
    return Padding(
      padding: EdgeInsets.only(left: 6.w, right: 6.w),
      child: Text(
        formatTime(dateTime: timestamp()),
        style: TextStyle(
          color: Palette.darkFont4,
          fontSize: 10.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget messageBubble() {
    return ConstrainedBox(
      constraints: widget.currentMessage.content != '' ? BoxConstraints(
          maxWidth: widget.currentMessage.content.length <= 60 ? 172.w : 250.w
      ) : BoxConstraints(
          maxWidth: 240.w,
          maxHeight: 240.h
      ),
      child: Container(
        padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 6.h, bottom: 6.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isMine ? const Color(0xFFEBFAF3) : Colors.white
        ),
        child: widget.currentMessage.content != '' ? Text(
          widget.currentMessage.content,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: TextStyle(
              color: Palette.darkFont4,
              fontSize: 12.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400
          ),
        ) : GestureDetector(
          onTap: () => ImageUtil().viewImage(context: context, imgUrl: widget.currentMessage.imgUrl),
          child: SizedBox(
            height: 240.h,
            width: 240.w,
            child: ClipRRect(
              child: CachedNetworkImage(
                imageUrl: widget.currentMessage.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
      child: widget.isMine ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          renderTimestamp(),
          messageBubble()
        ],
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profile(),
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                messageBubble(),
                renderTimestamp()
              ],
            ),
          )
        ],
      ),
    );
  }
}
