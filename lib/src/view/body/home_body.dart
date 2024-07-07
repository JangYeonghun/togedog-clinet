import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/view/component/home/profile_grid.dart';
import 'package:dog/src/view/component/home/upper_tab.dart';
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
            child: const ProfileGrid()
        ),
        const UpperTab()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(modeProvider);
        return SingleChildScrollView(
          child: SizedBox(
            height: deviceHeight,
            child: mode ? ownerHome() : Center(child: Text('산책메이트'))
          ),
        );
      },
    );
  }
}
