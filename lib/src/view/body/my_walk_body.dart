import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/dog_profile_dto.dart';
import 'package:dog/src/dto/mate_schedule_content_dto.dart';
import 'package:dog/src/dto/mate_schedule_dto.dart';
import 'package:dog/src/dto/my_walk_board_content_dto.dart';
import 'package:dog/src/dto/my_walk_dog_info_dto.dart';
import 'package:dog/src/dto/my_walk_schedule_content_dto.dart';
import 'package:dog/src/dto/owner_schedule_dto.dart';
import 'package:dog/src/dto/my_walking_dto.dart';
import 'package:dog/src/provider/mode_provider.dart';
import 'package:dog/src/repository/my_walk_repository.dart';
import 'package:dog/src/util/button_util.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/horizontal_divider.dart';
import 'package:dog/src/util/loading_util.dart';
import 'package:dog/src/util/text_input_util.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

class MyWalkBody extends ConsumerStatefulWidget {
  const MyWalkBody({super.key});

  @override
  ConsumerState<MyWalkBody> createState() => _MyWalkBodyState();
}

class _MyWalkBodyState extends ConsumerState<MyWalkBody> with SingleTickerProviderStateMixin {
  final double deviceWidth = GlobalVariables.width;
  final MyWalkRepository myWalkRepository = MyWalkRepository();
  final TextEditingController matchMateController = TextEditingController();

  late TabController _tabController;
  late final Future<MyWalkingDTO>? myWalkList;
  late final Future<OwnerScheduleDTO>? ownerSchedule;
  late final Future<MateScheduleDTO>? mateSchedule;

  Future<OwnerScheduleDTO> getOwnerSchedule() async {
    final Response response = await myWalkRepository.ownerScheduleList(context: context, page: 0, size: 6);
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    debugPrint('궯1: $jsonData}');
    final OwnerScheduleDTO result = OwnerScheduleDTO.fromJson(jsonData);
    return result;
  }

  Future<MyWalkingDTO> getMyWalkList() async {
    final Response response = await myWalkRepository.myWalkList(context: context, page: 0, size: 6);
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final MyWalkingDTO result = MyWalkingDTO.fromJson(jsonData);
    return result;
  }

  Future<MateScheduleDTO> getMateSchedule() async {
    final Response response = await myWalkRepository.mateScheduleList(context: context, page: 0, size: 6);
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    debugPrint('궯2: $jsonData}');
    final MateScheduleDTO result = MateScheduleDTO.fromJson(jsonData);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final mode = ref.read(modeProvider);

    if (mode) {
      // owner 모드일 때
      ownerSchedule = getOwnerSchedule();
      myWalkList = getMyWalkList();
      mateSchedule = null;
    } else {
      // walker 모드일 때
      mateSchedule = getMateSchedule();
      ownerSchedule = null;
      myWalkList = null;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget ownerMyWalk() {
    return Container(
        color: const Color(0xFFF2F2F2),
        child: FutureBuilder<OwnerScheduleDTO>(
            future: ownerSchedule,
            builder: (BuildContext context, AsyncSnapshot<OwnerScheduleDTO> snapshot) {
              if (snapshot.hasData) {
                final OwnerScheduleDTO? data = snapshot.data;

                if (data!.content.isNotEmpty) {
                  return Column(
                    children: [
                      topInfo(text: '산책 일정'),
                      ListView.builder(
                          padding: const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18),
                          itemCount: data.content.length,
                          itemBuilder: (context, index) {
                            return ownerMyWalkItem(profile: data.content[index]);
                          }
                      ),
                    ],
                  );
                } else {
                  return emptyWalk(mode: 'ownerSchedule');
                }
              } else {
                return const LoadingUtil();
              }
            }
        ),
    );
  }

  Widget ownerMyWalkItem({required OwnerScheduleContentDTO profile}) {
    return InkWell(
      onTap: () {
        // TODO: 테스트 데이터 만들어서 테스트 해보기
        // Navigator.push(
        //     context,
        //     Transition(
        //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
        //         child: DogProfileDetailTemplate(profile: profile)
        //     )
        // );
      },
      child: Container(
        width: 343.w,
        height: 142.h,
        margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
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
        padding: EdgeInsets.only(left: 23.w, top: 18.h, right: 12.w, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 53.w,
                  height: 53.h,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: CachedNetworkImage(imageUrl: profile.matePhotoUrl, fit: BoxFit.cover)
                  ),
                ),
                Container(
                  width: deviceWidth - (deviceWidth - 28) / 347 * 53 - 80,
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${profile.statTime} - ${profile.endTime}',
                            style: TextStyle(
                                color: Palette.darkFont4,
                                fontSize: 12.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Container(
                            height: 22.h,
                            width: 44.w,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Palette.green6),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '프로필',
                              style: TextStyle(
                                  color: Palette.green6,
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        profile.pickUpDay,
                        style: TextStyle(
                          color: Palette.darkFont4,
                          fontSize: 12.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            profile.mateNickname,
                            style: TextStyle(
                              color: Palette.darkFont2,
                              fontSize: 12.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${profile.feeType}: ${profile.fee}원',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Palette.darkFont2,
                              fontSize: 12.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            horizontalDivider(margin: 7.h),
            Align(
              alignment: Alignment.center,
              child: Text(
                profile.matchStatus,
                style: TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ownerMatchWalk() {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: FutureBuilder<MyWalkingDTO>(
        future: myWalkList,
        builder: (BuildContext context, AsyncSnapshot<MyWalkingDTO> snapshot) {
          if (snapshot.hasData) {
            final MyWalkingDTO? data = snapshot.data;

            if (data!.content.isNotEmpty) {
              return Column(
                children: [
                  topInfo(text: '내가 쓴 글'),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18),
                      itemCount: data.content.length,
                      itemBuilder: (context, index) {
                        final profile = data.content[index];

                        return Column(
                          children: profile.dogs.map<Widget>((dog) {
                            return ownerMatchWalkItem(profile: profile, dog: dog);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return emptyWalk(mode: 'ownerWrote');
            }
          } else {
            return const LoadingUtil();
          }
        },
      ),
    );
  }

  Widget ownerMatchWalkItem({
    required MyWalkBoardContentDTO profile,
    required MyWalkDogInfoDTO dog,
  }) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     Transition(
        //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
        //         child: DogProfileDetailTemplate(profile: profile)
        //     )
        // );
      },
      child: Container(
        width: 343.w,
        height: 220.h,
        margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
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
        padding: EdgeInsets.only(left: 23.w, top: 28.h, right: 23.w, bottom: 22.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              profile.title,
              style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 16.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              profile.pickUpDay,
              style: TextStyle(
                color: const Color(0xFF818181),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  profile.pickupLocation1,
                  style: TextStyle(
                    color: const Color(0xFF818181),
                    fontSize: 12.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    matchMateDialog();
                  },
                  child: Text(
                    '매칭하기',
                    style: TextStyle(
                      color: Palette.green6,
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            horizontalDivider(margin: 12),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 70.w,
                  height: 70.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: CachedNetworkImage(
                      imageUrl: dog.dogProfileImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dog.name,
                      style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Text(
                      '${dog.dogGender} | ${dog.age}살 | ${dog.dogType} | ${dog.breed}',
                      style: TextStyle(
                        color: const Color(0xFF818181),
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void matchMateDialog() {
    List<dynamic> userNames = [];
    OverlayEntry? overlayEntry;

    void showOverlay(BuildContext context, TextEditingController controller) {
      if (overlayEntry != null) {
        overlayEntry!.remove();
      }

      overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
              child: CompositedTransformFollower(
                link: LayerLink(),
                showWhenUnlinked: false,
                offset: Offset(0, 45),
                child: Material(
                  elevation: 4.0,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: userNames.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(userNames[index]),
                          onTap: () {
                            controller.text = userNames[index];
                            overlayEntry!.remove();
                            overlayEntry = null;
                          },
                        );
                      }
                  ),
                ),
              ),
          ),
      );

      Overlay.of(context).insert(overlayEntry!);
    }

    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r)
            ),
            backgroundColor: const Color(0xFF828282),
            insetPadding: EdgeInsets.symmetric(horizontal: 28.5.w),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.fromLTRB(17.w, 23.h, 17.w, 32.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(alignment: Alignment.centerRight, child: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.close, size: 25.w, color: Palette.green6))),
                  SizedBox(height: 8.h),
                  Text(
                    '매칭을 희망하는 산책 메이트의 \n닉네임을 검색해주세요 ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Palette.darkFont4,
                      fontSize: 16.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 38.h),
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
                    child: TextField(
                      controller: matchMateController,
                      style: TextInputUtil().textStyle,
                      textInputAction: TextInputAction.go,
                      onChanged: (value) async {
                        // 완성된 한글, 영어, 숫자, 특수 기호 정규 표현식
                        final RegExp inputRegex = RegExp(r'^[가-힣a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]+$');

                        if (value.isNotEmpty && inputRegex.hasMatch(value)) {
                          debugPrint('궯: $value');
                          await myWalkRepository.matchMate(context: context, name: value).then((response) {
                            if (response.statusCode ~/ 100 == 2) {
                              setState(() {
                                userNames = jsonDecode(response.body);
                                debugPrint('궯: $userNames');
                              });
                              showOverlay(context, matchMateController);
                            } else {
                              if (overlayEntry != null) {
                                overlayEntry!.remove();
                                overlayEntry = null;
                              }
                            }
                          });
                        }
                      },
                      onSubmitted: (value) {
                        if (overlayEntry != null) {
                          overlayEntry!.remove();
                          overlayEntry = null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      decoration: TextInputUtil().inputDecoration(hintText: '같이걷개'),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ButtonUtil(
                      width: deviceWidth - 91,
                      height: (deviceWidth - 91) / 284 * 48,
                      title: '매칭 요청하기',
                      onTap: () => Navigator.pop(context)
                  ).filledButton1m()
                ],
              ),
            ),
          );
        }
    );
  }

  Widget walkerMyWalk() {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: FutureBuilder(
          future: mateSchedule,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final MateScheduleDTO? data = snapshot.data;

              if (data!.content.isNotEmpty) {
                return Column(
                  children: [
                    topInfo(text: '산책 일정'),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 14, right: 14, top: 18, bottom: 18),
                        itemCount: data.content.length,
                        itemBuilder: (context, index) {
                          final profile = data.content[index];

                          return Column(
                            children: profile.dogs.map<Widget>((dog) {
                              return walkerMyWalkItem(profile: profile, dog: dog);
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return emptyWalk(mode: 'mateSchedule');
              }
            } else {
              return const LoadingUtil();
            }
          }
      ),
    );
  }

  Widget walkerMyWalkItem({
    required MateScheduleContentDTO profile,
    required MyWalkDogInfoDTO dog,
  }) {
    return InkWell(
      onTap: () {
        // TODO: 테스트 데이터 만들어서 테스트 해보기
        // Navigator.push(
        //     context,
        //     Transition(
        //         transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
        //         child: DogProfileDetailTemplate(profile: profile)
        //     )
        // );
      },
      child: Container(
        width: 343.w,
        height: 142.h,
        margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
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
        padding: EdgeInsets.only(left: 23.w, top: 18.h, right: 12.w, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 53.w,
                  height: 53.h,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: CachedNetworkImage(imageUrl: dog.dogProfileImage, fit: BoxFit.cover)
                  ),
                ),
                Container(
                  width: deviceWidth - (deviceWidth - 28) / 347 * 53 - 80,
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${profile.statTime} - ${profile.endTime}',
                            style: TextStyle(
                                color: Palette.darkFont4,
                                fontSize: 12.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Container(
                            height: 22.h,
                            width: 44.w,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Palette.green6),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '프로필',
                              style: TextStyle(
                                  color: Palette.green6,
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        profile.pickUpDay,
                        style: TextStyle(
                          color: Palette.darkFont4,
                          fontSize: 12.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dog.name,
                            style: TextStyle(
                              color: const Color(0xFF222222),
                              fontSize: 12.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${profile.feeType}: ${profile.fee}원',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Palette.darkFont2,
                              fontSize: 12.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            horizontalDivider(margin: 7.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 50.w),
                  Text(
                    profile.completeStatus,
                    style: TextStyle(
                      color: Palette.darkFont4,
                      fontSize: 16.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // TODO: 산책 완료를 누르면 팝업 메세지, 보냈으면 완료 처리(안보이게)
                  Text(
                    '산책완료',
                    style: TextStyle(
                      color: Palette.green6,
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topInfo({
    required String text
  }) {
    return Container(
        width: 1.sw,
        height: 50.h,
        color: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.w),
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFF222222),
            fontSize: 14.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        )
    );
  }

  Widget emptyWalk({
    required String mode
  }) {
    String mainText = '';
    String subText = '';

    switch (mode) {
      case 'ownerSchedule':
      case 'ownerWrote':
        mainText = '아직 멍뭉이의 산책 일정이 없어요';
        subText = '산책 일정을 등록하고 산책메이트를 찾아보세요!';
        break;
      case 'mateSchedule':
        mainText = '아직 멍뭉이의 산책 일정이 없어요';
        subText = '산책 일정을 확인하고 멍뭉이 메이트를 찾아보세요!';
    }

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mainText,
              style: TextStyle(
                color: Palette.darkFont4,
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              subText,
              style: TextStyle(
                color: Palette.darkFont2,
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 70.h),
            ButtonUtil(
                width: 343.w,
                height: 55.h,
                title: '산책 일정 등록하기',
                onTap: () {

                }
            ).filledButton1m(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MYLOG build MyWalkBody');

    return Consumer(
      builder: (context, ref, _) {
        final mode = ref.watch(modeProvider);
        return CommonScaffoldUtil(
          appBar: const PopHeader(title: '내 산책', useBackButton: false),
          body: mode ?
              TabBarView(
                  controller: _tabController,
                  children: [
                    ownerMyWalk(),
                    ownerMatchWalk(),
                  ],
              ) :
          walkerMyWalk(),
        );
      }
    );
  }
}