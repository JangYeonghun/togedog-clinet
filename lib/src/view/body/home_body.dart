import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/view/component/home/home_grid_text.dart';
import 'package:dog/src/view/component/home/home_profile_list.dart';
import 'package:dog/src/view/component/home/slide_tab.dart';
import 'package:dog/src/view/component/profile_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final deviceHeight = GlobalVariables.height;

  Widget ownerHome() {
    return Stack(
      children: [
        Container(
            color: Palette.green6,
            padding: const EdgeInsets.only(top: 239),
            child: const ProfileGrid(gridText: HomeGridText())
        ),
        const SlideTab()
      ],
    );
  }

  Widget walkerHome() {
    return Stack(
      children: [
        Container(
            color: Palette.green6,
            padding: const EdgeInsets.only(top: 239),
            child: const ProfileList()
        ),
        const SlideTab()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(modeProvider);
        return SingleChildScrollView(
          child: mode ? ownerHome() : walkerHome(),
        );
      },
    );
  }
}
