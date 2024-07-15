import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderImage extends StatelessWidget {
  final String imgUrl;

  const ProfileHeaderImage({
    super.key,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 523.h,
      child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imgUrl
      ),
    );
  }
}
