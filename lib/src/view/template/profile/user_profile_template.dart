import 'dart:convert';

import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/user_profile_dto.dart';
import 'package:dog/src/repository/user_profile_repository.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:dog/src/view/template/profile/user_profile_detail_template.dart';
import 'package:dog/src/view/template/profile/user_register_template.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:transition/transition.dart';

class UserProfileTemplate extends StatefulWidget {
  const UserProfileTemplate({super.key});

  @override
  State<UserProfileTemplate> createState() => _UserProfileTemplateState();
}

class _UserProfileTemplateState extends State<UserProfileTemplate> {
  final double deviceWidth = GlobalVariables.width;
  final UserProfileRepository userProfileRepository = UserProfileRepository();
  late final Future<UserProfileDTO> userProfile;
  final String nickname = '닉네임';

  Future<UserProfileDTO> getMateProfiles() async {
    final Response response = await userProfileRepository.getProfile(context: context);

    if (response.body.isNotEmpty) {
      final dynamic json = jsonDecode(response.body);
      return UserProfileDTO.fromJson(json);
    } else {
      return UserProfileDTO.fromEmpty();
    }
  }

  @override
  void initState() {
    userProfile = getMateProfiles();
    super.initState();
  }

  Widget emptyProfile() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                        text: "아직 $nickname님의 프로필이 없어요",
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
                    const TextSpan(
                        text: "프로필을 등록하고 산책메이트를 찾아보세요!",
                        style: TextStyle(
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
              title: '산책메이트 프로필 등록하기',
              onTap: () => Navigator.push(
                  context,
                  Transition(
                      transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
                      child: const UserRegisterTemplate()
                  )
              ).then((result) {
                if (result ~/ 100 == 2) {
                  setState(() {
                    userProfile = getMateProfiles();
                  });
                }
              })
          ).filledButton1m()
        ],
      ),
    );
  }

  Widget mateProfiles() {
    return FutureBuilder(
        future: userProfile,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final UserProfileDTO mateProfileDTO = snapshot.data;
            return const LoadingUtil();
          } else {
            return const LoadingUtil();
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFF2F2F2),
        child: FutureBuilder(
            future: userProfile,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final UserProfileDTO data = snapshot.data;

                if (data.mateId != 0) {
                  return const UserProfileDetailTemplate();
                } else {
                  return emptyProfile();
                }

              } else {
                return const LoadingUtil();
              }
            }
        )
    );
  }
}
