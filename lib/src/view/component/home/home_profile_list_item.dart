import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/horizontal_divider.dart';
import 'package:flutter/material.dart';

class ProfileListItem extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String gender;
  final int age;
  final String size;
  final String species;
  final String location;

  const ProfileListItem({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.gender,
    required this.age,
    required this.size,
    required this.species,
    required this.location
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
      ),
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                  child: SizedBox(
                      width: 53,
                      height: 53,
                      child: CachedNetworkImage(
                          imageUrl: imgUrl,
                          fit: BoxFit.cover,
                      )
                  )
              ),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Palette.darkFont4,
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$gender | $age살 | $size | $species',
                    style: const TextStyle(
                      color: Palette.darkFont2,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              )
            ],
          ),
          horizontalDivider(margin: 7),
          Padding(
            padding: const EdgeInsets.only(left: 62),
            child: Text(
              location,
              style: const TextStyle(
                  color: Palette.darkFont2,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      ),
    );
  }
}
