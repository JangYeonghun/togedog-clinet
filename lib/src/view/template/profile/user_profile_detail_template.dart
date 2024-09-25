import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/util/horizontal_divider.dart';
import 'package:flutter/material.dart';

class UserProfileDetailTemplate extends StatefulWidget {
  const UserProfileDetailTemplate({super.key});

  @override
  State<UserProfileDetailTemplate> createState() => _UserProfileDetailTemplateState();
}

class _UserProfileDetailTemplateState extends State<UserProfileDetailTemplate> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late Map<String, dynamic> userProfile;
  final double deviceHeight = GlobalVariables.height;
  final double deviceWidth = GlobalVariables.width;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget infoItem({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 7, bottom: 7),
      child: Row(
        children: [
          SizedBox(
            width: deviceWidth / 375 * 205 - 40,
            child: Text(
              title,
              style: const TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          Text(
            content,
            style: const TextStyle(
                color: Palette.darkFont4,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
    );
  }

  Widget miniProfile() {
    return Container(
      width: deviceWidth - 28,
      height: (deviceWidth - 28) / 347 * 143,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ]
      ),
      padding: const EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                userProfile['name'],
                style: const TextStyle(
                    color: Palette.darkFont4,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(width: 13),
              Image.asset('assets/images/edit_icon.png', width: 18, height: 18)
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  '${userProfile['gender']} | 만 ${userProfile['age']}세',
                  style: const TextStyle(
                      color: Palette.darkFont2,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              horizontalDivider(margin: 7),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  userProfile['region'],
                  style: const TextStyle(
                      color: Palette.darkFont2,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget additionalInfo() {
    return Container(
      margin: EdgeInsets.only(top: (deviceWidth - 28) / 347 * 143 - 46),
      height: deviceHeight * 0.40,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)),
          color: Colors.white
      ),
      padding: const EdgeInsets.only(top: 70, left: 36),
      child: Column(
        children: [
          Row(
            children: userProfile['hashTags'].map<Widget>((e) => hashTagItem(hashTag: e)).toList(),
          ),
          const SizedBox(height: 25),
          infoItem(title: '산책 가능 시간', content: userProfile['availableTimes'].join(', ')),
          infoItem(title: '선호 지역', content: userProfile['preferences']['region'].join(', ')),
          infoItem(title: '선호 시간', content: userProfile['preferences']['time'].join(', ')),
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 39),
            child: horizontalDivider(margin: 8)
          ),
          infoItem(title: '선호 견종 크기', content: userProfile['preferences']['size'].join(', ')),
          infoItem(title: '동반 가능한 반려견 수 ', content: '${userProfile['maxAllowedPets']}마리')
        ],
      ),
    );
  }

  Widget hashTagItem({required String hashTag}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: Palette.ghostButton1
      ),
      margin: const EdgeInsets.only(left: 4, right: 4),
      padding: const EdgeInsets.only(left: 13, right: 13, top: 7, bottom: 6),
      child: Text(
        hashTag,
        style: const TextStyle(
            color: Palette.darkFont2,
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget walkerProfileFront() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          top: 0,
          child: CachedNetworkImage(
            imageUrl: userProfile['imgUrl'],
            fit: BoxFit.cover,
            height: deviceHeight * 0.5,
            alignment: Alignment.topCenter,
          ),
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            additionalInfo(),
            miniProfile()
          ],
        )
      ],
    );
  }

  Widget walkerNote() {
    return Container(
      height: deviceHeight * 0.4,
      margin: const EdgeInsets.only(top: 132),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)),
          color: Colors.white
      ),
      padding: const EdgeInsets.only(top: 70, left: 39, right: 39),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 2),
            child: Text(
              '경력 및 경험',
              style: TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          horizontalDivider(margin: 14),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              userProfile['notes'],
              style: const TextStyle(
                color: Palette.darkFont4,
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget walkerProfileBack() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          top: 0,
          child: CachedNetworkImage(
            imageUrl: userProfile['imgUrl'],
            fit: BoxFit.cover,
            height: deviceHeight * 0.5,
            alignment: Alignment.topCenter,
          ),
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            walkerNote(),
            Container(
                width: deviceWidth / 375 * 187,
                height: deviceWidth / 375 * 187,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 4, color: Colors.white)
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: CachedNetworkImage(imageUrl: userProfile['imgUrl'], fit: BoxFit.cover)
                )
            ),
          ],
        ),
        Positioned(
          top: 50,
          left: 8,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left_outlined, color: Colors.white, size: 40)
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
            body: TabBarView(
              controller: _tabController,
              children: [
                walkerProfileFront(),
                walkerProfileBack()
              ],
            )
        )
    );
  }
}
