import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:dog/src/view/template/profile/profile_register_template.dart';
import 'package:flutter/material.dart';

class ProfileTemplate extends StatefulWidget {
  const ProfileTemplate({super.key});

  @override
  State<ProfileTemplate> createState() => _ProfileTemplateState();
}

class _ProfileTemplateState extends State<ProfileTemplate> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final double deviceWidth = GlobalVariables.width;
  final String nickname = '닉네임';

  Future<void> getTestData() async {
    Future.delayed(const Duration(seconds: 2), (() {
      return null;
    }));
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget emptyProfile({required bool isDogProfile}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Pretendard',
            ),
            children: [
              TextSpan(
                text: "아직 ${isDogProfile ? '등록된 반려견' : '$nickname님의 프로필'}이 없어요",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                )
              ),
              const TextSpan(
                text: "\n\n",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700
                )
              ),
              TextSpan(
                text: "${isDogProfile ? '반려견' : '프로필'}을 등록하고 산책메이트를 찾아보세요!",
                style: const TextStyle(
                    color: Palette.darkFont2,
                    fontWeight: FontWeight.w500
                )
              ),
            ]
          )
        ),
        const SizedBox(height: 70),
        ButtonUtil(
            width: deviceWidth - 90,
            height: (deviceWidth - 90) / 285 * 55,
            title: '${isDogProfile ? '반려견' : '산책메이트'} 프로필 등록하기',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ProfileRegisterTemplate(
                        tabController: _tabController
                    );
                  }
              );
            }
        ).filledButton1m()
      ],
    );
  }

  Widget dogProfile() {
    return Column(
      children: [

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
        appBar: const PopHeader(title: '프로필 등록'),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
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
                controller: _tabController,
                children: [
                  emptyProfile(isDogProfile: true),
                  emptyProfile(isDogProfile: false),
                ],
              ),
            ),
          ],
        )
    );
  }
}
