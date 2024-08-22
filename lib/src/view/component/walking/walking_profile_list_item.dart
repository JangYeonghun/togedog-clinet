import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/horizontal_divider.dart';
import 'package:flutter/material.dart';

class WalkingProfileListItem extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String gender;
  final int age;
  final String size;
  final String species;
  final String location;
  final String title;
  final String date;
  final String address;

  const WalkingProfileListItem({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.gender,
    required this.age,
    required this.size,
    required this.species,
    required this.location,
    required this.title,
    required this.date,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 347,
      height: 220,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(25, 34, 25, 20),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF222222),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            date,
            style: const TextStyle(
              color: Color(0xFF818181),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            address,
            style: const TextStyle(
              color: Color(0xFF818181),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
            ),
          ),
          horizontalDivider(margin: 13),
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
                  const SizedBox(height: 13),
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
        ],
      ),
    );
  }
}
