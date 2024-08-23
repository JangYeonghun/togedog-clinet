import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/horizontal_divider.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationTemplate extends StatefulWidget {
  const NotificationTemplate({super.key});

  @override
  State<NotificationTemplate> createState() => _NotificationTemplateState();
}

class _NotificationTemplateState extends State<NotificationTemplate> {
  bool isSelectMode = false;
  List<Map<String, dynamic>> testNoti = [
    {
      'title' : '산책 매칭 수락',
      'content' : '태태림님이 산책 매칭 요청을 수락했어요',
      'timestamp' : '2024-08-24 01:16:02'
    },
    {
      'title' : '산책 매칭 거절',
      'content' : '훈이님이 산책 매칭 요청을 수락했어요',
      'timestamp' : '2024-08-22 02:12:02'
    },
    {
      'title' : '산책 매칭 수락',
      'content' : '태태림님이 산책 매칭 요청을 수락했어요',
      'timestamp' : '2024-08-13 14:16:02'
    },
    {
      'title' : '산책 매칭 거절',
      'content' : '훈이님이 산책 매칭 요청을 수락했어요',
      'timestamp' : '2024-08-11 02:12:02'
    },
    {
      'title' : '산책 매칭 수락',
      'content' : '태태림님이 산책 매칭 요청을 수락했어요',
      'timestamp' : '2024-08-14 14:16:02'
    }
  ];

  List<Map<String, dynamic>> testNewNoti = [
    {
      'title' : '산책 매칭 수락',
      'content' : 'AA님이 산책 매칭 요청을 수락했어요',
      'timestamp' : '2024-08-24 03:16:02'
    },
    {
      'title' : '산책 매칭 거절',
      'content' : 'BB님이 산책 매칭 요청을 수락했어요',
      'timestamp' : '2024-08-22 03:12:02'
    },
  ];

  Widget notificationItem({required Map<String, dynamic> notification, required int index}) {

    final bool isSelected = notification['isSelected'] != null && notification['isSelected'] == true;

    final diff = DateTime.now().difference(DateTime.parse(notification['timestamp']!));

    late final String timePassed;
    if (diff.inDays >= 7) {
      timePassed = "${diff.inDays ~/ 7}주전";
    } else if (diff.inHours >= 24) {
      timePassed = "${diff.inHours ~/ 24}일전";
    } else if (diff.inMinutes >= 60) {
      timePassed = "${diff.inMinutes ~/ 60}시간전";
    } else if (diff.inSeconds >= 60) {
      timePassed = "${diff.inSeconds ~/ 60}분전";
    }

    return InkWell(
      onTap: () {
        setState(() {
          if (notification['isSelected'] == null) {
            notification['isSelected'] = true;
          } else {
            notification['isSelected'] = !notification['isSelected'];
          }
        });
      },
      child: Row(
        children: [
          if (isSelectMode)
            selector(
              isSelected: isSelected,
              height: 109.h)
          ,
          Flexible(
            child: Container(
              height: 109.h,
              padding: EdgeInsets.only(top: 29.h, bottom: 31.h, left: 14.w, right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification['title']!,
                        style: isSelectMode ? TextStyle(
                          color: Palette.darkFont4,
                          fontSize: 14.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600
                        ) : TextStyle(
                          color: Palette.darkFont2,
                          fontSize: 12.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        timePassed,
                        style: TextStyle(
                            color: Palette.darkFont2,
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    notification['content']!,
                    style: TextStyle(
                      color: Palette.darkFont4,
                      fontSize: isSelectMode ? 12.sp : 16.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                    )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notifications() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: horizontalDivider()
            ),
            Padding(
              padding: EdgeInsets.only(left: 11.w, right: 13.w),
              child: Text(
                '최근 2주 알림',
                style: TextStyle(
                  color: Palette.darkFont2,
                  fontSize: 12.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400
                ),
              ),
            )
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: testNoti.length,
          itemBuilder: (context, index) {
            return notificationItem(
              notification: testNoti[index],
              index: index
            );
          }
        )
      ],
    );
  }

  Widget selector({required bool isSelected, required double height}) {
    return Container(
      width: 42.w,
      height: height,
      padding: EdgeInsets.only(top: 29.5.h),
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isSelected ? null : Border.all(width: 1, color: const Color(0xFF828282)),
            color: isSelected ? Palette.green6 : Colors.transparent
        ),
        width: 15.h,
        height: 15.h,
        child: Icon(
          Icons.check,
          size: 10.h,
          color: isSelected ? Colors.white : const Color(0xFF828282),
        ),
      ),
    );
  }

  Widget newNotificationItem({required Map<String, dynamic> notification}) {

    final bool isSelected = notification['isSelected'] != null && notification['isSelected'] == true;

    final diff = DateTime.now().difference(DateTime.parse(notification['timestamp']!));

    late final String timePassed;
    if (diff.inDays >= 7) {
      timePassed = "${diff.inDays ~/ 7}주전";
    } else if (diff.inHours >= 24) {
      timePassed = "${diff.inHours ~/ 24}일전";
    } else if (diff.inMinutes >= 60) {
      timePassed = "${diff.inMinutes ~/ 60}시간전";
    } else if (diff.inSeconds >= 60) {
      timePassed = "${diff.inSeconds ~/ 60}분전";
    }

    return InkWell(
      onTap: () {
        setState(() {
          if (notification['isSelected'] == null) {
            notification['isSelected'] = true;
          } else {
            notification['isSelected'] = !notification['isSelected'];
          }
        });
      },
      child: ColoredBox(
        color: Palette.ghostButton3,
        child: Row(
          children: [
            if (isSelectMode)
              selector(
                isSelected: isSelected,
                height: 120.h
              ),
            Flexible(
              child: Container(
                height: 120.h,
                padding: EdgeInsets.only(top: 29.h, bottom: 42.h, left: 14.w, right: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['title']!,
                          style: isSelectMode ? TextStyle(
                            color: Palette.darkFont4,
                            fontSize: 14.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600
                          ) :
                          TextStyle(
                            color: Palette.darkFont2,
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          timePassed,
                          style: TextStyle(
                            color: Palette.darkFont1,
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 13.5.h),
                    Text(
                      notification['content']!,
                      style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: isSelectMode ? 12.sp : 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                      )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget newNotifications() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: testNewNoti.length,
        itemBuilder: (context, index) {
          return newNotificationItem(
              notification: testNewNoti[index]
          );
        }
    );
  }

  Widget topLine() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.only(left: 14.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
              TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                  ),
                  children:[
                    TextSpan(
                        text: testNewNoti.length.toString(),
                        style: const TextStyle(
                          color: Palette.darkFont4,
                          fontWeight: FontWeight.w600,
                        )
                    ),
                    const TextSpan(
                      text: ' 개의 새로운 알림이 있습니다.',
                      style: TextStyle(
                        color: Palette.darkFont2,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ]
              )
          ),
          InkWell(
            onTap: () {
              setState(() {
                isSelectMode = !isSelectMode;
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 8.h, bottom: 8.h),
              child: Text(
                isSelectMode ? '선택' : '삭제',
                style: TextStyle(
                    color: const Color(0xFF818181),
                    fontSize: 12.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF818181)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      appBar: const PopHeader(title: '알림', useBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            topLine(),
            newNotifications(),
            SizedBox(height: 21.h),
            notifications()
          ],
        ),
      )
    );
  }
}
