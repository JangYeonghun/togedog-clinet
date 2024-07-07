import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/view/component/home/profile_grid.dart';
import 'package:flutter/material.dart';

class RecordTab extends StatefulWidget {
  const RecordTab({super.key});

  @override
  State<RecordTab> createState() => _RecordTabState();
}

class _RecordTabState extends State<RecordTab> with SingleTickerProviderStateMixin {
  final deviceHeight = GlobalVariables.height;
  late final TabController _tabController;
  final int people = 17;
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
  Widget tabContent({required String content, required String imgSrc}) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$nickname님 환영합니다!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 159),
            child: Image.asset(imgSrc, height: 174),
          )
        ],
      ),
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
    return SingleChildScrollView(
      child: SizedBox(
        height: deviceHeight,
        child: Stack(
          children: [
            Container(
                color: Palette.green6,
                padding: const EdgeInsets.only(top: 239),
                child: const ProfileGrid()
            ),
            Container(
              height: 297,
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      tabContent(
                          content: '우리집 $dogName는 산책메이트 $people명과 함께\n즐거운 시간을 보냈어요!',
                          imgSrc: 'assets/images/home_dog_1.png'
                      ),
                      tabContent(
                          content: '우리집 $dogName는 산책메이트 $hours시간\n산책메이트와 추억을 쌓았어요!',
                          imgSrc: 'assets/images/home_dog_2.png'
                      )
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
                          indicator: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                          ),
                          dividerHeight: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
