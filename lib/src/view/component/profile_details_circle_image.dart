import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsCircleImage extends StatelessWidget {
  final String imgUrl;

  const ProfileDetailsCircleImage({
    super.key,
    required this.imgUrl
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 93.5.r,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: CachedNetworkImage(
          width: 180.r,
          height: 180.r,
          fit: BoxFit.cover,
          imageUrl: imgUrl,
        ),
      ),
    );
  }
}
