import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/model/user_account.dart';
import 'package:dog/src/repository/auth_repository.dart';
import 'package:dog/src/repository/user_profile_repository.dart';
import 'package:dog/src/util/firebase_cloud_message.dart';
import 'package:dog/src/util/loading_util.dart';
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
  AppLinks? _appLinks;
  bool isLogout = false;
  StreamSubscription<Uri?>? _uriSubscription;

  static const TextStyle textStyle = TextStyle(
      color: Palette.darkFont4,
      fontSize: 16,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500
  );

  Future<bool> checkAccessToken() async {
    final accessToken = await storage.read(key: 'accessToken');
    FlutterNativeSplash.remove();

    if (accessToken == null) {
      await initAppLinks();
      return false;
    }

    if (!(await AuthRepository().reissueToken())) {
      await initAppLinks();
      return false;
    }

    await FirebaseCloudMessage().tokenHandler();
    return true;
  }

  Future<void> initAppLinks() async {
    if (isLogout) {
      _appLinks = null;
      isLogout = false;
      return;
    }

    _appLinks = AppLinks();

    // 앱이 실행 중일 때
    _uriSubscription = _appLinks?.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleIncomingLink(uri);
      }
    });


    // 앱이 종료 되었을 때
    final appLinkUri = await _appLinks?.getInitialLink();
    if (appLinkUri != null) {
      _handleIncomingLink(appLinkUri);
    }
  }

  Future<void> _handleIncomingLink(Uri uri) async {
    debugPrint('Received link: $uri');
    if (uri.scheme == 'togedog' && uri.host == 'togedog' && uri.path.startsWith('/login')) {
      String? accessToken = uri.queryParameters['accessToken'];
      String? refreshToken = uri.queryParameters['refreshToken'];
      if (accessToken != null) {
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);
        debugPrint('Access Token: $accessToken');
        debugPrint('Refresh Token: $refreshToken');
        //setState(() {}); // Trigger a rebuild to check the access token again
        UserProfileRepository().getAccount().then((response) {
          if (response.statusCode ~/ 100 == 2) UserAccount().set(map: jsonDecode(response.body));
          Navigator.pushReplacementNamed(context, '/main');
        });
      }
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // args에서 isLogout 초기화
    isLogout = args?['isLogout'] ?? false; // 기본값을 false로 설정
  }

  @override
  void dispose() {
    _uriSubscription?.cancel();  // 리스너를 종료
    _tabController.dispose();
    super.dispose();
  }

  // 로그인 버튼
  Widget socialLogin({required String social}) {
    return InkWell(
        onTap: () async {
          await launchUrl(
            Uri(
              scheme: 'https',
              host: GlobalVariables.domain,
              path: 'oauth2/authorization/$social',
            ),
          );
          setState(() {});
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
          body: FutureBuilder<bool>(
            future: checkAccessToken(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: LoadingUtil());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == true) {
                // Access token exists, navigate to main
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  UserProfileRepository().getAccount().then((response) {
                    if (response.statusCode ~/ 100 == 2) UserAccount().set(map: jsonDecode(response.body));
                    Navigator.pushReplacementNamed(context, '/main');
                  });
                });
                return const SizedBox.shrink(); // Placeholder while navigating
                } else {
                  return Stack(
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
                  );
                }
            },
          ),
        )
    );
  }
}
