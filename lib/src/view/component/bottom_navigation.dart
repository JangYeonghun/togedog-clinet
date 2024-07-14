import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/provider/bottom_navigation_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  static const List<Map<String, dynamic>> menuList = <Map<String, dynamic>>[
    {
      'index': 0,
      'route': '/home',
      'name': '홈',
      'image': 'assets/images/nav_btn_home.png',
      'selectedImage': 'assets/images/nav_btn_home_active.png'
    },
    {
      'index': 1,
      'route': '/walking',
      'name': '산책하기',
      'image': 'assets/images/nav_btn_walking.png',
      'selectedImage': 'assets/images/nav_btn_walking_active.png'
    },
    {
      'index': 2,
      'route': '/my_walk',
      'name': '내산책',
      'image': 'assets/images/nav_btn_my_walk.png',
      'selectedImage': 'assets/images/nav_btn_my_walk_active.png'
    },
    {
      'index': 3,
      'route': '/profile',
      'name': '프로필',
      'image': 'assets/images/nav_btn_profile.png',
      'selectedImage': 'assets/images/nav_btn_profile_active.png'
    },
    {
      'index': 4,
      'route': '/my_page',
      'name': '마이페이지',
      'image': 'assets/images/nav_btn_my_page.png',
      'selectedImage': 'assets/images/nav_btn_my_page_active.png'
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavigationProvider);

    return Container(
      width: 1.sw,
      height: 80,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(30),
          //   topRight: Radius.circular(30),
          // ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(50, 0, 0, 0),
              blurRadius: 50.0.r,
              spreadRadius: 30.0.r,
              // offset: Offset(0, -0),
            ),
          ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: menuList
            .map(
              (e) => GestureDetector(
            onTap: () {
              ref.read(bottomNavigationProvider.notifier).setIndex(e['index']);
            },
            child: Container(
              color: Colors.transparent,
              width: 0.2.sw,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 25.w,
                      height: 25.h,
                      child: Image.asset(
                        currentIndex == e['index'] ? e['selectedImage'] : e['image'],
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      e['name'],
                      style: TextStyle(
                        color: currentIndex == e['index'] ? const Color(0xFF01DB97) : const Color(0xFF999999),
                        fontSize: 8.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).toList(),
      ),
    );
  }
}
