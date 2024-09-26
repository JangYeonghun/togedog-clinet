import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/provider/mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlideTab extends StatefulWidget {
  const SlideTab({super.key});

  @override
  State<SlideTab> createState() => _SlideTabState();
}

class _SlideTabState extends State<SlideTab> with SingleTickerProviderStateMixin {
  final deviceHeight = GlobalVariables.height;
  late final TabController _tabController;
  final int count = 17;
  final int hours = 35;
  final String nickname = "댕댕이";
  final String dogName = "댕댕이";

  @override
  void initState() {
    // 탭 컨트롤러 초기화
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // 탭 컨트롤러 제거
    _tabController.dispose();
    super.dispose();
  }

  //탭 텍스트 컨텐츠
  Widget tabContent({
    required String content,
    required String imgSrc,
    required double imgHeight,
    required EdgeInsets imgPadding,
    required Color fontColor
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$nickname님 환영합니다!',
                style: TextStyle(
                  color: fontColor,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: TextStyle(
                    color: fontColor,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
          Padding(
            padding: imgPadding,
            child: Image.asset(imgSrc, height: imgHeight),
          )
        ],
      ),
    );
  }

  Widget ownerTab1() {
    return tabContent(
        content: '우리집 $dogName는 산책메이트 $count명과 함께\n즐거운 시간을 보냈어요!',
        imgSrc: 'assets/images/home_dog_1.png',
        imgHeight: 175,
        imgPadding: const EdgeInsets.only(left: 159, top: 85),
        fontColor: Colors.white
    );
  }

  Widget ownerTab2() {
    return tabContent(
        content: '우리집 $dogName는 산책메이트 $hours시간\n산책메이트와 추억을 쌓았어요!',
        imgSrc: 'assets/images/home_dog_2.png',
        imgHeight: 173,
        imgPadding: const EdgeInsets.only(left: 159, top: 84),
        fontColor: Colors.white
    );
  }

  Widget walkerTab1() {
    return tabContent(
        content: '이번 달 댕댕이들과 $count번의\n산책을 완료했어요!',
        imgSrc: 'assets/images/home_dog_3.png',
        imgHeight: 188,
        imgPadding: const EdgeInsets.only(left: 195, top: 78),
        fontColor: Colors.white
    );
  }

  Widget walkerTab2() {
    return tabContent(
        content: '한 달 동안 $hours시간\n댕댕이와 추억을 쌓았어요!',
        imgSrc: 'assets/images/home_dog_4.png',
        imgHeight: 181,
        imgPadding: const EdgeInsets.only(left: 157, top: 92),
        fontColor: Colors.white
    );
  }

  //탭 인디케이터에 사용할 동그라미
  Widget tabCircle({required Color color}) {
    return Container(
      height: 3,
      width: 3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 297,
      color: Colors.transparent,
      child: Consumer(
        builder: (context, ref, _) {
          final mode = ref.watch(modeProvider);
          return Stack(
            alignment: Alignment.topLeft,
            children: [
              TabBarView(
                  controller: _tabController,
                  children: [
                    mode ? ownerTab1() : walkerTab1(),
                    mode ? ownerTab2() : walkerTab2(),
                  ]
              ),
              Container(
                margin: const EdgeInsets.only(top: 124, left: 24),
                width: 16,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        tabCircle(color: Colors.white.withOpacity(0.5)),
                        tabCircle(color: Colors.white.withOpacity(0.5))
                      ],
                    ),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        tabCircle(color: Colors.transparent),
                        tabCircle(color: Colors.transparent)
                      ],
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 0.1,
                      indicator: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mode ? Colors.white : Palette.outlinedButton3
                      ),
                      dividerHeight: 0,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
