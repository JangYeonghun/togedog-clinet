import 'package:dog/src/config/palette.dart';
import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/view/component/home/home_mate_grid.dart';
import 'package:dog/src/view/component/walking/walking_profile_list.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/walking/posting_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transition/transition.dart';

class WalkingBody extends StatefulWidget {
  const WalkingBody({super.key});

  @override
  State<WalkingBody> createState() => _WalkingBodyState();
}

class _WalkingBodyState extends State<WalkingBody> {

  Widget ownerWalking() {
    return Column(
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.only(top: 15, left: 16),
          alignment: Alignment.centerLeft,
          child: const Text(
            '전체',
            style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const HomeMateGrid(),
      ],
    );
  }

  Widget walkerWalking() {
    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          child: const Text(
            '글 목록',
            style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const WalkingProfileList(),
      ],
    );
  }

  Widget customFloatingButton(BuildContext context) {
    return SizedBox(
      width: 70.w,
      height: 70.h,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            Transition(
              child: const PostingTemplate(),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
            ),
          );
        },
        backgroundColor: Palette.outlinedButton1,
        shape: const CircleBorder(),
        child: Image.asset('assets/images/posting_image.png', width: 30.w),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    debugPrint('MYLOG build WalkingBody');

    return Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(modeProvider);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PopHeader(title: mode ? '산책메이트 찾기' : '산책하기'),
          body: Stack(
            children: [
              SizedBox(
                height: 650.h,
                child: SingleChildScrollView(
                  child: mode ? ownerWalking() : walkerWalking(),
                ),
              ),
              if (mode)
                Positioned(
                  left: 0.74.sw,
                  right: 0,
                  top: 0.67.sh,
                  child: customFloatingButton(context),
                ),
            ],
          ),
        );
      },
    );
  }
}