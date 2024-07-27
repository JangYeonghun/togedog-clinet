import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/profile/dog_register.dart';
import 'package:dog/src/view/template/profile/walker_register.dart';
import 'package:flutter/material.dart';

class ProfileRegisterTemplate extends StatefulWidget {
  final TabController tabController;
  const ProfileRegisterTemplate({super.key, required this.tabController});

  @override
  State<ProfileRegisterTemplate> createState() => _ProfileRegisterTemplateState();
}

class _ProfileRegisterTemplateState extends State<ProfileRegisterTemplate> {
  final double deviceWidth = GlobalVariables.width;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      appBar: const PopHeader(title: '프로필 등록', useBackButton: true),
      body: Column(
        children: [
          TabBar(
              controller: widget.tabController,
              labelColor: Palette.darkFont4,
              unselectedLabelColor: Palette.darkFont2,
              indicatorColor: Palette.green6,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              overlayColor: const WidgetStatePropertyAll(
                  Colors.transparent
              ),
              tabs: [
                Container(
                  alignment: Alignment.center,
                  width: deviceWidth / 2,
                  height: 50,
                  child: const Text(
                    '반려견 프로필',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: deviceWidth / 2,
                  height: 50,
                  child: const Text(
                    '산책메이트 프로필',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                )
              ]
          ),
          Flexible(
            child: TabBarView(
              controller: widget.tabController,
              children: const [
                DogRegister(),
                WalkerRegister()
              ],
            ),
          ),
        ],
      )
    );
  }


}
