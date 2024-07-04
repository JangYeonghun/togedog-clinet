import 'package:dog/config/global_variables.dart';
import 'package:dog/config/palette.dart';
import 'package:flutter/material.dart';

class OnboardingTemplate extends StatefulWidget {
  const OnboardingTemplate({super.key});

  @override
  State<OnboardingTemplate> createState() => _OnboardingTemplateState();
}

class _OnboardingTemplateState extends State<OnboardingTemplate> with SingleTickerProviderStateMixin {
  late double deviceHeight;
  late double deviceWidth;
  late final TabController _tabController;
  static const TextStyle textStyle = TextStyle(
      color: Palette.darkFont4,
      fontSize: 16,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500
  );

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 온보딩 위젯
  Widget onboarding({required String content, required int index}) {
    return Container(
      padding: EdgeInsets.only(top: deviceHeight / 812 * 205),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Text(
            content,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          Image.asset('assets/images/onboarding_$index.png', height: 146),
          if (index == 3)
            Container(
                padding: const EdgeInsets.only(top: 85, left: 40, right: 40),
                color: Colors.white,
                child: Column(
                  children: [
                    Image.asset('assets/images/sign_with_naver.png', width: deviceWidth - 80),
                    const SizedBox(height: 10),
                    Image.asset('assets/images/sign_with_kakao.png', width: deviceWidth - 80),
                    const SizedBox(height: 10),
                    Image.asset('assets/images/sign_with_google.png', width: deviceWidth - 80),
                  ],
                ),
            )
        ],
      ),
    );
  }

  // 탭뷰 점 위젯
  Widget tabDot({bool colored = true}) {
    return Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colored ? const Color(0xFFD9D9D9) : Colors.transparent
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalVariables.width = MediaQuery.of(context).size.width;
    GlobalVariables.height = MediaQuery.of(context).size.height;
    deviceWidth = GlobalVariables.width;
    deviceHeight = GlobalVariables.height;
    return SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                bottom: deviceHeight / 812 * 220,
                child: SizedBox(
                  width: 120,
                  height: 7,
                  child: Stack(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            tabDot(),
                            tabDot(),
                            tabDot()
                          ]
                      ),
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          tabDot(colored: false),
                          tabDot(colored: false),
                          tabDot(colored: false),
                        ],
                        indicator: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Palette.green6
                        ),
                        overlayColor: const WidgetStatePropertyAll(
                            Colors.transparent
                        ),
                        indicatorWeight: 0.1,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                    ],
                  ),
                ),
              ),
              TabBarView(
                controller: _tabController,
                children: [
                  onboarding(content: '우리 강아지를 위한\n최고의 산책 메이트를 만나보세요.', index: 1),
                  onboarding(content: '강아지와의 산책, \n즐거움과 함께 보상도 누리세요!', index: 2),
                  onboarding(content: '쉽고 빠르게! 산책 메이트를 찾는\n가장 쉬운 방법, 같이걷개', index: 3),
                ],
              ),
            ],
          ),
        )
    );
  }
}
