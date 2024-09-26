import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/dto/user_profile_dto.dart';
import 'package:dog/src/view/component/walking/profile_detail.dart';
import 'package:flutter/material.dart';
import 'package:transition/transition.dart';

class HomeMateGridItem extends StatelessWidget {
  final double width;
  final double height;
  final UserProfileDTO userProfileDTO;

  const HomeMateGridItem({
      super.key,
      required this.width,
      required this.height,
      required this.userProfileDTO
  });

  Widget textContent({required String title, required String content}) {
    return Text.rich(
        TextSpan(
        style: const TextStyle(
            color: Color(0xFFF5F5F5),
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700),
        children: [
          TextSpan(text: title),
          TextSpan(
              text: content,
              style: const TextStyle(fontWeight: FontWeight.w400))
          ]
       )
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            Transition(
              child: ProfileDetail(userProfileDTO: userProfileDTO),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
            ),
        );
      },
      child: SizedBox(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                    width: width,
                    height: height,
                    child: CachedNetworkImage(fit: BoxFit.cover, imageUrl: userProfileDTO.profileImage)
                )
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 29, left: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textContent(
                        title: '닉네임 ',
                        content: '${userProfileDTO.nickname}(만 ${userProfileDTO.age}세, ${userProfileDTO.gender})'
                    ),
                    const SizedBox(height: 5),
                    textContent(
                        title: '선호 장소/위치 ',
                        content: userProfileDTO.region
                    )
                  ]
                )
            )
          ],
        ),
      ),
    );
  }
}
