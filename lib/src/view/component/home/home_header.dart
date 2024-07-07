import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/provider/mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.png', height: 20),
          const Row(
            children: [
              ModeSlider(),
              SizedBox(width: 9.5),
              NotificationIcon()
            ],
          )
        ],
      ),
    );
  }
}

// 모드 스위치 버튼
class ModeSlider extends StatefulWidget {
  const ModeSlider({super.key});

  @override
  State<ModeSlider> createState() => _ModeSliderState();
}

class _ModeSliderState extends State<ModeSlider> {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(modeProvider);
        return AnimatedToggleSwitch<bool>.dual(
            current: mode,
            first: false,
            second: true,
            spacing: 45,
            style: const ToggleStyle(
                borderColor: Colors.transparent,
                backgroundColor: Palette.outlinedButton1
            ),
            borderWidth: 2.5,
            height: 30,
            indicatorSize: const Size(25, 25),
            onChanged: (b) => ref.watch(modeProvider.notifier).setMode(b),
            styleBuilder: (b) =>
            const ToggleStyle(indicatorColor: Colors.white),
            textBuilder: (value) => Center(
              child: Text(
                  value ? '보호자' : '산책메이트',
                  style: const TextStyle(
                      color: Palette.darkFont4,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                  )
              ),
            )
        );
      },
    );
  }
}

// 알람 아이콘
class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  int noti = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Stack(
        children: [
          Image.asset('assets/images/notification_icon.png', height: 22),
          Positioned(
            top: 3,
            right: 0,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.green6
              ),
              alignment: Alignment.center,
              child: Text(
                noti.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


