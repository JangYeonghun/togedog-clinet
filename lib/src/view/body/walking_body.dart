import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/view/component/profile_grid.dart';
import 'package:dog/src/view/component/walking/walking_grid_text.dart';
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
    return const ProfileGrid(gridText: WalkingGridText());
  }

  Widget walkerWalking() {
    return const WalkingProfileList();
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