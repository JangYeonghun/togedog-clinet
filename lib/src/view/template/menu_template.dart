import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/notification_template.dart';
import 'package:dog/src/view/template/onboarding_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transition/transition.dart';

class MenuTemplate extends StatefulWidget {
  const MenuTemplate({super.key});

  @override
  State<MenuTemplate> createState() => _MenuTemplateState();
}

class _MenuTemplateState extends State<MenuTemplate> {
  final String account = "dogmate@gmail.comㅁㅁㅁㅁㅁㅁㅁㅁㅁ";
  int notiCount = 3;

  Widget menuItem({
    required Function onTap,
    bool seperator = true,
    required Widget child
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 67.h,
        decoration: BoxDecoration(
          border: Border(
            bottom: seperator ? BorderSide(
              width: 1.w,
              color: const Color(0xFFF5F5F5)
            ) : BorderSide.none
          )
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget logOut() {
    return menuItem(
        onTap: () {
          const FlutterSecureStorage().delete(key: 'accessToken').whenComplete(() {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 16.w),
            Text(
              account.length >= 20 ? "${account.substring(0, 21)}..." : account,
              style: TextStyle(
                  color: const Color(0xFF222222),
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400
              ),
            ),
            SizedBox(width: 12.w),
            Icon(Icons.chevron_right, size: 24.w, color: Palette.outlinedButton3),
            SizedBox(width: 21.5.w),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(width: 1.w, color: Palette.outlinedButton3)
              ),
              padding: EdgeInsets.only(left: 6.w, right: 6.w, bottom: 2.h, top: 2.h),
              child: Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Palette.darkFont2,
                    fontSize: 12.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  )
              ),
            )
          ],
        )
    );
  }

  Widget alarm() {
    return menuItem(
      onTap: () {
        Navigator.push(
          context,
          Transition(
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
            child: const NotificationTemplate()
          )
        );
      },
      seperator: false,
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 1.h, right: 3.03.w),
                child: Image.asset('assets/images/notification_icon.png', height: 23.h)
              ),
              Container(
                height: 12.h,
                width: 12.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.green6
                ),
                alignment: Alignment.center,
                child: Text(
                  notiCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 7.w),
          Text(
            '알림',
            style: TextStyle(
              color: Palette.darkFont4,
              fontSize: 15.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500
            ),
          )
        ],
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      appBar: const PopHeader(title: '설정', useBackButton: true),
      body: Column(
        children: [
          logOut(),
          alarm()
        ],
      )
    );
  }
}
