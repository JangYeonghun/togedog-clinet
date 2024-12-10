import 'package:dog/firebase_options.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/sqlite_config.dart';
import 'package:dog/src/repository/auth_repository.dart';
import 'package:dog/src/util/firebase_cloud_message.dart';
import 'package:dog/src/view/template/main_template.dart';
import 'package:dog/src/view/template/onboarding_template.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseCloudMessage().foreground();
  await FirebaseCloudMessage().terminated();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await FirebaseCloudMessage().setupFlutterNotifications();
  }

  // google map flutter
  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
    mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
  }

  SQLiteConfig();

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