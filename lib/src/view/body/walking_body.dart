import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/view/component/profile_grid.dart';
import 'package:dog/src/view/component/walking/walking_profile_list.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        const ProfileGrid(),
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


  @override
  Widget build(BuildContext context) {
    debugPrint('MYLOG build WalkingBody');

    return Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(modeProvider);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PopHeader(title: mode ? '산책메이트 찾기' : '산책하기'),
          body: SingleChildScrollView(
            child: mode ? ownerWalking() : walkerWalking(),
          ),
        );
      },
    );
  }
}