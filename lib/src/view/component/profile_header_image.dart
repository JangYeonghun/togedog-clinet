import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/dto/user_profile_dto.dart';
import 'package:dog/src/view/component/profile_details_flip_side.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transition/transition.dart';

bool trigger = true;

class ProfileHeaderImage extends StatelessWidget {
  final UserProfileDTO userProfileDTO;

  const ProfileHeaderImage({
    super.key,
    required this.userProfileDTO,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (trigger) {
          Navigator.push(
            context,
            Transition(
              child: ProfileDetailsFlipSide(userProfileDTO: userProfileDTO),
              transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
            ),
          );
          trigger = !trigger;
        } else {
          Navigator.pop(context);
          trigger = !trigger;
        }
      },
      child: SizedBox(
        width: 1.sw,
        height: 523.h,
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: userProfileDTO.profileImage
        ),
      ),
    );
  }
}
