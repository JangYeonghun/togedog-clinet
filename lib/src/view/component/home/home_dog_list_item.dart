import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/dog_profile_dto.dart';
import 'package:dog/src/util/horizontal_divider.dart';
import 'package:flutter/material.dart';

class HomeDogListItem extends StatelessWidget {
  final DogProfileDTO dogProfileDTO;

  const HomeDogListItem({super.key, required this.dogProfileDTO});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: Palette.outlinedButton1),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
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
                          imageUrl: dogProfileDTO.dogImage,
                          fit: BoxFit.cover,
                      )
                  )
              ),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dogProfileDTO.name,
                    style: const TextStyle(
                      color: Palette.darkFont4,
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${dogProfileDTO.dogGender ? '수컷' : '암컷'} | ${dogProfileDTO.age}살 | ${dogProfileDTO.dogType} | ${dogProfileDTO.breed}',
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
              dogProfileDTO.region,
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
