import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/provider/bottom_navigation_bar_provider.dart';
import 'package:dog/src/view/body/home_body.dart';
import 'package:dog/src/view/body/my_page_body.dart';
import 'package:dog/src/view/body/my_walk_body.dart';
import 'package:dog/src/view/body/profile_body.dart';
import 'package:dog/src/view/body/walking_body.dart';
import 'package:dog/src/view/component/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// riverpod 4. 위젯 구현 ConsumerWidget / ConsumerStatefulWidget (provider stless / stful)
class MainTemplate extends ConsumerWidget {
  const MainTemplate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('MYLOG build MainTemplate');
    final currentIndex = ref.watch(bottomNavigationProvider); // riverpod 3. 상태 접근 및 수정 ref.watch()로 상태 읽고, ref.read()로 상태 수정
    GlobalVariables.width = MediaQuery.of(context).size.width;
    GlobalVariables.height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: <int, Widget>{
          0: const SafeArea(top: true, bottom: false, child: HomeBody()),
          1: const SafeArea(top: true, bottom: false, child: WalkingBody()),
          2: const SafeArea(top: true, bottom: false, child: MyWalkBody()),
          3: const SafeArea(top: true, bottom: false, child: ProfileBody()),
          4: const SafeArea(top: true, bottom: false, child: MyPageBody()),
        }[currentIndex]!,
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
