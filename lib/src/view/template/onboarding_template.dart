import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingTemplate extends StatefulWidget {
  const OnboardingTemplate({super.key});

  @override
  State<OnboardingTemplate> createState() => _OnboardingTemplateState();
}

class _OnboardingTemplateState extends State<OnboardingTemplate> with SingleTickerProviderStateMixin {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late double deviceHeight;
  late double deviceWidth;
  late final TabController _tabController;
  late AppLinks _appLinks;

  static const TextStyle textStyle = TextStyle(
      color: Palette.darkFont4,
      fontSize: 16,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500
  );

  Future<void> checkAccessToken() async {
    await storage.read(key: 'accessToken').then((accessToken) {
      FlutterNativeSplash.remove();
      if (accessToken != null) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        initAppLinks();
      }
    });
  }

  Future<void> initAppLinks() async {
    _appLinks = AppLinks();

    // 앱이 실행 중일 때
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleIncomingLink(uri);
      }
    });

    // 앱이 종료 되었을 때
    final appLinkUri = await _appLinks.getInitialLink();
    if (appLinkUri != null) {
      _handleIncomingLink(appLinkUri);
    }
  }

  void _handleIncomingLink(Uri uri) {
    debugPrint('Received link: $uri');
    if (uri.scheme == 'togedog' && uri.host == 'togedog' && uri.path.startsWith('/login')) {
      String? accessToken = uri.queryParameters['accessToken'];
      String? refreshToken = uri.queryParameters['refreshToken'];
      if (accessToken != null) {
        storage.write(key: 'accessToken', value: accessToken).whenComplete(() {
          storage.write(key: 'refreshToken', value: refreshToken).whenComplete(() {
            debugPrint('Access Token: $accessToken');
            debugPrint('Refresh Token: $refreshToken');
            checkAccessToken();
          });
        });
      }
    }
  }

  @override
  void initState() {
    checkAccessToken();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 로그인 버튼
  Widget socialLogin({required String social}) {
    return InkWell(
        onTap: () async {
          await launchUrl(
            Uri(
              scheme: 'http',
              host: GlobalVariables.domain,
              port: GlobalVariables.port,
              path: 'oauth2/authorization/$social',
            ),
          );
        },
        child: Image.asset('assets/images/sign_with_$social.png', width: deviceWidth - 28)
    );
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
                padding: const EdgeInsets.only(top: 85, left: 14, right: 14),
                color: Colors.white,
                child: Column(
                  children: [
                    socialLogin(social: 'naver'),
                    const SizedBox(height: 10),
                    socialLogin(social: 'kakao'),
                    const SizedBox(height: 10),
                    socialLogin(social: 'google')
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
