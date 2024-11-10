import 'dart:convert';
import 'package:dog/src/config/palette.dart';
import 'package:dog/src/dto/chat_message_dto.dart';
import 'package:dog/src/model/user_account.dart';
import 'package:dog/src/repository/chat_repository.dart';
import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:dog/src/util/image_util.dart';
import 'package:dog/src/view/component/chat/chat_message_item.dart';
import 'package:dog/src/view/component/chat/chat_separator.dart';
import 'package:dog/src/view/header/pop_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class ChatTemplate extends StatefulWidget {
  final int roomId;
  final String profileImage;
  const ChatTemplate({super.key, required this.roomId, required this.profileImage});

  @override
  State<ChatTemplate> createState() => _ChatTemplateState();
}

class _ChatTemplateState extends State<ChatTemplate> with SingleTickerProviderStateMixin {
  final TextEditingController chatController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late final StompClient client;
  XFile? imageFile;
  final String testOppNickname = 'xxxx';
  final UserAccount userAccount = UserAccount();
  bool isExpand = false;
  List<ChatMessageDTO> test = [
    ChatMessageDTO(
      userId: 32,
      content: 'ㅡㅏㅡㅏ',
      imgUrl: '',
      timestamp: '2024-09-17 00:05:07'
    ),
    ChatMessageDTO(
        userId: 32,
        content: '아오아오아오 으아으ㅏ으아 그아으아ㅡ아으ㅏ으ㅏㅇ 크ㅏ으아ㅡ아ㅡ아 으아ㅡ',
        imgUrl: '',
        timestamp: '2024-09-17 00:15:07'
    ),
    ChatMessageDTO(
        userId: 3,
        content: '테스뚜테스뚜',
        imgUrl: '',
        timestamp: '2024-09-22 14:01:05'
    ),
    ChatMessageDTO(
      userId: 3,
      content: '테테테테ㅔㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ먀내얻쟈ㅐㅓ애ㅑㄷ저래ㅑㅈ더랟ㅈ더랴ㅐㅈ더랟저래ㅑㅈ더랴ㅐㅓㄴ이ㅏ러나이러ㅏㅣㄴ러ㅏ닝러ㅏㅣㅇ너링나ㅓ리낭렁니ㅏ러ㅏㄴ이러ㅏㅇ니러ㅏㅇ니ㅓ링나ㅓㄹㅇ니ㅏㅐ더래ㅑ더ㅑㅐ',
      imgUrl: '',
      timestamp: '2024-09-22 14:01:10',
    ),
    ChatMessageDTO(
      userId: 3,
      content: '테스뚜테스뚜',
      imgUrl: '',
      timestamp: '2024-09-23 00:01:05',
    ),
    ChatMessageDTO(
      userId: 32,
      content: '테스뚜테스뚜',
      imgUrl: '',
      timestamp: '2024-09-23 00:05:07',
    ),
    ChatMessageDTO(
      userId: 3,
      content: 'ㄴㄴㄴㄴㄴㅈ댜러ㅐㅑㅈ더ㅓㅈ대러ㅐㅈ',
      imgUrl: '',
      timestamp: '2024-09-23 00:06:03',
    ),
    ChatMessageDTO(
      userId: 32,
      content: '',
      imgUrl: 'https://miro.medium.com/v2/resize:fit:4800/format:webp/1*y7yPy0OrJyeCOscaFAPwBg.jpeg',
      timestamp: '2024-09-23 00:15:00',
    ),
    ChatMessageDTO(
      userId: 32,
      content: 'ㅇㅇddd',
      imgUrl: '',
      timestamp: '2024-09-23 00:15:59',
    ),
    ChatMessageDTO(
      userId: 32,
      content: 'ㅇㅇ',
      imgUrl: '',
      timestamp: '2024-09-23 00:17:07',
    ),
    ChatMessageDTO(
      userId: 32,
      content: '이예아우와야이야아',
      imgUrl: '',
      timestamp: '2024-09-24 13:12:07',
    ),
  ];

  late List<ChatMessageDTO> rList;

  void connect() {
    client = StompClient(
        config: StompConfig.sockJS(
          url: "https://www.walktogedog.life/ws",
          onConnect: onConnectCallback,
          onWebSocketError: (dynamic error) => debugPrint('SOCKET_ERR: $error'),
          onStompError: (dynamic error) => debugPrint('STOMP_ERR: $error'),
          onDisconnect: (StompFrame frame) => debugPrint('DISCONN: ${frame.headers}\n${frame.body}')
        )
    );
    debugPrint('Connecting...');
    client.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    debugPrint('callback');
    debugPrint('Connection: ${client.connected}, ${client.isActive}');

    try {
      client.subscribe(
          destination: '/sub/chat/room/${widget.roomId}',
          callback: (stompFrame) {
            debugPrint('Message received');
            debugPrint(stompFrame.body);
            if (stompFrame.body == null) return;
            final Map<String, dynamic> body = jsonDecode(stompFrame.body!);
            handleMessage(dto: ChatMessageDTO.fromJson(body));
          }
      );
    } catch(e) {
      debugPrint('CHAT_SUB_ERR: $e');
    }
  }

  void send() async {
    if (imageFile == null && chatController.text.isEmpty) return;

    String imageUrl = '';
    if (imageFile != null) {
      final Response response = await ChatRepository().uploadImage(image: imageFile!);
      if (response.statusCode ~/ 100 == 2) {
        imageUrl = response.body;
      }
    }

    final Map<String, dynamic> message = {
      'roomId': widget.roomId,
      'userId': userAccount.getUUID(),
      'content': chatController.text,
      'lastTime': DateTime.now().toUtc().toString(),
      'image': imageUrl
    };

    try {
      client.send(
          destination: '/pub/chat',
          body: jsonEncode(message)
      );
    } catch(e) {
      debugPrint('CHAT_ERR: $e');
    }

    debugPrint('Send message');
    debugPrint(message.toString());
  }

  @override
  void dispose() {
    client.deactivate();
    scrollController.dispose();
    chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ChatRepository().unreadMessage(roomId: widget.roomId, lastTime: DateTime.now().toString());
    connect();
    rList = test.reversed.toList();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  Widget msgList() {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            isExpand = false;
            controller.reverse();
          });
        },
        child: Container(
          color: const Color(0xFFF2F2F2),
          alignment: Alignment.topCenter,
          child: ListView.separated(
            reverse: true,
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            padding: EdgeInsets.only(top: 10.h, left: 14.w, right: 14.w),
            itemCount: rList.length,
            itemBuilder: (context, index) {
              final ChatMessageDTO currentMessage = rList[index];
              final bool isFirst = index == rList.length - 1;

              return ChatMessageItem(
                isMine: currentMessage.userId == userAccount.getUUID(),
                currentMessage: currentMessage,
                previousMessage: isFirst ? null : rList[index + 1],
                nextMessage: index == 0 ? null : rList[index - 1],
                isFirst: isFirst,
                profileImage: widget.profileImage,
              );
            },
            separatorBuilder: (context, index) {
              final ChatMessageDTO currentMessage = rList[index];
              final ChatMessageDTO? nextMessage = rList.length - 1 != index ? rList[index + 1] : null;
              return ChatSeparator(
                currentMessage: currentMessage,
                nextMessage: nextMessage,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget inputBoxExtend() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: isExpand ? 290 : 0,
      color: const Color(0xFFF2F2F2),
      padding: EdgeInsets.only(left: 40.w, right: 40.w, top: 28.h, bottom: 28.h),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () async {
                      imageFile = await ImageUtil().getImage(
                          context: context,
                          imageSource: ImageSource.gallery
                      );
                      send();
                    },
                    child: Image.asset('assets/images/photo_icon.png', width: 50.w)
                ),
                SizedBox(height: 6.h),
                Text(
                    '사진',
                    style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    )
                )
              ],
            ),
            SizedBox(width: 24.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () async {
                      imageFile = await ImageUtil().getImage(
                          context: context,
                          imageSource: ImageSource.camera
                      );
                      send();
                    },
                    child: Image.asset('assets/images/camera_icon.png', width: 50.w)
                ),
                SizedBox(height: 6.h),
                Text(
                    '카메라',
                    style: TextStyle(
                        color: Palette.darkFont4,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  late final AnimationController controller;

  Widget inputBoxMain() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.fromLTRB(14.w, isExpand ? 12.h : 20.h, 14.w, isExpand ? 8.h : 20.h),
      color: const Color(0xFFF2F2F2),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  if (isExpand) {
                    isExpand = false;
                    controller.reverse();
                    return;
                  }

                  isExpand = true;
                  controller.forward();

                });
              },
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: controller.value * 0.785398,
                      child: Icon(Icons.add_rounded, color: Palette.green6, size: 30.w)
                    );
                  }
                ),
              )
          ),
          SizedBox(width: 10.w),
          Flexible(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                ),
                child: RawScrollbar(
                  controller: scrollController,
                  radius: const Radius.circular(10),
                  thickness: 2,
                  thumbVisibility: true,
                  padding: EdgeInsets.only(top: 6.h, right: 3.w, bottom: -16.h),
                  child: TextField(
                    scrollController: scrollController,
                    controller: chatController,
                    minLines: 1,
                    maxLines: 5,
                    onTap: () {
                      setState(() {
                        isExpand = false;
                        controller.reverse();
                      });
                    },
                    decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.only(left: 10.w, right: 10.w, top: 11.h, bottom: 11.h),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide.none
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none
                        )
                    ),
                    cursorColor: Palette.green6,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              )
          ),
          SizedBox(width: 10.w),
          GestureDetector(
              onTap: () {
                send();
              },
              child: Image.asset('assets/images/send_button.png', width: 36.w)
          ),
        ],
      ),
    );
  }

  void handleMessage({
    required ChatMessageDTO dto
  }) {
    test.add(dto);

    rList = test.reversed.toList();

    chatController.text = '';

    setState(() {
      isExpand = false;
      controller.reverse();
    });
  }

  Widget inputBox() {

    return Column(
      children: [
        inputBoxMain(),
        inputBoxExtend()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
        appBar: PopHeader(title: testOppNickname, useBackButton: true),
        body: PopScope(
          canPop: false,
          onPopInvoked: (pop) {
            if (isExpand) {
              setState(() {
                isExpand = false;
                controller.reverse();
              });
              return;
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
            return;
          },
          child: Column(
            children: [
              msgList(),
              inputBox()
            ],
          ),
        )
    );
  }
}