import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/view/template/main_template.dart';
import 'package:dog/src/view/template/onboarding_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    GlobalVariables.width = MediaQuery.of(context).size.width;
    GlobalVariables.height = MediaQuery.of(context).size.height;
    // ScreenUtil 초기화
    return ScreenUtilInit(
      designSize: const Size(375, 812), // 아이폰 13 미니
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // 상단 시스템바 색상
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark
            )
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const OnboardingTemplate(),
            '/main': (context) => const MainTemplate(),
            // '/terms': (context) => const SignTermsTemplate(),
            // '/home': (context) => const MainTemplate(),
          },
        );
      },
    );
  }
}